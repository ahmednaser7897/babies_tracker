//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:babies_tracker/model/doctor_model.dart';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hospital_model.g.dart';

@JsonSerializable(includeIfNull: false)
class HospitalModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? city;
  String? bio;
  String? location;
  bool? ban;
  bool? online;
  List<DoctorModel>? doctors = [];
  List<MotherModel>? mothers = [];

  HospitalModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.image,
      this.ban,
      this.bio,
      this.city,
      this.location,
      this.online});
  factory HospitalModel.fromJson(Map<String, dynamic> json) =>
      _$HospitalModelFromJson(json);
  Map<String, dynamic> toJson() => _$HospitalModelToJson(this);
}
