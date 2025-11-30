import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkspaceType', () {
    test('has personal type', () {
      expect(WorkspaceType.personal, isNotNull);
    });

    test('has workspace type', () {
      expect(WorkspaceType.workspace, isNotNull);
    });
  });

  group('WorkspaceContext', () {
    test('creates instance with all properties', () {
      final context = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      expect(context.userId, 'user-123');
      expect(context.workspaceId, 'ws-456');
      expect(context.type, WorkspaceType.workspace);
    });

    test('isPersonal returns true for personal workspace', () {
      final context = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.personal,
      );

      expect(context.isPersonal, isTrue);
    });

    test('isPersonal returns false for non-personal workspace', () {
      final context = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      expect(context.isPersonal, isFalse);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      final updated = original.copyWith(
        workspaceId: 'ws-789',
        type: WorkspaceType.personal,
      );

      expect(updated.userId, 'user-123');
      expect(updated.workspaceId, 'ws-789');
      expect(updated.type, WorkspaceType.personal);
    });

    test('copyWith preserves original values when no parameters provided', () {
      final original = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      final copy = original.copyWith();

      expect(copy.userId, original.userId);
      expect(copy.workspaceId, original.workspaceId);
      expect(copy.type, original.type);
    });

    test('copyWith can update only userId', () {
      final original = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      final updated = original.copyWith(userId: 'user-999');

      expect(updated.userId, 'user-999');
      expect(updated.workspaceId, 'ws-456');
      expect(updated.type, WorkspaceType.workspace);
    });

    test('copyWith can update only workspaceId', () {
      final original = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      final updated = original.copyWith(workspaceId: 'ws-999');

      expect(updated.userId, 'user-123');
      expect(updated.workspaceId, 'ws-999');
      expect(updated.type, WorkspaceType.workspace);
    });

    test('copyWith can update only type', () {
      final original = WorkspaceContext(
        userId: 'user-123',
        workspaceId: 'ws-456',
        type: WorkspaceType.workspace,
      );

      final updated = original.copyWith(type: WorkspaceType.personal);

      expect(updated.userId, 'user-123');
      expect(updated.workspaceId, 'ws-456');
      expect(updated.type, WorkspaceType.personal);
    });
  });
}
