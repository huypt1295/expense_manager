import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_detail_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_invitation_entity.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_member_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkspaceDetailEntity', () {
    test('creates instance with required properties', () {
      final entity = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Test Workspace',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      expect(entity.id, 'ws-1');
      expect(entity.name, 'Test Workspace');
      expect(entity.currencyCode, 'USD');
      expect(entity.ownerId, 'owner-1');
      expect(entity.createdAt, DateTime(2024, 1, 1));
      expect(entity.updatedAt, DateTime(2024, 1, 2));
      expect(entity.type, WorkspaceType.workspace);
    });

    test('creates instance with custom type', () {
      final entity = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Personal',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
        type: WorkspaceType.personal,
      );

      expect(entity.type, WorkspaceType.personal);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Original',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final updated = original.copyWith(name: 'Updated', currencyCode: 'EUR');

      expect(updated.id, 'ws-1');
      expect(updated.name, 'Updated');
      expect(updated.currencyCode, 'EUR');
      expect(updated.ownerId, 'owner-1');
      expect(updated.createdAt, DateTime(2024, 1, 1));
      expect(updated.updatedAt, DateTime(2024, 1, 2));
    });

    test('copyWith preserves original values when no parameters provided', () {
      final original = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Original',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.currencyCode, original.currencyCode);
    });

    test('supports equality comparison', () {
      final entity1 = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Test',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final entity2 = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Test',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      expect(entity1, equals(entity2));
    });

    test('different entities are not equal', () {
      final entity1 = WorkspaceDetailEntity(
        id: 'ws-1',
        name: 'Test',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final entity2 = WorkspaceDetailEntity(
        id: 'ws-2',
        name: 'Test',
        currencyCode: 'USD',
        ownerId: 'owner-1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      expect(entity1, isNot(equals(entity2)));
    });
  });

  group('WorkspaceInvitationEntity', () {
    test('creates instance with required properties', () {
      final entity = WorkspaceInvitationEntity(
        id: 'inv-1',
        email: 'test@example.com',
        role: 'editor',
        invitedBy: 'user-1',
        status: WorkspaceInvitationStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(entity.id, 'inv-1');
      expect(entity.email, 'test@example.com');
      expect(entity.role, 'editor');
      expect(entity.invitedBy, 'user-1');
      expect(entity.status, WorkspaceInvitationStatus.pending);
      expect(entity.createdAt, DateTime(2024, 1, 1));
      expect(entity.expiresAt, isNull);
      expect(entity.invitedUsername, isNull);
    });

    test('creates instance with optional properties', () {
      final entity = WorkspaceInvitationEntity(
        id: 'inv-1',
        email: 'test@example.com',
        role: 'editor',
        invitedBy: 'user-1',
        status: WorkspaceInvitationStatus.accepted,
        createdAt: DateTime(2024, 1, 1),
        expiresAt: DateTime(2024, 1, 8),
        invitedUsername: 'testuser',
      );

      expect(entity.expiresAt, DateTime(2024, 1, 8));
      expect(entity.invitedUsername, 'testuser');
    });

    test('supports all invitation statuses', () {
      expect(WorkspaceInvitationStatus.pending, isNotNull);
      expect(WorkspaceInvitationStatus.accepted, isNotNull);
      expect(WorkspaceInvitationStatus.revoked, isNotNull);
      expect(WorkspaceInvitationStatus.expired, isNotNull);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = WorkspaceInvitationEntity(
        id: 'inv-1',
        email: 'test@example.com',
        role: 'editor',
        invitedBy: 'user-1',
        status: WorkspaceInvitationStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        status: WorkspaceInvitationStatus.accepted,
        invitedUsername: 'newuser',
      );

      expect(updated.id, 'inv-1');
      expect(updated.status, WorkspaceInvitationStatus.accepted);
      expect(updated.invitedUsername, 'newuser');
    });

    test('supports equality comparison', () {
      final entity1 = WorkspaceInvitationEntity(
        id: 'inv-1',
        email: 'test@example.com',
        role: 'editor',
        invitedBy: 'user-1',
        status: WorkspaceInvitationStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      final entity2 = WorkspaceInvitationEntity(
        id: 'inv-1',
        email: 'test@example.com',
        role: 'editor',
        invitedBy: 'user-1',
        status: WorkspaceInvitationStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(entity1, equals(entity2));
    });
  });

  group('WorkspaceMemberEntity', () {
    test('creates instance with all properties', () {
      final entity = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        role: 'owner',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      expect(entity.userId, 'user-1');
      expect(entity.displayName, 'John Doe');
      expect(entity.email, 'john@example.com');
      expect(entity.role, 'owner');
      expect(entity.status, WorkspaceMemberStatus.active);
      expect(entity.joinedAt, DateTime(2024, 1, 1));
    });

    test('isOwner returns true for owner role', () {
      final entity = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        role: 'owner',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      expect(entity.isOwner, isTrue);
      expect(entity.isEditor, isFalse);
      expect(entity.isViewer, isFalse);
    });

    test('isOwner is case insensitive', () {
      final entity = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        role: 'OWNER',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      expect(entity.isOwner, isTrue);
    });

    test('isEditor returns true for editor role', () {
      final entity = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'Jane Doe',
        email: 'jane@example.com',
        role: 'editor',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      expect(entity.isOwner, isFalse);
      expect(entity.isEditor, isTrue);
      expect(entity.isViewer, isFalse);
    });

    test('isViewer returns true for viewer role', () {
      final entity = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'Bob Smith',
        email: 'bob@example.com',
        role: 'viewer',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      expect(entity.isOwner, isFalse);
      expect(entity.isEditor, isFalse);
      expect(entity.isViewer, isTrue);
    });

    test('supports both member statuses', () {
      expect(WorkspaceMemberStatus.active, isNotNull);
      expect(WorkspaceMemberStatus.pendingRemoval, isNotNull);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        role: 'editor',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        role: 'owner',
        status: WorkspaceMemberStatus.pendingRemoval,
      );

      expect(updated.userId, 'user-1');
      expect(updated.role, 'owner');
      expect(updated.status, WorkspaceMemberStatus.pendingRemoval);
    });

    test('supports equality comparison', () {
      final entity1 = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        role: 'owner',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      final entity2 = WorkspaceMemberEntity(
        userId: 'user-1',
        displayName: 'John Doe',
        email: 'john@example.com',
        role: 'owner',
        status: WorkspaceMemberStatus.active,
        joinedAt: DateTime(2024, 1, 1),
      );

      expect(entity1, equals(entity2));
    });
  });
}
