import 'package:flutter_core/flutter_core.dart';

class WorkspaceOnboardingState extends BaseBlocState with EquatableMixin {
  const WorkspaceOnboardingState({
    this.name = '',
    this.iconIndex = 0,
    this.isSubmitting = false,
    this.errorMessage,
    this.completedHouseholdId,
  });

  final String name;
  final int iconIndex;
  final bool isSubmitting;
  final String? errorMessage;
  final String? completedHouseholdId;

  bool get canSubmit => name.trim().isNotEmpty;

  bool get isCompleted => completedHouseholdId != null;

  WorkspaceOnboardingState copyWith({
    String? name,
    int? iconIndex,
    bool? isSubmitting,
    bool clearError = false,
    String? errorMessage,
    String? completedHouseholdId,
  }) {
    return WorkspaceOnboardingState(
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      completedHouseholdId: completedHouseholdId ?? this.completedHouseholdId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    name,
    iconIndex,
    isSubmitting,
    errorMessage,
    completedHouseholdId,
  ];
}
