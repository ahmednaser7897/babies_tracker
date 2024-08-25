//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/model/doctor_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'current_medications_model.dart';

part 'mother_model.g.dart';

@JsonSerializable(includeIfNull: false)
class MotherModel {
  String? id;
  String? hospitalId;
  String? docyorlId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? address;
  String? doctorNotes;
  bool? ban;
  bool? online;
  bool? leaft;
  List<String>? healthyHistory;
  List<String>? postpartumHealth;
  List<BabieModel>? babys = [];
  List<CurrentMedicationsModel>? medications = [];
  DoctorModel? doctorModel;
  MotherModel(
      {this.id,
      this.name,
      this.docyorlId,
      this.email,
      this.password,
      this.phone,
      this.image,
      this.ban,
      this.address,
      this.doctorNotes,
      this.hospitalId,
      this.leaft,
      this.healthyHistory,
      this.postpartumHealth,
      this.online});
  factory MotherModel.fromJson(Map<String, dynamic> json) =>
      _$MotherModelFromJson(json);
  Map<String, dynamic> toJson() => _$MotherModelToJson(this);
}
