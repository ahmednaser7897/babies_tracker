// ignore_for_file: public_member_api_docs, sort_constructors_first
//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'birth_report_model.g.dart';

@JsonSerializable(includeIfNull: false)
class BirthReportModel {
  String? id;
  String? hospitaId;
  String? doctorId;
  String? motherId;
  String? babyId;
  String? birthDate;
  int? gestationalAge;
  String? deliveryTtype; // enum["Natural", "Cesarean"]
  String? doctorNotes; //(text: nullable)
  BirthReportModel({
    this.id,
    this.hospitaId,
    this.doctorId,
    this.motherId,
    this.babyId,
    this.birthDate,
    this.gestationalAge,
    this.doctorNotes,
  });
  factory BirthReportModel.fromJson(Map<String, dynamic> json) =>
      _$BirthReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$BirthReportModelToJson(this);
}
