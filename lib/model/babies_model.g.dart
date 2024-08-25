// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'babies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BabieModel _$BabieModelFromJson(Map<String, dynamic> json) => BabieModel(
      id: json['id'] as String?,
      motherId: json['motherId'] as String?,
      doctorId: json['doctorId'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      birthWeight: json['birthWeight'] as String?,
      birthLength: json['birthLength'] as String?,
      headCircumference: json['headCircumference'] as String?,
      appearance: (json['appearance'] as num?)?.toInt(),
      pulse: (json['pulse'] as num?)?.toInt(),
      grimace: (json['grimace'] as num?)?.toInt(),
      activity: (json['activity'] as num?)?.toInt(),
      respiration: (json['respiration'] as num?)?.toInt(),
      doctorNotes: json['doctorNotes'] as String?,
      birthDate: json['birthDate'] as String?,
      deliveryType: json['deliveryType'] as String?,
      gestationalAge: json['gestationalAge'] as String?,
      left: json['left'] as bool?,
    )
      ..vaccinations = (json['vaccinations'] as List<dynamic>?)
          ?.map((e) =>
              VaccinationsHistoriesModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..sleepDetailsModel = (json['sleepDetailsModel'] as List<dynamic>?)
          ?.map((e) => SleepDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..feedingTimes = (json['feedingTimes'] as List<dynamic>?)
          ?.map((e) => FeedingTimesModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BabieModelToJson(BabieModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('motherId', instance.motherId);
  writeNotNull('doctorId', instance.doctorId);
  writeNotNull('name', instance.name);
  writeNotNull('photo', instance.photo);
  writeNotNull('birthWeight', instance.birthWeight);
  writeNotNull('birthLength', instance.birthLength);
  writeNotNull('headCircumference', instance.headCircumference);
  writeNotNull('appearance', instance.appearance);
  writeNotNull('pulse', instance.pulse);
  writeNotNull('grimace', instance.grimace);
  writeNotNull('activity', instance.activity);
  writeNotNull('respiration', instance.respiration);
  writeNotNull('doctorNotes', instance.doctorNotes);
  writeNotNull('left', instance.left);
  writeNotNull('birthDate', instance.birthDate);
  writeNotNull('gestationalAge', instance.gestationalAge);
  writeNotNull('deliveryType', instance.deliveryType);
  writeNotNull('vaccinations', instance.vaccinations);
  writeNotNull('sleepDetailsModel', instance.sleepDetailsModel);
  writeNotNull('feedingTimes', instance.feedingTimes);
  return val;
}
