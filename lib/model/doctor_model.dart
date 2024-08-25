//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable(includeIfNull: false)
class DoctorModel {
  String? id;
  String? hospitalId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? gender;
  String? bio;
  bool? ban;
  bool? online;

  DoctorModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.image,
      this.gender,
      this.ban,
      this.bio,
      this.hospitalId,
      this.online});
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
