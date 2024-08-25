// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_times_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedingTimesModel _$FeedingTimesModelFromJson(Map<String, dynamic> json) =>
    FeedingTimesModel(
      id: json['id'] as String?,
      childId: json['childId'] as String?,
      date: json['date'] as String?,
      notes: json['notes'] as String?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => Feedingdetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedingTimesModelToJson(FeedingTimesModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('childId', instance.childId);
  writeNotNull('date', instance.date);
  writeNotNull('details', instance.details?.map((e) => e.toJson()).toList());
  writeNotNull('notes', instance.notes);
  return val;
}

Feedingdetails _$FeedingdetailsFromJson(Map<String, dynamic> json) =>
    Feedingdetails(
      feedingDetails: json['feedingDetails'] as String?,
      feedingTime: json['feedingTime'] as String?,
      feedingAmount: json['feedingAmount'] as String?,
      feedingDuration: json['feedingDuration'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$FeedingdetailsToJson(Feedingdetails instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('feedingDetails', instance.feedingDetails);
  writeNotNull('feedingTime', instance.feedingTime);
  writeNotNull('feedingAmount', instance.feedingAmount);
  writeNotNull('feedingDuration', instance.feedingDuration);
  writeNotNull('notes', instance.notes);
  return val;
}
