// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vaccinations_histories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaccinationsHistoriesModel _$VaccinationsHistoriesModelFromJson(
        Map<String, dynamic> json) =>
    VaccinationsHistoriesModel(
      id: json['id'] as String?,
      babyId: json['babyId'] as String?,
      vaccineName: json['vaccineName'] as String?,
      vaccinationDate: json['vaccinationDate'] as String?,
      dose: json['dose'] as String?,
      administering: json['administering'] as String?,
      sideEffects: json['sideEffects'] as String?,
      administrationSite: json['administrationSite'] as String?,
      nextDoseDate: json['nextDoseDate'] as String?,
    );

Map<String, dynamic> _$VaccinationsHistoriesModelToJson(
    VaccinationsHistoriesModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('babyId', instance.babyId);
  writeNotNull('vaccineName', instance.vaccineName);
  writeNotNull('vaccinationDate', instance.vaccinationDate);
  writeNotNull('dose', instance.dose);
  writeNotNull('administering', instance.administering);
  writeNotNull('administrationSite', instance.administrationSite);
  writeNotNull('nextDoseDate', instance.nextDoseDate);
  writeNotNull('sideEffects', instance.sideEffects);
  return val;
}
