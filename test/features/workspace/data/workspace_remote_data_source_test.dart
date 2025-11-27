import 'package:expense_manager/core/workspace/workspace_context.dart';
import 'package:expense_manager/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:expense_manager/features/workspace/data/models/workspace_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkspaceRemoteDataSource', () {
    late FakeFirebaseFirestore firestore;
    late WorkspaceRemoteDataSource dataSource;

    const uid = 'user-1';

    setUp(() {
      firestore = FakeFirebaseFirestore();
      dataSource = WorkspaceRemoteDataSource(firestore);
    });

    test('upsertMembership writes to user workspace collection', () async {
      const model = WorkspaceModel(
        id: 'household-1',
        name: 'Family',
        type: WorkspaceType.workspace,
        role: 'owner',
      );

      await dataSource.upsertMembership(uid, model);

      final doc = await firestore
          .collection('users')
          .doc(uid)
          .collection('workspaces')
          .doc('household-1')
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['name'], 'Family');
      expect(doc.data()?['type'], 'workspace');
      expect(doc.data()?['role'], 'owner');
    });

    test('watchMemberships emits model list', () async {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('workspaces')
          .doc('workspace-a')
          .set({'name': 'Workspace A', 'type': 'household', 'role': 'editor'});

      final models = await dataSource.watchMemberships(uid).first;

      expect(models, hasLength(1));
      expect(models.first.id, 'workspace-a');
      expect(models.first.name, 'Workspace A');
      expect(models.first.role, 'editor');
      expect(models.first.type, WorkspaceType.workspace);
    });
  });
}
