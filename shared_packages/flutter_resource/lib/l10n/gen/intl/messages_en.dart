// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(user) => "Hello, ${user} 👋";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_budget": MessageLookupByLibrary.simpleMessage("Add budget"),
    "add_expense": MessageLookupByLibrary.simpleMessage("Add expense"),
    "add_income": MessageLookupByLibrary.simpleMessage("Add income"),
    "add_transaction": MessageLookupByLibrary.simpleMessage("Add transaction"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "appName": MessageLookupByLibrary.simpleMessage("Flutter Container"),
    "budget_by_category": MessageLookupByLibrary.simpleMessage(
      "Budget by category",
    ),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "date_time": MessageLookupByLibrary.simpleMessage("Time"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "edit_budget": MessageLookupByLibrary.simpleMessage("Edit budget"),
    "edit_transaction": MessageLookupByLibrary.simpleMessage(
      "Edit transaction",
    ),
    "expense": MessageLookupByLibrary.simpleMessage("Expense"),
    "greeting": m0,
    "income": MessageLookupByLibrary.simpleMessage("Income"),
    "manual_input": MessageLookupByLibrary.simpleMessage("OR manual input"),
    "note": MessageLookupByLibrary.simpleMessage("Note"),
    "note_hint": MessageLookupByLibrary.simpleMessage("Add notes..."),
    "recent_transactions": MessageLookupByLibrary.simpleMessage(
      "Recent transactions",
    ),
    "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "see_all": MessageLookupByLibrary.simpleMessage("See all"),
    "tab_budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "tab_home": MessageLookupByLibrary.simpleMessage("Home"),
    "tab_profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "tab_transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "total_budget": MessageLookupByLibrary.simpleMessage("Total budget"),
    "total_budget_by_category": MessageLookupByLibrary.simpleMessage(
      "Total budget by category",
    ),
    "weekly_spending_chart_empty": MessageLookupByLibrary.simpleMessage(
      "No spending recorded in the last 7 days.",
    ),
    "weekly_spending_chart_title": MessageLookupByLibrary.simpleMessage(
      "Spending last 7 days",
    ),
  };
}
