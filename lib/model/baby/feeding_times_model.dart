// ignore_for_file: public_member_api_docs, sort_constructors_first
//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'feeding_times_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class FeedingTimesModel {
  String? id;
  String? childId;
  String? date; // (date)

  List<Feedingdetails>? details = [];
  String? notes; // (text: nullable)
  FeedingTimesModel(
      {this.id, this.childId, this.date, this.notes, this.details});

  factory FeedingTimesModel.fromJson(Map<String, dynamic> json) =>
      _$FeedingTimesModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedingTimesModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Feedingdetails {
  String? feedingDetails; //    enum["Breast Feeding", "Formula Feeding"]
  String? feedingTime; //       (time)
  String? feedingAmount; //     (String)          Notes : Milliliters
  String? feedingDuration; //   (double)        Notes : Minutes

  String? notes; // (text: nullable)
  Feedingdetails({
    this.feedingDetails,
    this.feedingTime,
    this.feedingAmount,
    this.feedingDuration,
    this.notes,
  });

  factory Feedingdetails.fromJson(Map<String, dynamic> json) =>
      _$FeedingdetailsFromJson(json);
  Map<String, dynamic> toJson() => _$FeedingdetailsToJson(this);
}
