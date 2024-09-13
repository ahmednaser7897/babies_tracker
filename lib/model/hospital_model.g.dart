// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalModel _$HospitalModelFromJson(Map<String, dynamic> json) =>
    HospitalModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      ban: json['ban'] as bool?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      location: json['location'] as String?,
      online: json['online'] as bool?,
    )
      ..doctors = (json['doctors'] as List<dynamic>?)
          ?.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..mothers = (json['mothers'] as List<dynamic>?)
          ?.map((e) => MotherModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$HospitalModelToJson(HospitalModel instance) {
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
  writeNotNull('city', instance.city);
  writeNotNull('bio', instance.bio);
  writeNotNull('location', instance.location);
  writeNotNull('ban', instance.ban);
  writeNotNull('online', instance.online);
  writeNotNull('doctors', instance.doctors);
  writeNotNull('mothers', instance.mothers);
  return val;
}
