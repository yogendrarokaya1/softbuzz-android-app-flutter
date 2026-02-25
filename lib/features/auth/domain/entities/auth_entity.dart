import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String email;
  final String? username;
  final String? password;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.username,
    this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    email,
    username,
    password,
    profilePicture,
  ];
}
