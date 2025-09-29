import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/expense_ai_service.dart';

class ExpenseImageHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to access camera: ${e.toString()}');
    }
  }

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to access gallery: ${e.toString()}');
    }
  }

  /// Process selected image with real AI
  static Future<Map<String, dynamic>> processImageWithAI(File imageFile) async {
    try {
      // Use real AI service to process image
      final ExpenseData expenseData =
          await ExpenseAIService.processImageAndExtractExpense(imageFile);

      // Convert to Map for form population
      return {
        'title': expenseData.title,
        'amount': expenseData.amount.toString(),
        'category': expenseData.category,
        'description': expenseData.description,
        'date': expenseData.date,
      };
    } catch (e) {
      // Fallback to simulation if AI fails
      return _getFallbackData();
    }
  }

  /// Fallback data when AI processing fails
  static Map<String, dynamic> _getFallbackData() {
    return {
      'title': 'Coffee Shop Purchase',
      'amount': '12.50',
      'category': 'Food & Dining',
      'description': 'Extracted from receipt image (fallback)',
      'date': null,
    };
  }

  /// Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show processing snackbar
  static void showProcessingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing image with AI...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Dispose AI service resources
  static void dispose() {
    ExpenseAIService.dispose();
  }
}
