// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => AdminModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      gender: json['gender'] as String?,
      ban: json['ban'] as bool?,
      createdAt: json['createdAt'] as String?,
      online: json['online'] as bool?,
    );

Map<String, dynamic> _$AdminModelToJson(AdminModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('phone', instance.phone);
  writeNotNull('image', instance.image);
  writeNotNull('gender', instance.gender);
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('ban', instance.ban);
  writeNotNull('online', instance.online);
  return val;
}
