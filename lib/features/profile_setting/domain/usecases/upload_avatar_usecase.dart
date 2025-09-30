import 'dart:typed_data';

import 'package:expense_manager/features/profile_setting/domain/repositories/user_profile_repository.dart';
import 'package:expense_manager/features/profile_setting/domain/usecases/profile_failure_mapper.dart';
import 'package:flutter_core/flutter_core.dart';

class UploadAvatarParams {
  const UploadAvatarParams({
    required this.uid,
    required this.bytes,
    this.fileName,
  });

  final String uid;
  final Uint8List bytes;
  final String? fileName;
}

@injectable
class UploadAvatarUseCase extends BaseUseCase<UploadAvatarParams, String?> {
  UploadAvatarUseCase(this._repository);

  final UserProfileRepository _repository;

  @override
  Future<Result<String?>> call(UploadAvatarParams params) {
    return Result.guard<String?>(
      () => _repository.uploadAvatar(
        params.uid,
        params.bytes,
        fileName: params.fileName,
      ),
      mapProfileError,
    );
  }
}
