import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget/add_budget_cancel_button.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget/add_budget_category_field.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget/add_budget_end_date_field.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget/add_budget_start_date_field.dart';
import 'package:expense_manager/features/budget/presentation/budget/widget/add_budget/add_budget_submit_button.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetDialog extends BaseStatefulWidget {
  const AddBudgetDialog({super.key, this.initial});

  final BudgetEntity? initial;

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends BaseState<AddBudgetDialog> {
  late final TextEditingController _limitController;
  late DateTime _startDate;
  late DateTime _endDate;

  String? _selectedCategoryId;
  String? _initialCategoryName;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    final initialLimit = initial?.limitAmount;
    _limitController = TextEditingController(
      text: initialLimit != null
          ? CurrencyUtils.formatVnd(initialLimit.toStringAsFixed(0))
          : '',
    );
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
    _startDate = initial?.startDate ?? currentMonthStart;
    _endDate = initial?.endDate ?? currentMonthEnd;
    _selectedCategoryId = (initial?.categoryId.isNotEmpty ?? false)
        ? initial!.categoryId
        : null;
    _initialCategoryName = initial?.category;

    final bloc = context.read<BudgetBloc>();
    bloc.add(const BudgetCategoriesRequested());
    final categories = bloc.state.categories;
    if (categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _syncSelectedCategory(categories);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initial;
    return BlocListener<BudgetBloc, BudgetState>(
      listenWhen: (previous, current) =>
          previous.categories != current.categories,
      listener: (context, state) {
        _syncSelectedCategory(state.categories);
      },
      child: AlertDialog(
        title: Text(initial == null ? 'Create budget' : 'Edit budget'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddBudgetCategoryField(
                selectedCategoryId: _selectedCategoryId,
                onCategoryIdChanged: (value) => _selectedCategoryId = value,
              ),
              const SizedBox(height: 12),
              _buildLimitAmountField(),
              const SizedBox(height: 12),
              AddBudgetStartDateField(
                onPressed: () => _pickDate(isStart: true),
                startDate: _startDate,
              ),
              const SizedBox(height: 12),
              AddBudgetEndDateField(
                onPressed: () => _pickDate(isStart: false),
                endDate: _endDate,
              ),
            ],
          ),
        ),
        actions: [
          AddBudgetCancelButton(),
          AddBudgetSubmitButton(
            onSubmit: () => _submit(context),
            isInitial: initial != null,
          ),
        ],
      ),
    );
  }

  TextField _buildLimitAmountField() {
    return TextField(
      controller: _limitController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: const [VndCurrencyInputFormatter()],
      decoration: const InputDecoration(labelText: 'Limit amount'),
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = picked.isBefore(_startDate) ? _startDate : picked;
      }
    });
  }

  void _syncSelectedCategory(List<CategoryEntity> categories) {
    String? nextSelected = _selectedCategoryId;
    String? nextInitialName = _initialCategoryName;

    if (categories.isEmpty) {
      nextSelected = null;
    } else if (nextSelected != null &&
        categories.any((category) => category.id == nextSelected)) {
      return;
    } else if ((nextInitialName?.isNotEmpty ?? false)) {
      final initialName = nextInitialName!;
      final matchByName = categories.firstWhere(
        (category) => category.name.values.any(
          (value) =>
              value.toLowerCase().trim() == initialName.toLowerCase().trim(),
        ),
        orElse: () => categories.first,
      );
      nextSelected = matchByName.id;
      nextInitialName = null;
    } else {
      nextSelected = categories.first.id;
    }

    if (nextSelected != _selectedCategoryId ||
        nextInitialName != _initialCategoryName) {
      setState(() {
        _selectedCategoryId = nextSelected;
        _initialCategoryName = nextInitialName;
      });
    }
  }

  void _submit(BuildContext context) {
    final limit = CurrencyUtils.parseVndToDouble(_limitController.text);
    final categories = context.read<BudgetBloc>().state.categories;
    CategoryEntity? selected;
    for (final category in categories) {
      if (category.id == _selectedCategoryId) {
        selected = category;
        break;
      }
    }

    if (selected == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }
    if (limit == null || limit <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid limit amount')));
      return;
    }

    final localeCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
    final categoryName = selected.nameForLocale(localeCode);

    final initial = widget.initial;
    final entity =
        (initial ??
                BudgetEntity(
                  id: '',
                  category: categoryName,
                  limitAmount: limit,
                  startDate: _startDate,
                  endDate: _endDate,
                  categoryId: selected.id,
                ))
            .copyWith(
              category: categoryName,
              limitAmount: limit,
              startDate: _startDate,
              endDate: _endDate,
              categoryId: selected.id,
            );

    final bloc = context.read<BudgetBloc>();
    if (initial == null) {
      bloc.add(BudgetAdded(entity));
    } else {
      bloc.add(BudgetUpdated(entity));
    }

    context.pop();
  }
}
