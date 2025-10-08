import 'dart:convert';

import 'package:expense_manager/features/add_expense/presentation/add_expense/services/expense_ai_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ExpenseData', () {
    test('serializes and deserializes correctly', () {
      final data = ExpenseData(
        title: 'Coffee',
        amount: 12.5,
        category: 'Food & Dining',
        description: 'Morning coffee',
        date: DateTime(2024, 1, 1),
      );

      final json = data.toJson();
      expect(json['title'], 'Coffee');
      expect(json['amount'], 12.5);
      expect(json['category'], 'Food & Dining');
      expect(json['description'], 'Morning coffee');
      expect(json['date'], '2024-01-01T00:00:00.000');

      final parsed = ExpenseData.fromJson(json);
      expect(parsed.title, 'Coffee');
      expect(parsed.amount, 12.5);
      expect(parsed.category, 'Food & Dining');
      expect(parsed.description, 'Morning coffee');
      expect(parsed.date, DateTime(2024, 1, 1));
    });

    test('falls back to defaults when json fields missing', () {
      final parsed = ExpenseData.fromJson(<String, dynamic>{});
      expect(parsed.title, 'Unknown Expense');
      expect(parsed.amount, 0.0);
      expect(parsed.category, 'Other');
      expect(parsed.description, '');
      expect(parsed.date, isNull);
    });
  });

  group('ExpenseAIService.extractJson', () {
    test('extracts json from fenced code block', () {
      const text = '''
        Some intro
        ```json
        {"title": "Coffee"}
        ```
        trailing text
      ''';

      final result = ExpenseAIService.extractJson(text);
      expect(result.trim(), '{"title": "Coffee"}');
    });

    test('extracts substring between first braces when no fences', () {
      const text = 'Result: {"title":"Tea"} thank you';
      final result = ExpenseAIService.extractJson(text);
      expect(result, '{"title":"Tea"}');
    });

    test('returns original text when braces missing', () {
      const text = 'nothing to parse';
      final result = ExpenseAIService.extractJson(text);
      expect(result, text);
    });
  });

  group('ExpenseAIService.analyzeExpenseWithAI', () {
    test('parses Gemini response when request succeeds', () async {
      final client = MockClient((request) async {
        expect(request.url, Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AIzaSyAg0jBmIxM8hEK_j84Z872BUpqSEtAB6K8'));
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['contents'], isNotEmpty);

        final responsePayload = {
          'candidates': [
            {
              'content': {
                'parts': [
                  {
                    'text': jsonEncode({
                      'title': 'Tea',
                      'amount': 15.2,
                      'category': 'Food & Dining',
                      'description': 'Tea time',
                      'date': '2024-01-02'
                    })
                  }
                ]
              }
            }
          ]
        };
        return http.Response(jsonEncode(responsePayload), 200);
      });

      final result = await ExpenseAIService.analyzeExpenseWithAI(
        'extracted',
        client: client,
      );

      expect(result.title, 'Tea');
      expect(result.amount, 15.2);
      expect(result.category, 'Food & Dining');
      expect(result.date, DateTime.parse('2024-01-02'));
    });

    test('falls back to heuristic analysis when API fails', () async {
      final client = MockClient((request) async {
        return http.Response('server error', 500);
      });

      final result = await ExpenseAIService.analyzeExpenseWithAI(
        'coffee shop total 23.50',
        client: client,
      );

      expect(result.title, 'Extracted Expense');
      expect(result.amount, 23.50);
      expect(result.category, 'Food & Dining');
    });
  });
}
