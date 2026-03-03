import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softbuzz_app/core/error/failures.dart';
import 'package:softbuzz_app/core/services/connectivity/network_info.dart';
import 'package:softbuzz_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:softbuzz_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:softbuzz_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:softbuzz_app/features/auth/data/models/auth_api_model.dart';
import 'package:softbuzz_app/features/auth/data/models/auth_hive_model.dart';
import 'package:softbuzz_app/features/auth/domain/entities/auth_entity.dart';
import 'package:softbuzz_app/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;

  Failure _dioFailure(DioException e, String fallback) => ApiFailure(
    message: e.response?.data?['message']?.toString() ?? fallback,
    statusCode: e.response?.statusCode,
  );

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(_dioFailure(e, 'Registration failed'));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final existingUser = await _authDataSource.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }
        final authModel = AuthHiveModel(
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          username: user.username,
          password: user.password,
          profilePicture: user.profilePicture,
        );
        await _authDataSource.register(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) return Right(apiModel.toEntity());
        return const Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(_dioFailure(e, 'Login failed'));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _authDataSource.login(email, password);
        if (model != null) return Right(model.toEntity());
        return const Left(
          LocalDatabaseFailure(message: "Invalid email or password"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authDataSource.getCurrentUser();
      if (model != null) return Right(model.toEntity());
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _authDataSource.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  // ── Update Profile ──────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, AuthEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    String? profilePicturePath,
  }) async {
    try {
      final model = await _authRemoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        username: username,
        profilePicturePath: profilePicturePath,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_dioFailure(e, 'Failed to update profile'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // ── Change Password ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final success = await _authRemoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return Right(success);
    } on DioException catch (e) {
      return Left(_dioFailure(e, 'Failed to change password'));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
