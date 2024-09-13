// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SleepDetailsModel _$SleepDetailsModelFromJson(Map<String, dynamic> json) =>
    SleepDetailsModel(
      id: json['id'] as String?,
      childId: json['childId'] as String?,
      notes: json['notes'] as String?,
      date: json['date'] as String?,
      totalSleepDuration: json['totalSleepDuration'] as String?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => DetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SleepDetailsModelToJson(SleepDetailsModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('childId', instance.childId);
  writeNotNull('date', instance.date);
  writeNotNull('totalSleepDuration', instance.totalSleepDuration);
  writeNotNull('notes', instance.notes);
  writeNotNull('details', instance.details?.map((e) => e.toJson()).toList());
  return val;
}

DetailsModel _$DetailsModelFromJson(Map<String, dynamic> json) => DetailsModel(
      endTime: json['endTime'] as String?,
      sleepQuality: json['sleepQuality'] as String?,
      startTime: json['startTime'] as String?,
    );

Map<String, dynamic> _$DetailsModelToJson(DetailsModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('startTime', instance.startTime);
  writeNotNull('endTime', instance.endTime);
  writeNotNull('sleepQuality', instance.sleepQuality);
  return val;
}
