// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi';

  static String m0(user) => "Xin chào, ${user} 👋";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_budget": MessageLookupByLibrary.simpleMessage("Thêm ngân sách"),
    "add_expense": MessageLookupByLibrary.simpleMessage("Thêm chi tiêu"),
    "add_income": MessageLookupByLibrary.simpleMessage("Thêm thu nhập"),
    "add_transaction": MessageLookupByLibrary.simpleMessage("Thêm giao dịch"),
    "amount": MessageLookupByLibrary.simpleMessage("Số tiền"),
    "appName": MessageLookupByLibrary.simpleMessage("Flutter Container"),
    "budget_by_category": MessageLookupByLibrary.simpleMessage(
      "Ngân sách theo danh mục",
    ),
    "category": MessageLookupByLibrary.simpleMessage("Danh mục"),
    "date_time": MessageLookupByLibrary.simpleMessage("Thời gian"),
    "expense": MessageLookupByLibrary.simpleMessage("Chi tiêu"),
    "greeting": m0,
    "income": MessageLookupByLibrary.simpleMessage("Thu nhập"),
    "manual_input": MessageLookupByLibrary.simpleMessage("Hoặc nhập thủ công"),
    "note": MessageLookupByLibrary.simpleMessage("Ghi chú"),
    "note_hint": MessageLookupByLibrary.simpleMessage("Thêm ghi chú..."),
    "recent_transactions": MessageLookupByLibrary.simpleMessage(
      "Giao dịch gần đây",
    ),
    "remaining": MessageLookupByLibrary.simpleMessage("Còn lại"),
    "see_all": MessageLookupByLibrary.simpleMessage("Xem tất cả"),
    "tab_budget": MessageLookupByLibrary.simpleMessage("Ngân sách"),
    "tab_home": MessageLookupByLibrary.simpleMessage("Trang chủ"),
    "tab_profile": MessageLookupByLibrary.simpleMessage("Cá nhân"),
    "tab_transactions": MessageLookupByLibrary.simpleMessage("Giao dịch"),
    "title": MessageLookupByLibrary.simpleMessage("Tiêu đề"),
    "total_budget": MessageLookupByLibrary.simpleMessage("Tổng ngân sách"),
    "total_budget_by_category": MessageLookupByLibrary.simpleMessage(
      "Tổng ngân sách theo danh mục",
    ),
    "weekly_spending_chart_empty": MessageLookupByLibrary.simpleMessage(
      "Không có chi tiêu nào trong 7 ngày qua.",
    ),
    "weekly_spending_chart_title": MessageLookupByLibrary.simpleMessage(
      "Chi tiêu 7 ngày gần nhất",
    ),
  };
}
