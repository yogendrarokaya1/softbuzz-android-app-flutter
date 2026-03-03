import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:softbuzz_app/core/api/api_client.dart';
import 'package:softbuzz_app/core/api/api_endpoints.dart';
import 'package:softbuzz_app/core/services/storage/token_service.dart';
import 'package:softbuzz_app/core/services/storage/user_session_service.dart';
import 'package:softbuzz_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:softbuzz_app/features/auth/data/models/auth_api_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email ?? '',
        firstName: user.firstName ?? '',
        lastName: user.lastName ?? '',
        username: user.username ?? '',
      );
      final token = response.data['token'];
      await _tokenService.saveToken(token);
      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return AuthApiModel.fromJson(data);
    }
    return user;
  }

  // ── Update Profile ──────────────────────────────────────────────────────────

  @override
  Future<AuthApiModel> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    String? profilePicturePath,
  }) async {
    late final Response response;

    if (profilePicturePath != null) {
      // Use multipart when image selected — matches ApiClient.uploadFile signature
      final formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'profilePicture': await MultipartFile.fromFile(
          profilePicturePath,
          filename: profilePicturePath.split('/').last,
        ),
      });
      response = await _apiClient.uploadFile(
        ApiEndpoints.updateProfile,
        formData: formData,
      );
    } else {
      response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
        },
      );
    }

    final data = response.data['data'] as Map<String, dynamic>;
    return AuthApiModel.fromJson(data);
  }

  // ── Change Password ─────────────────────────────────────────────────────────

  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
    return response.data['success'] == true;
  }
}
