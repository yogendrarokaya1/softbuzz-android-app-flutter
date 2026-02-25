import 'package:hive/hive.dart';
import 'package:softbuzz_app/core/constants/hive_table_constant.dart';
import 'package:softbuzz_app/features/auth/domain/entities/auth_entity.dart';

import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? username;

  @HiveField(5)
  final String? password;

  @HiveField(7)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? const Uuid().v4();

  AuthEntity toEntity({AuthEntity? auth}) {
    return AuthEntity(
      authId: authId,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      username: username ?? '',
      password: password,
      profilePicture: profilePicture,
    );
  }

  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId!,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
