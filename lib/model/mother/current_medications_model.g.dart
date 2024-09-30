// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_medications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentMedicationsModel _$CurrentMedicationsModelFromJson(
        Map<String, dynamic> json) =>
    CurrentMedicationsModel(
      id: json['id'] as String?,
      motherId: json['motherId'] as String?,
      name: json['name'] as String?,
      dosage: json['dosage'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      doctorNotes: json['doctorNotes'] as String?,
      docyorlId: json['docyorlId'] as String?,
      frequency: (json['frequency'] as num?)?.toInt(),
      purpose: json['purpose'] as String?,
    );

Map<String, dynamic> _$CurrentMedicationsModelToJson(
    CurrentMedicationsModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('motherId', instance.motherId);
  writeNotNull('name', instance.name);
  writeNotNull('dosage', instance.dosage);
  writeNotNull('frequency', instance.frequency);
  writeNotNull('startDate', instance.startDate);
  writeNotNull('endDate', instance.endDate);
  writeNotNull('docyorlId', instance.docyorlId);
  writeNotNull('purpose', instance.purpose);
  writeNotNull('doctorNotes', instance.doctorNotes);
  return val;
}
