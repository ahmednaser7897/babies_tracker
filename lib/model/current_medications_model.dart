// ignore_for_file: public_member_api_docs, sort_constructors_first

//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'current_medications_model.g.dart';

@JsonSerializable(includeIfNull: false)
class CurrentMedicationsModel {
  String? id;
  String? motherId;
  String? name;
  String? dosage;
  int?
      frequency; //(Integer : min: 1)      Note: How often the medication is taken (e.g., daily, 3 a day)
  String? startDate;
  String? endDate; //(nullable)
  String? docyorlId;
  CurrentMedicationsModel({
    this.id,
    this.motherId,
    this.name,
    this.dosage,
    this.startDate,
    this.endDate,
    this.doctorNotes,
    this.docyorlId,
    this.frequency,
    this.purpose,
  });
  String? purpose; // (text)
  String? doctorNotes; //(text: nullable)

  factory CurrentMedicationsModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentMedicationsModelFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentMedicationsModelToJson(this);
}
