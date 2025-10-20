// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Flutter Container`
  String get appName {
    return Intl.message(
      'Flutter Container',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get tab_home {
    return Intl.message('Home', name: 'tab_home', desc: '', args: []);
  }

  /// `Transactions`
  String get tab_transactions {
    return Intl.message(
      'Transactions',
      name: 'tab_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Budget`
  String get tab_budget {
    return Intl.message('Budget', name: 'tab_budget', desc: '', args: []);
  }

  /// `Profile`
  String get tab_profile {
    return Intl.message('Profile', name: 'tab_profile', desc: '', args: []);
  }

  /// `Add transaction`
  String get add_transaction {
    return Intl.message(
      'Add transaction',
      name: 'add_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Edit transaction`
  String get edit_transaction {
    return Intl.message(
      'Edit transaction',
      name: 'edit_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Time`
  String get date_time {
    return Intl.message('Time', name: 'date_time', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Expense`
  String get expense {
    return Intl.message('Expense', name: 'expense', desc: '', args: []);
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Add notes...`
  String get note_hint {
    return Intl.message('Add notes...', name: 'note_hint', desc: '', args: []);
  }

  /// `Add expense`
  String get add_expense {
    return Intl.message('Add expense', name: 'add_expense', desc: '', args: []);
  }

  /// `Add income`
  String get add_income {
    return Intl.message('Add income', name: 'add_income', desc: '', args: []);
  }

  /// `OR manual input`
  String get manual_input {
    return Intl.message(
      'OR manual input',
      name: 'manual_input',
      desc: '',
      args: [],
    );
  }

  /// `Total budget by category`
  String get total_budget_by_category {
    return Intl.message(
      'Total budget by category',
      name: 'total_budget_by_category',
      desc: '',
      args: [],
    );
  }

  /// `Budget by category`
  String get budget_by_category {
    return Intl.message(
      'Budget by category',
      name: 'budget_by_category',
      desc: '',
      args: [],
    );
  }

  /// `Total budget`
  String get total_budget {
    return Intl.message(
      'Total budget',
      name: 'total_budget',
      desc: '',
      args: [],
    );
  }

  /// `Hello, {user} 👋`
  String greeting(Object user) {
    return Intl.message(
      'Hello, $user 👋',
      name: 'greeting',
      desc: '',
      args: [user],
    );
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `Recent transactions`
  String get recent_transactions {
    return Intl.message(
      'Recent transactions',
      name: 'recent_transactions',
      desc: '',
      args: [],
    );
  }

  /// `Spending last 7 days`
  String get weekly_spending_chart_title {
    return Intl.message(
      'Spending last 7 days',
      name: 'weekly_spending_chart_title',
      desc: '',
      args: [],
    );
  }

  /// `No spending recorded in the last 7 days.`
  String get weekly_spending_chart_empty {
    return Intl.message(
      'No spending recorded in the last 7 days.',
      name: 'weekly_spending_chart_empty',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get see_all {
    return Intl.message('See all', name: 'see_all', desc: '', args: []);
  }

  /// `Add budget`
  String get add_budget {
    return Intl.message('Add budget', name: 'add_budget', desc: '', args: []);
  }

  /// `Edit budget`
  String get edit_budget {
    return Intl.message('Edit budget', name: 'edit_budget', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
