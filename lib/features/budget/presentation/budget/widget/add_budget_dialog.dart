import 'package:expense_manager/features/budget/domain/entities/budget_entity.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:intl/intl.dart';

class AddBudgetDialog extends StatefulWidget {
  const AddBudgetDialog({super.key, this.initial});

  final BudgetEntity? initial;

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  late final TextEditingController _limitController;
  late DateTime _startDate;
  late DateTime _endDate;
  final DateFormat _dateFormatter = DateFormat.yMMMd();

  late final CategoriesService _categoriesService;
  List<CategoryEntity> _categories = const <CategoryEntity>[];
  bool _isCategoriesLoading = true;
  String? _categoriesError;
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
    _startDate = initial?.startDate ?? DateTime.now();
    _endDate = initial?.endDate ?? DateTime.now().add(const Duration(days: 30));
    _selectedCategoryId = (initial?.categoryId.isNotEmpty ?? false)
        ? initial!.categoryId
        : null;
    _initialCategoryName = initial?.category;

    _categoriesService = tpGetIt.get<CategoriesService>();
    _loadCategories();
  }

  void _ensureSelectedCategory() {
    if (_categories.isEmpty) {
      _selectedCategoryId = null;
      return;
    }

    if (_selectedCategoryId != null &&
        _categories.any((category) => category.id == _selectedCategoryId)) {
      return;
    }

    if ((_initialCategoryName?.isNotEmpty ?? false)) {
      final matchByName = _categories.firstWhere(
        (category) => category.name.values.any(
          (value) =>
              value.toLowerCase().trim() ==
              _initialCategoryName!.toLowerCase().trim(),
        ),
        orElse: () => _categories.first,
      );
      _selectedCategoryId = matchByName.id;
      _initialCategoryName = null;
      return;
    }

    _selectedCategoryId = _categories.first.id;
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories({bool forceRefresh = false}) async {
    setState(() {
      _isCategoriesLoading = true;
      _categoriesError = null;
    });

    try {
      final categories = await _categoriesService.getCategories(
        forceRefresh: forceRefresh,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _isCategoriesLoading = false;
        _categories = categories;
        _ensureSelectedCategory();
      });
    } catch (error) {
      final message = error is Failure
          ? (error.message ?? error.code)
          : 'Failed to load categories';
      if (!mounted) {
        return;
      }
      setState(() {
        _isCategoriesLoading = false;
        _categoriesError = message;
      });
    }
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

  void _submit(BuildContext context) {
    final limit = CurrencyUtils.parseVndToDouble(_limitController.text);
    CategoryEntity? selected;
    for (final category in _categories) {
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

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initial;
    return AlertDialog(
      title: Text(initial == null ? 'Create budget' : 'Edit budget'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryField(context),
            const SizedBox(height: 12),
            TextField(
              controller: _limitController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [VndCurrencyInputFormatter()],
              decoration: const InputDecoration(labelText: 'Limit amount'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start date'),
                    Text(_dateFormatter.format(_startDate)),
                  ],
                ),
                TextButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End date'),
                    Text(_dateFormatter.format(_endDate)),
                  ],
                ),
                TextButton(
                  onPressed: () => _pickDate(isStart: false),
                  child: const Text('Change'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _submit(context),
          child: Text(initial == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    if (_isCategoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categoriesError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _categoriesError!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _loadCategories(forceRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (_categories.isEmpty) {
      return const Text('No categories available');
    }

    final localeCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';

    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: const InputDecoration(labelText: 'Category'),
      items: _categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.nameForLocale(localeCode)),
            ),
          )
          .toList(growable: false),
      onChanged: (value) {
        setState(() {
          _selectedCategoryId = value;
        });
      },
    );
  }
}
