import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/core/usecases/app_usecases.dart';
import 'package:softbuzz_app/features/auth/data/repositories/auth_repository.dart';
import 'package:softbuzz_app/features/auth/domain/entities/auth_entity.dart';
import 'package:softbuzz_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String username;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password, username];
}

// Create Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    final authEntity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      username: params.username,
    );

    return _authRepository.register(authEntity);
  }
}
