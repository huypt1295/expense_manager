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

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Light`
  String get theme_mode_light {
    return Intl.message('Light', name: 'theme_mode_light', desc: '', args: []);
  }

  /// `Dark`
  String get theme_mode_dark {
    return Intl.message('Dark', name: 'theme_mode_dark', desc: '', args: []);
  }

  /// `System`
  String get theme_mode_system {
    return Intl.message(
      'System',
      name: 'theme_mode_system',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message('Setting', name: 'setting', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Sign out`
  String get sign_out {
    return Intl.message('Sign out', name: 'sign_out', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `App settings`
  String get app_setting {
    return Intl.message(
      'App settings',
      name: 'app_setting',
      desc: '',
      args: [],
    );
  }

  /// `Workspace`
  String get workspace {
    return Intl.message('Workspace', name: 'workspace', desc: '', args: []);
  }

  /// `Only me`
  String get only_me {
    return Intl.message('Only me', name: 'only_me', desc: '', args: []);
  }

  /// `Get started`
  String get get_started {
    return Intl.message('Get started', name: 'get_started', desc: '', args: []);
  }

  /// `Create workspace`
  String get create_workspace {
    return Intl.message(
      'Create workspace',
      name: 'create_workspace',
      desc: '',
      args: [],
    );
  }

  /// `You can invite your family and manage your expenses here.`
  String get workspace_banner_content {
    return Intl.message(
      'You can invite your family and manage your expenses here.',
      name: 'workspace_banner_content',
      desc: '',
      args: [],
    );
  }

  /// `Edit name`
  String get edit_name {
    return Intl.message('Edit name', name: 'edit_name', desc: '', args: []);
  }

  /// `You are currently in this workspace. Transaction and budget data displayed according to the workspace.`
  String get workspace_info_content {
    return Intl.message(
      'You are currently in this workspace. Transaction and budget data displayed according to the workspace.',
      name: 'workspace_info_content',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get members {
    return Intl.message('Members', name: 'members', desc: '', args: []);
  }

  /// `No members in this workspace.`
  String get empty_members_message {
    return Intl.message(
      'No members in this workspace.',
      name: 'empty_members_message',
      desc: '',
      args: [],
    );
  }

  /// `Invite members`
  String get invite_members {
    return Intl.message(
      'Invite members',
      name: 'invite_members',
      desc: '',
      args: [],
    );
  }

  /// `Email or username`
  String get invite_members_hint {
    return Intl.message(
      'Email or username',
      name: 'invite_members_hint',
      desc: '',
      args: [],
    );
  }

  /// `Editable`
  String get editable {
    return Intl.message('Editable', name: 'editable', desc: '', args: []);
  }

  /// `View only`
  String get view_only {
    return Intl.message('View only', name: 'view_only', desc: '', args: []);
  }

  /// `Access role`
  String get access_role {
    return Intl.message('Access role', name: 'access_role', desc: '', args: []);
  }

  /// `Send invite`
  String get send_invite {
    return Intl.message('Send invite', name: 'send_invite', desc: '', args: []);
  }

  /// `Leave workspace`
  String get leave_workspace {
    return Intl.message(
      'Leave workspace',
      name: 'leave_workspace',
      desc: '',
      args: [],
    );
  }

  /// `Remove workspace`
  String get remove_workspace {
    return Intl.message(
      'Remove workspace',
      name: 'remove_workspace',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `You will no longer have access to the data of this workspace. You can be invited again later.`
  String get leave_workspace_warning {
    return Intl.message(
      'You will no longer have access to the data of this workspace. You can be invited again later.',
      name: 'leave_workspace_warning',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone. All data will be permanently deleted.`
  String get this_action_cannot_be_undone {
    return Intl.message(
      'This action cannot be undone. All data will be permanently deleted.',
      name: 'this_action_cannot_be_undone',
      desc: '',
      args: [],
    );
  }

  /// `Enter workspace name to confirm`
  String get enter_workspace_name {
    return Intl.message(
      'Enter workspace name to confirm',
      name: 'enter_workspace_name',
      desc: '',
      args: [],
    );
  }

  /// `Name does not match`
  String get name_not_matching {
    return Intl.message(
      'Name does not match',
      name: 'name_not_matching',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `You haven't joined any workspace yet`
  String get workspace_wizard_title {
    return Intl.message(
      'You haven\'t joined any workspace yet',
      name: 'workspace_wizard_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a workspace to share expenses and budgets with family or friends`
  String get workspace_wizard_description {
    return Intl.message(
      'Create a workspace to share expenses and budgets with family or friends',
      name: 'workspace_wizard_description',
      desc: '',
      args: [],
    );
  }

  /// `Choose icon`
  String get workspace_wizard_choose_icon {
    return Intl.message(
      'Choose icon',
      name: 'workspace_wizard_choose_icon',
      desc: '',
      args: [],
    );
  }

  /// `Workspace name`
  String get workspace_name {
    return Intl.message(
      'Workspace name',
      name: 'workspace_name',
      desc: '',
      args: [],
    );
  }

  /// `Add category`
  String get add_category {
    return Intl.message(
      'Add category',
      name: 'add_category',
      desc: '',
      args: [],
    );
  }

  /// `Transaction type`
  String get category_type {
    return Intl.message(
      'Transaction type',
      name: 'category_type',
      desc: '',
      args: [],
    );
  }

  /// `Choose icon`
  String get choose_icon {
    return Intl.message('Choose icon', name: 'choose_icon', desc: '', args: []);
  }

  /// `Category name`
  String get category_name {
    return Intl.message(
      'Category name',
      name: 'category_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a category name`
  String get please_enter_category_name {
    return Intl.message(
      'Please enter a category name',
      name: 'please_enter_category_name',
      desc: '',
      args: [],
    );
  }

  /// `Please choose an icon`
  String get please_choose_icon {
    return Intl.message(
      'Please choose an icon',
      name: 'please_choose_icon',
      desc: '',
      args: [],
    );
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
