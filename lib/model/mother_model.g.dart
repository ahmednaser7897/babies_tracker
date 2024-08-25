// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mother_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotherModel _$MotherModelFromJson(Map<String, dynamic> json) => MotherModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      docyorlId: json['docyorlId'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      ban: json['ban'] as bool?,
      address: json['address'] as String?,
      doctorNotes: json['doctorNotes'] as String?,
      hospitalId: json['hospitalId'] as String?,
      leaft: json['leaft'] as bool?,
      healthyHistory: (json['healthyHistory'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      postpartumHealth: (json['postpartumHealth'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      online: json['online'] as bool?,
    )
      ..babys = (json['babys'] as List<dynamic>?)
          ?.map((e) => BabieModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..medications = (json['medications'] as List<dynamic>?)
          ?.map((e) =>
              CurrentMedicationsModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..doctorModel = json['doctorModel'] == null
          ? null
          : DoctorModel.fromJson(json['doctorModel'] as Map<String, dynamic>);

Map<String, dynamic> _$MotherModelToJson(MotherModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('hospitalId', instance.hospitalId);
  writeNotNull('docyorlId', instance.docyorlId);
  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('phone', instance.phone);
  writeNotNull('image', instance.image);
  writeNotNull('address', instance.address);
  writeNotNull('doctorNotes', instance.doctorNotes);
  writeNotNull('ban', instance.ban);
  writeNotNull('online', instance.online);
  writeNotNull('leaft', instance.leaft);
  writeNotNull('healthyHistory', instance.healthyHistory);
  writeNotNull('postpartumHealth', instance.postpartumHealth);
  writeNotNull('babys', instance.babys);
  writeNotNull('medications', instance.medications);
  writeNotNull('doctorModel', instance.doctorModel);
  return val;
}
