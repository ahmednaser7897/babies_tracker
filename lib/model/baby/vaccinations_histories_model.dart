// ignore_for_file: public_member_api_docs, sort_constructors_first
//flutter packages pub run build_runner build
//dart run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'vaccinations_histories_model.g.dart';

@JsonSerializable(includeIfNull: false)
class VaccinationsHistoriesModel {
  String? id;
  String? babyId;
  String? vaccineName;
  String? vaccinationDate;
  String? dose;
  String? administering; // Entity
  String? administrationSite; // enum["Arm", "Thigh"]
  String? nextDoseDate; // (date: nullable)
  String? sideEffects; //(text: nullable)
  VaccinationsHistoriesModel(
      {this.id,
      this.babyId,
      this.vaccineName,
      this.vaccinationDate,
      this.dose,
      this.administering,
      this.sideEffects,
      this.administrationSite,
      this.nextDoseDate});

  factory VaccinationsHistoriesModel.fromJson(Map<String, dynamic> json) =>
      _$VaccinationsHistoriesModelFromJson(json);
  Map<String, dynamic> toJson() => _$VaccinationsHistoriesModelToJson(this);
}
