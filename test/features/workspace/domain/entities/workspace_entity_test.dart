import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkspaceEntity', () {
    test('creates entity with all properties', () {
      final entity = WorkspaceEntity(
        id: 'ws-1',
        name: 'My Workspace',
        type: WorkspaceType.workspace,
        role: 'owner',
        isDefault: true,
      );

      expect(entity.id, 'ws-1');
      expect(entity.name, 'My Workspace');
      expect(entity.type, WorkspaceType.workspace);
      expect(entity.role, 'owner');
      expect(entity.isDefault, true);
    });

    test('creates personal workspace with named constructor', () {
      final entity = WorkspaceEntity.personal(id: 'user-123', name: 'Personal');

      expect(entity.id, 'user-123');
      expect(entity.name, 'Personal');
      expect(entity.type, WorkspaceType.personal);
      expect(entity.role, 'owner');
      expect(entity.isDefault, true);
      expect(entity.isPersonal, true);
    });

    test('isPersonal returns true for personal workspace', () {
      final entity = WorkspaceEntity(
        id: 'ws-1',
        name: 'Personal',
        type: WorkspaceType.personal,
        role: 'owner',
      );

      expect(entity.isPersonal, true);
    });

    test('isPersonal returns false for regular workspace', () {
      final entity = WorkspaceEntity(
        id: 'ws-1',
        name: 'Team Workspace',
        type: WorkspaceType.workspace,
        role: 'editor',
      );

      expect(entity.isPersonal, false);
    });

    test('copyWith creates new instance with updated properties', () {
      final original = WorkspaceEntity(
        id: 'ws-1',
        name: 'Original',
        type: WorkspaceType.workspace,
        role: 'viewer',
        isDefault: false,
      );

      final updated = original.copyWith(name: 'Updated', role: 'editor');

      expect(updated.id, 'ws-1');
      expect(updated.name, 'Updated');
      expect(updated.type, WorkspaceType.workspace);
      expect(updated.role, 'editor');
      expect(updated.isDefault, false);
    });

    test('copyWith with all parameters', () {
      final original = WorkspaceEntity(
        id: 'ws-1',
        name: 'Original',
        type: WorkspaceType.workspace,
        role: 'viewer',
        isDefault: false,
      );

      final updated = original.copyWith(
        id: 'ws-2',
        name: 'Updated',
        type: WorkspaceType.personal,
        role: 'owner',
        isDefault: true,
      );

      expect(updated.id, 'ws-2');
      expect(updated.name, 'Updated');
      expect(updated.type, WorkspaceType.personal);
      expect(updated.role, 'owner');
      expect(updated.isDefault, true);
    });

    test('equality works correctly', () {
      final entity1 = WorkspaceEntity(
        id: 'ws-1',
        name: 'Workspace',
        type: WorkspaceType.workspace,
        role: 'owner',
      );

      final entity2 = WorkspaceEntity(
        id: 'ws-1',
        name: 'Workspace',
        type: WorkspaceType.workspace,
        role: 'owner',
      );

      final entity3 = WorkspaceEntity(
        id: 'ws-2',
        name: 'Workspace',
        type: WorkspaceType.workspace,
        role: 'owner',
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entity3)));
    });
  });
}
