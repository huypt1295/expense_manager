import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_ml_kit/google_ml_kit.dart';

class ExpenseData {
  final String title;
  final double amount;
  final String category;
  final String description;
  final DateTime? date;

  const ExpenseData({
    required this.title,
    required this.amount,
    required this.category,
    required this.description,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date?.toIso8601String(),
    };
  }

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      title: json['title'] ?? 'Unknown Expense',
      amount: (json['amount'] ?? 0.0).toDouble(),
      category: json['category'] ?? 'Other',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
    );
  }
}

class ExpenseAIService {
  static const String _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyAg0jBmIxM8hEK_j84Z872BUpqSEtAB6K8';

  static final TextRecognizer _textRecognizer =
      GoogleMlKit.vision.textRecognizer();

  /// Extract text from image using OCR
  static Future<String> extractTextFromImage(File imageFile) async {
    try {
      final InputImage inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      final List<String> textBlocks = [];
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          textBlocks.add(line.text);
        }
      }
      return textBlocks.join('\n');
    } catch (e) {
      throw Exception('OCR failed: \\${e.toString()}');
    }
  }

  static String extractJson(String text) {
    // Nếu có block ```json ... ```
    final regex = RegExp(r'```json\s*([\s\S]*?)```', multiLine: true);
    final match = regex.firstMatch(text);
    if (match != null) {
      return match.group(1)!.trim();
    }
    // Nếu không có block, thử tìm dấu { đầu tiên
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }
    // Nếu không tìm được, trả về text gốc (sẽ lỗi decode)
    return text;
  }

  /// Analyze extracted text with Gemini AI to identify expense details
  static Future<ExpenseData> analyzeExpenseWithAI(
    String extractedText, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final String prompt = '''
Analyze the following receipt/transaction text and extract expense information:

Text: $extractedText

Please extract and return JSON with the following structure:
{
  "title": "Brief description of the expense",
  "amount": 0.00,
  "category": "One of: Food & Dining, Transportation, Shopping, Entertainment, Healthcare, Education, Utilities, Other",
  "description": "Detailed description from the receipt",
  "date": "YYYY-MM-DD" (if found, otherwise null)
}

Rules:
- Amount should be the total amount paid
- Category should be the most appropriate from the list
- Title should be a brief, descriptive name
- Description should include merchant name and key details
- If no date found, use null
''';

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      });

      final response = await httpClient.post(
        Uri.parse(_geminiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String aiResponse =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        final String jsonString = extractJson(aiResponse);
        final Map<String, dynamic> expenseJson = jsonDecode(jsonString);
        return ExpenseData.fromJson(expenseJson);
      } else {
        throw Exception(
            'Gemini API request failed: \\${response.statusCode} \\${response.body}');
      }
    } catch (e) {
      // Fallback to local analysis if AI fails
      return _fallbackAnalysis(extractedText);
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }
  }

  /// Fallback analysis when AI is unavailable
  static ExpenseData _fallbackAnalysis(String text) {
    // Simple regex patterns for basic extraction
    final RegExp amountPattern = RegExp(r'\$?\d+\.?\d*');

    final String amountMatch =
        amountPattern.firstMatch(text)?.group(0) ?? '0.00';
    final double amount =
        double.tryParse(amountMatch.replaceAll('\$', '')) ?? 0.0;

    // Simple category detection
    String category = 'Other';
    final String lowerText = text.toLowerCase();
    if (lowerText.contains('coffee') ||
        lowerText.contains('restaurant') ||
        lowerText.contains('food')) {
      category = 'Food & Dining';
    } else if (lowerText.contains('gas') ||
        lowerText.contains('uber') ||
        lowerText.contains('taxi')) {
      category = 'Transportation';
    } else if (lowerText.contains('store') ||
        lowerText.contains('shop') ||
        lowerText.contains('mall')) {
      category = 'Shopping';
    }

    return ExpenseData(
      title: 'Extracted Expense',
      amount: amount,
      category: category,
      description: text.substring(0, text.length > 100 ? 100 : text.length),
    );
  }

  /// Main method to process image and extract expense data
  static Future<ExpenseData> processImageAndExtractExpense(
    File imageFile, {
    http.Client? client,
  }) async {
    try {
      // Step 1: Extract text using OCR
      final String extractedText = await extractTextFromImage(imageFile);

      if (extractedText.trim().isEmpty) {
        throw Exception('No text found in image');
      }
      // Step 2: Analyze with AI
      final ExpenseData expenseData =
          await analyzeExpenseWithAI(extractedText, client: client);
      return expenseData;
    } catch (e) {
      throw Exception('Failed to process image: ${e.toString()}');
    }
  }

  /// Dispose resources
  static void dispose() {
    _textRecognizer.close();
  }
}
