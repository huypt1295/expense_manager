import 'dart:io';
import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/add_transaction_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/add_transaction_event.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/add_transaction_state.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/constants/expense_constants.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/helpers/expense_image_helper.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_divider.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_form_fields.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_image_source_bottom_sheet.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_or_income_selection.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_scan_section.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_submit_button.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_user_category_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

class AddExpenseBottomSheet extends BaseStatefulWidget {
  const AddExpenseBottomSheet({super.key, this.transaction});

  final TransactionEntity? transaction;

  @override
  BaseState<AddExpenseBottomSheet> createState() =>
      _ExpenseFormBottomSheetState();
}

class _ExpenseFormBottomSheetState extends BaseState<AddExpenseBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategoryId;
  String? _pendingCategoryName;
  DateTime _selectedDate = DateTime.now();
  TransactionType _type = TransactionType.expense;
  File? _selectedImage;
  bool _isProcessingImage = false;

  @override
  void onInitState() {
    super.onInitState();
    final transaction = widget.transaction;
    if (transaction != null) {
      _titleController.text = transaction.title;
      _amountController.text = CurrencyUtils.formatVndFromDouble(
        transaction.amount,
      );
      _descriptionController.text = transaction.note ?? '';
      _selectedDate = transaction.date;
      _type = transaction.type;
      _selectedCategoryId = transaction.category;
      _selectedCategoryId = (transaction.categoryId?.isNotEmpty ?? false)
          ? transaction.categoryId
          : null;
      _pendingCategoryName = transaction.category;
    }
  }

  @override
  void onDispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    ExpenseImageHelper.dispose();
    super.onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          tpGetIt.get<AddTransactionBloc>()..add(AddTransactionInitEvent()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddTransactionBloc, AddTransactionState>(
            listenWhen: (previous, current) =>
                previous.categories != current.categories,
            listener: (context, state) {
              _syncSelectedCategory(state.categories);
            },
          ),
          BlocListener<AddTransactionBloc, AddTransactionState>(
            listenWhen: (previous, current) =>
                current is AddTransactionSuccessState ||
                current is AddTransactionErrorState,
            listener: (context, state) {
              if (state is AddTransactionSuccessState) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense saved successfully!')),
                );
              } else if (state is AddTransactionErrorState) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: CommonBottomSheet(
          title: widget.transaction == null
              ? S.current.add_transaction
              : S.current.edit_transaction,
          heightFactor: 0.9,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => ViewUtils.hideKeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTypeSelection(),
                  const SizedBox(height: 16),
                  _buildAIScanWidget(),
                  const SizedBox(height: 8),
                  _buildDivider(),
                  const SizedBox(height: 8),
                  _buildFormSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return AddExpenseOrIncomeSelection(
      onTypeChanged: (type) {
        setState(() {
          _type = type;
        });
      },
    );
  }

  Widget _buildAIScanWidget() {
    return AddExpenseScanSection(
      onScanPressed: _showImageSourceOptions,
      isProcessing: _isProcessingImage,
      selectedImage: _selectedImage,
      onRemoveImage: _removeSelectedImage,
    );
  }

  Widget _buildDivider() {
    return AddExpenseDivider();
  }

  Widget _buildFormSection() {
    final localeCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';

    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.areCategoriesLoading != current.areCategoriesLoading ||
          previous.categoriesError != current.categoriesError,
      builder: (context, state) {
        final categories = state.categories
            .where((c) => (c.type == _type))
            .toList();
        return Column(
          children: [
            AddExpenseFormFields(
              formKey: _formKey,
              titleController: _titleController,
              amountController: _amountController,
              descriptionController: _descriptionController,
              selectedCategoryId: _selectedCategoryId,
              selectedDate: _selectedDate,
              categories: categories,
              localeCode: localeCode,
              categoriesLoading: state.areCategoriesLoading,
              categoriesError: state.categoriesError,
              onRetryCategories: () => context.read<AddTransactionBloc>().add(
                AddTransactionInitEvent(forceRefresh: true),
              ),
              onCategoryChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              onDateSelected: _selectDate,
              onAddCategoryTap: _onAddCategoryTap,
            ),
            const SizedBox(height: 24),
            AddExpenseSubmitButton(
              type: _type,
              onPressed: () => _submitForm(context),
            ),
          ],
        );
      },
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final amount =
          CurrencyUtils.parseVndToDouble(_amountController.text) ?? 0.0;

      final categories = context.read<AddTransactionBloc>().state.categories;
      final selected = _findCategoryById(_selectedCategoryId, categories);

      if (selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final localeCode =
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
      final categoryName = selected.nameForLocale(localeCode);

      final initial = widget.transaction;
      final entity =
          (initial ??
                  TransactionEntity(
                    id: '',
                    title: _titleController.text,
                    amount: amount,
                    date: _selectedDate,
                    type: _type,
                    category: categoryName,
                    note: _descriptionController.text,
                    categoryId: selected.id,
                    categoryIcon: selected.icon,
                  ))
              .copyWith(
                title: _titleController.text,
                amount: amount,
                date: _selectedDate,
                type: _type,
                category: categoryName,
                note: _descriptionController.text,
                categoryId: selected.id,
                categoryIcon: selected.icon,
              );

      final bloc = context.read<AddTransactionBloc>();
      if (initial == null) {
        bloc.add(TransactionsAddedEvent(entity));
      } else {
        bloc.add(TransactionsUpdatedEvent(entity));
      }
      context.pop();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ImageSourceBottomSheet(
        onCameraPressed: () {
          context.pop();
          _scanWithCamera();
        },
        onGalleryPressed: () {
          context.pop();
          _pickFromGallery();
        },
      ),
    );
  }

  Future<void> _scanWithCamera() async {
    try {
      setState(() {
        _isProcessingImage = true;
      });

      final File? imageFile = await ExpenseImageHelper.pickImageFromCamera();
      if (imageFile != null) {
        await _processSelectedImage(imageFile);
      }
    } catch (e) {
      if (mounted) {
        ExpenseImageHelper.showErrorSnackBar(context, e.toString());
      }
    } finally {
      setState(() {
        _isProcessingImage = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      setState(() {
        _isProcessingImage = true;
      });

      final File? imageFile = await ExpenseImageHelper.pickImageFromGallery();
      if (imageFile != null) {
        await _processSelectedImage(imageFile);
      }
    } catch (e) {
      if (mounted) {
        ExpenseImageHelper.showErrorSnackBar(context, e.toString());
      }
    } finally {
      setState(() {
        _isProcessingImage = false;
      });
    }
  }

  Future<void> _processSelectedImage(File imageFile) async {
    setState(() {
      _selectedImage = imageFile;
    });

    ExpenseImageHelper.showProcessingSnackBar(context);

    try {
      final extractedData = await ExpenseImageHelper.processImageWithAI(
        imageFile,
      );

      // Check if widget is still mounted before using context
      if (mounted) {
        _populateFormWithExtractedData(extractedData);
        ExpenseImageHelper.showSuccessSnackBar(
          context,
          ExpenseConstants.successMessage,
        );
      }
    } catch (e) {
      // Check if widget is still mounted before using context
      if (mounted) {
        ExpenseImageHelper.showErrorSnackBar(
          context,
          'Failed to process image: ${e.toString()}',
        );
      }
    }
  }

  void _populateFormWithExtractedData(Map<String, dynamic> data) {
    final categories = context.read<AddTransactionBloc>().state.categories;
    setState(() {
      _titleController.text = data['title'] ?? '';
      _setFormattedAmount(data['amount']);
      _selectCategoryByName(data['category'] as String?, categories);
      _descriptionController.text = data['description'] ?? '';
    });
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _setFormattedAmount(dynamic value) {
    final raw = value?.toString() ?? '';
    final digits = CurrencyUtils.digitsOnly(raw);
    if (digits.isEmpty) {
      _amountController.clear();
      return;
    }

    final formatted = CurrencyUtils.formatVnd(digits);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _syncSelectedCategory(List<CategoryEntity> categories) {
    String? nextSelected = _selectedCategoryId;
    String? nextPending = _pendingCategoryName;

    if (categories.isEmpty) {
      nextSelected = null;
    } else if (nextSelected != null &&
        categories.any((category) => category.id == nextSelected) &&
        (nextPending == null || nextPending.isEmpty)) {
      return;
    } else if ((nextPending?.isNotEmpty ?? false)) {
      final match = _findCategoryByName(nextPending!, categories);
      if (match != null) {
        nextSelected = match.id;
        nextPending = null;
      } else {
        nextSelected = categories.first.id;
      }
    } else {
      nextSelected = categories.first.id;
    }

    if (nextSelected != _selectedCategoryId ||
        nextPending != _pendingCategoryName) {
      setState(() {
        _selectedCategoryId = nextSelected;
        _pendingCategoryName = nextPending;
      });
    }
  }

  Future<void> _onAddCategoryTap() async {
    final draft = await showModalBottomSheet<UserCategoryDraft>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddUserCategoryBottomSheet(initialType: _type);
      },
    );

    if (draft == null || !mounted) {
      return;
    }

    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
    final categoriesService = tpGetIt.get<CategoriesService>();
    final entity = CategoryEntity(
      id: '',
      icon: draft.icon,
      isActive: true,
      type: draft.type,
      names: {locale: draft.name},
      isCustom: true,
    );

    try {
      final created = await categoriesService.createUserCategory(entity);

      if (!mounted) {
        return;
      }

      context.read<AddTransactionBloc>().add(
        AddTransactionInitEvent(forceRefresh: true),
      );

      setState(() {
        _type = draft.type;
        _selectedCategoryId = created.id;
        _pendingCategoryName = draft.name;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã thêm danh mục mới')));
    } catch (error) {
      final message = error is Failure
          ? (error.message ?? error.code)
          : 'Không thể tạo danh mục. Vui lòng thử lại.';
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _selectCategoryByName(String? name, List<CategoryEntity> categories) {
    if (name == null || name.trim().isEmpty) {
      _pendingCategoryName = null;
      return;
    }
    final match = _findCategoryByName(name, categories);
    if (match != null) {
      _pendingCategoryName = null;
      _selectedCategoryId = match.id;
    } else {
      _pendingCategoryName = name;
    }
  }

  CategoryEntity? _findCategoryByName(
    String name,
    List<CategoryEntity> categories,
  ) {
    final normalized = name.toLowerCase().trim();
    for (final category in categories) {
      if (category.id.toLowerCase().trim() == normalized) {
        return category;
      }
      final matchesName = category.names.values.any(
        (value) => value.toLowerCase().trim() == normalized,
      );
      if (matchesName) {
        return category;
      }
    }
    return null;
  }

  CategoryEntity? _findCategoryById(
    String? id,
    List<CategoryEntity> categories,
  ) {
    if (id == null || id.isEmpty) {
      return null;
    }
    for (final category in categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
}
