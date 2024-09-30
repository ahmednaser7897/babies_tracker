//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'admin_model.g.dart';

@JsonSerializable(includeIfNull: false)
class AdminModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? image;
  String? gender;
  String? createdAt;
  bool? ban;
  bool? online;

  AdminModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.image,
      this.gender,
      this.ban,
      this.createdAt,
      this.online});
  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminModelToJson(this);
}
