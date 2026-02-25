import 'package:softbuzz_app/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? email;
  final String? password;

  AuthApiModel({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (password != null) {
      data['password'] = password;
      data['confirmPassword'] = password;
    }
    return data;
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      email: json['email'],
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      username: username ?? '',
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }
}
