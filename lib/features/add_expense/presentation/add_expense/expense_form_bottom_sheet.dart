import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_bloc.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_event.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/bloc/expense_state.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/constants/expense_constants.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/helpers/expense_image_helper.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/widgets/expense_scan_section.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/widgets/expense_form_fields.dart';
import 'package:expense_manager/features/add_expense/presentation/add_expense/widgets/image_source_bottom_sheet.dart';

class ExpenseFormBottomSheet extends BaseStatefulWidget {
  const ExpenseFormBottomSheet({super.key});

  @override
  BaseState<ExpenseFormBottomSheet> createState() =>
      _ExpenseFormBottomSheetState();
}

class _ExpenseFormBottomSheetState extends BaseState<ExpenseFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isProcessingImage = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    ExpenseImageHelper.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      context.read<ExpenseBloc>().add(ExpenseFormSubmitted(
            title: _titleController.text,
            amount: amount,
            category: _selectedCategory,
            description: _descriptionController.text,
            date: _selectedDate,
          ));
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
          Navigator.of(context).pop();
          _scanWithCamera();
        },
        onGalleryPressed: () {
          Navigator.of(context).pop();
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
    Log.d('pickFromGallery');
    try {
      setState(() {
        _isProcessingImage = true;
      });

      final File? imageFile = await ExpenseImageHelper.pickImageFromGallery();
      if (imageFile != null) {
        print('imageFile: $imageFile');
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
      final extractedData =
          await ExpenseImageHelper.processImageWithAI(imageFile);

      // Check if widget is still mounted before using context
      if (mounted) {
        _populateFormWithExtractedData(extractedData);
        ExpenseImageHelper.showSuccessSnackBar(
            context, ExpenseConstants.successMessage);
      }
    } catch (e) {
      // Check if widget is still mounted before using context
      if (mounted) {
        ExpenseImageHelper.showErrorSnackBar(
            context, 'Failed to process image: ${e.toString()}');
      }
    }
  }

  void _populateFormWithExtractedData(Map<String, dynamic> data) {
    setState(() {
      _titleController.text = data['title'] ?? '';
      _amountController.text = data['amount'] ?? '';
      _selectedCategory = data['category'] ?? '';
      _descriptionController.text = data['description'] ?? '';
    });
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
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
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
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
              selectedCategory: _selectedCategory,
              selectedDate: _selectedDate,
              categories: ExpenseConstants.categories,
              onCategoryChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? '';
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
          onPressed: state is ExpenseFormLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: state is ExpenseFormLoading
              ? const CircularProgressIndicator()
              : const Text(
                  'Save Expense',
                  style: TextStyle(fontSize: 16),
                ),
        );
      },
    );
  }
}
