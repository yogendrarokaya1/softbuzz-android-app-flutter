import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/core/usecases/app_usecases.dart';
import 'package:softbuzz_app/features/auth/domain/entities/auth_entity.dart';
import 'package:softbuzz_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:softbuzz_app/features/auth/data/repositories/auth_repository.dart';

// ── Params ────────────────────────────────────────────────────────────────────

class UpdateProfileParams {
  final String firstName;
  final String lastName;
  final String username;
  final String? profilePicturePath;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    required this.username,
    this.profilePicturePath,
  });
}

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

// ── Update Profile Usecase ────────────────────────────────────────────────────

class UpdateProfileUsecase
    implements UsecaseWithParms<AuthEntity, UpdateProfileParams> {
  final IAuthRepository _repository;
  UpdateProfileUsecase(this._repository);

  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      profilePicturePath: params.profilePicturePath,
    );
  }
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  return UpdateProfileUsecase(ref.read(authRepositoryProvider));
});

// ── Change Password Usecase ───────────────────────────────────────────────────

class ChangePasswordUsecase
    implements UsecaseWithParms<bool, ChangePasswordParams> {
  final IAuthRepository _repository;
  ChangePasswordUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParams params) {
    return _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}

final changePasswordUsecaseProvider = Provider<ChangePasswordUsecase>((ref) {
  return ChangePasswordUsecase(ref.read(authRepositoryProvider));
});
