import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:expense_manager/features/workspace/domain/repositories/workspace_detail_repository.dart';
import 'package:expense_manager/features/workspace/domain/usecases/ensure_personal_workspace_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWorkspaceDetailRepository implements WorkspaceDetailRepository {
  bool ensurePersonalWorkspaceCalled = false;
  String? verifyMemberExistsWorkspaceId;
  String? verifyMemberExistsUserId;
  bool verifyMemberExistsResult = true;

  @override
  Future<void> ensurePersonalWorkspace() async {
    ensurePersonalWorkspaceCalled = true;
  }

  @override
  Future<bool> verifyMemberExists({
    required String workspaceId,
    required String userId,
  }) async {
    verifyMemberExistsWorkspaceId = workspaceId;
    verifyMemberExistsUserId = userId;
    return verifyMemberExistsResult;
  }

  @override
  Future<WorkspaceDetailEntity> createWorkspace({
    required String name,
    required String currencyCode,
    required List<String> inviteEmails,
  }) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<WorkspaceMemberEntity>> watchMembers(String workspaceId) {
    throw UnimplementedError();
  }

  @override
  Stream<List<WorkspaceInvitationEntity>> watchInvitations(String workspaceId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMemberRole({
    required String workspaceId,
    required String memberId,
    required String role,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> removeMember({
    required String workspaceId,
    required String memberId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWorkspace({
    required String userId,
    required String workspaceId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendInvitation({
    required String workspaceId,
    required String email,
    required String role,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelInvitation({
    required String workspaceId,
    required String invitationId,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  group('EnsurePersonalWorkspaceUseCase', () {
    late _FakeWorkspaceDetailRepository repository;
    late EnsurePersonalWorkspaceUseCase useCase;

    setUp(() {
      repository = _FakeWorkspaceDetailRepository();
      useCase = EnsurePersonalWorkspaceUseCase(repository);
    });

    test('call delegates to repository.ensurePersonalWorkspace', () async {
      await useCase.call();

      expect(repository.ensurePersonalWorkspaceCalled, isTrue);
    });

    test(
      'verifyMemberExists delegates to repository with correct parameters',
      () async {
        final result = await useCase.verifyMemberExists(
          workspaceId: 'ws-123',
          userId: 'user-456',
        );

        expect(repository.verifyMemberExistsWorkspaceId, 'ws-123');
        expect(repository.verifyMemberExistsUserId, 'user-456');
        expect(result, isTrue);
      },
    );

    test(
      'verifyMemberExists returns false when member does not exist',
      () async {
        repository.verifyMemberExistsResult = false;

        final result = await useCase.verifyMemberExists(
          workspaceId: 'ws-123',
          userId: 'user-456',
        );

        expect(result, isFalse);
      },
    );
  });
}
