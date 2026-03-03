import 'package:dartz/dartz.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, AuthEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    String? profilePicturePath, // local file path for upload
  });
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
