import 'dart:io';
import 'package:expense_manager/features/transactions/presentation/add_transaction/constants/expense_constants.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/helpers/expense_image_helper.dart';
import 'package:expense_manager/features/categories/application/categories_service.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/expense_form_fields.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/expense_scan_section.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/image_source_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/expense_bloc.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/expense_event.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/bloc/expense_state.dart';

class AddExpenseBottomSheet extends BaseStatefulWidget {
  const AddExpenseBottomSheet({super.key});

  @override
  BaseState<AddExpenseBottomSheet> createState() =>
      _ExpenseFormBottomSheetState();
}

class _ExpenseFormBottomSheetState extends BaseState<AddExpenseBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final CategoriesService _categoriesService;
  List<CategoryEntity> _categories = const [];
  bool _isCategoriesLoading = true;
  String? _categoriesError;
  String? _selectedCategoryId;
  String? _pendingCategoryName;
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isProcessingImage = false;

  @override
  void initState() {
    super.initState();
    _categoriesService = tpGetIt.get<CategoriesService>();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    ExpenseImageHelper.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final amount = CurrencyUtils.parseVndToDouble(_amountController.text) ?? 0.0;

      final selected = _findCategoryById(_selectedCategoryId);

      if (selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      final localeCode =
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
      final categoryName = selected.nameForLocale(localeCode);

      context.read<ExpenseBloc>().add(
        ExpenseFormSubmitted(
          title: _titleController.text,
          amount: amount,
          category: categoryName,
          description: _descriptionController.text,
          date: _selectedDate,
        ),
      );
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
    setState(() {
      _titleController.text = data['title'] ?? '';
      _setFormattedAmount(data['amount']);
      _selectCategoryByName(data['category'] as String?);
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

  void _ensureSelectedCategory() {
    if (_categories.isEmpty) {
      _selectedCategoryId = null;
      return;
    }

    if (_selectedCategoryId != null &&
        _categories.any((category) => category.id == _selectedCategoryId)) {
      return;
    }

    if (_pendingCategoryName?.isNotEmpty ?? false) {
      final match = _findCategoryByName(_pendingCategoryName!);
      if (match != null) {
        _selectedCategoryId = match.id;
        _pendingCategoryName = null;
        return;
      }
    }

    _selectedCategoryId = _categories.first.id;
  }

  void _selectCategoryByName(String? name) {
    if (name == null || name.trim().isEmpty) {
      _pendingCategoryName = null;
      return;
    }
    final match = _findCategoryByName(name);
    if (match != null) {
      _pendingCategoryName = null;
      _selectedCategoryId = match.id;
    } else {
      _pendingCategoryName = name;
    }
  }

  CategoryEntity? _findCategoryByName(String name) {
    final normalized = name.toLowerCase().trim();
    for (final category in _categories) {
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

  CategoryEntity? _findCategoryById(String? id) {
    if (id == null || id.isEmpty) {
      return null;
    }
    for (final category in _categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseFormSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense saved successfully!')),
          );
        } else if (state is ExpenseFormError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              _buildHandleBar(),
              _buildHeader(),
              ExpenseScanSection(
                onScanPressed: _showImageSourceOptions,
                isProcessing: _isProcessingImage,
                selectedImage: _selectedImage,
                onRemoveImage: _removeSelectedImage,
              ),
              _buildDivider(),
              _buildFormSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add New Expense',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'OR',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    final localeCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ExpenseFormFields(
              formKey: _formKey,
              titleController: _titleController,
              amountController: _amountController,
              descriptionController: _descriptionController,
              selectedCategoryId: _selectedCategoryId,
              selectedDate: _selectedDate,
              categories: _categories,
              localeCode: localeCode,
              categoriesLoading: _isCategoriesLoading,
              categoriesError: _categoriesError,
              onRetryCategories: () => _loadCategories(forceRefresh: true),
              onCategoryChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
              onDateSelected: _selectDate,
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () =>
              state is ExpenseFormLoading ? null : _submitForm(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: state is ExpenseFormLoading
              ? const CircularProgressIndicator()
              : const Text('Save Expense', style: TextStyle(fontSize: 16)),
        );
      },
    );
  }
}
