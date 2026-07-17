import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';
part 'role.g.dart';

@freezed
class Role with _$Role {
  const factory Role({
    required String id,
    required String name,
    String? description,
    @Default(true) bool isSystem,
    DateTime? createdAt,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
