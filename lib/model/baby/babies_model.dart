// ignore_for_file: public_member_api_docs, sort_constructors_first
//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:babies_tracker/model/baby/sleep_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../doctor/doctor_model.dart';
import 'feeding_times_model.dart';
import 'vaccinations_histories_model.dart';

part 'babies_model.g.dart';

@JsonSerializable(includeIfNull: false)
class BabieModel extends Equatable {
  String? id;
  String? motherId;
  String? doctorId;
  String? name;
  String? photo;
  String? birthWeight;
  String? birthLength;
  String? headCircumference;
  int? appearance; // [0, 1, 2],
  int? pulse; // [0, 1, 2],
  int? grimace; // [0, 1, 2],
  int? activity; // [0, 1, 2],
  int? respiration; // [0, 1, 2]
  String? doctorNotes; //(text: nullable)
  bool? left; //(Boolean: false)
  String? birthDate;
  String? gestationalAge;
  String? deliveryType; //enum["Natural", "Cesarean"]
  List<VaccinationsHistoriesModel>? vaccinations = [];
  List<SleepDetailsModel>? sleepDetailsModel = [];
  List<FeedingTimesModel>? feedingTimes = [];
  DoctorModel? doctorModel;
  BabieModel(
      {this.id,
      this.motherId,
      this.doctorId,
      this.name,
      this.photo,
      this.birthWeight,
      this.birthLength,
      this.headCircumference,
      this.appearance,
      this.pulse,
      this.grimace,
      this.activity,
      this.respiration,
      this.doctorNotes,
      this.birthDate,
      this.deliveryType,
      this.gestationalAge,
      this.left});

  factory BabieModel.fromJson(Map<String, dynamic> json) =>
      _$BabieModelFromJson(json);
  Map<String, dynamic> toJson() => _$BabieModelToJson(this);

  @override
  List<Object?> get props => [id];
}
