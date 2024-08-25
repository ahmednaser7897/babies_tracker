// ignore_for_file: public_member_api_docs, sort_constructors_first
//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'sleep_details_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class SleepDetailsModel {
  String? id;
  String? childId;
  String? date; //(date)
  String?
      totalSleepDuration; //Notes: it will equal summation of all duration sleeps into details      example: (end_1 - start_1) + (end_2 - start_2) + ......
  String? notes; //(text: nullable);//

  List<DetailsModel>? details = [];
  SleepDetailsModel(
      {this.id,
      this.childId,
      this.notes,
      this.date,
      this.totalSleepDuration,
      this.details});

  factory SleepDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$SleepDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SleepDetailsModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class DetailsModel {
  String? startTime; //= (time)
  String? endTime; //     (time)
  String? sleepQuality; //  enum["Restful", "Slightly restless"]

  DetailsModel({
    this.endTime,
    this.sleepQuality,
    this.startTime,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) =>
      _$DetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$DetailsModelToJson(this);
}
