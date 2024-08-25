// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'birth_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BirthReportModel _$BirthReportModelFromJson(Map<String, dynamic> json) =>
    BirthReportModel(
      id: json['id'] as String?,
      hospitaId: json['hospitaId'] as String?,
      doctorId: json['doctorId'] as String?,
      motherId: json['motherId'] as String?,
      babyId: json['babyId'] as String?,
      birthDate: json['birthDate'] as String?,
      gestationalAge: (json['gestationalAge'] as num?)?.toInt(),
      doctorNotes: json['doctorNotes'] as String?,
    )..deliveryTtype = json['deliveryTtype'] as String?;

Map<String, dynamic> _$BirthReportModelToJson(BirthReportModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('hospitaId', instance.hospitaId);
  writeNotNull('doctorId', instance.doctorId);
  writeNotNull('motherId', instance.motherId);
  writeNotNull('babyId', instance.babyId);
  writeNotNull('birthDate', instance.birthDate);
  writeNotNull('gestationalAge', instance.gestationalAge);
  writeNotNull('deliveryTtype', instance.deliveryTtype);
  writeNotNull('doctorNotes', instance.doctorNotes);
  return val;
}
