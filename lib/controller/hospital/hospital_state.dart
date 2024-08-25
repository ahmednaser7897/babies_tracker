part of 'hospital_cubit.dart';

abstract class HospitalState {}

class HospitalInitial extends HospitalState {}

class LoadingChangeHomeIndex extends HospitalState {}

class ScChangeHomeIndex extends HospitalState {}

class LoadingGetHospital extends HospitalState {}

class ScGetHospital extends HospitalState {}

class ErorrGetHospital extends HospitalState {
  final String error;
  ErorrGetHospital(this.error);
}

class LoadingGetHomeData extends HospitalState {}

class ScGetHomeData extends HospitalState {}

class ErorrGetHomeData extends HospitalState {
  final String error;
  ErorrGetHomeData(this.error);
}

class LoadingEditHospital extends HospitalState {}

class ScEditHospital extends HospitalState {}

class ErorrEditHospital extends HospitalState {
  final String error;
  ErorrEditHospital(this.error);
}

class LoadingChangeHospitalBan extends HospitalState {}

class ScChangeHospitalBan extends HospitalState {}

class ErorrChangeHospitalBan extends HospitalState {
  final String error;
  ErorrChangeHospitalBan(this.error);
}

class LoadingChangeHospitalOnline extends HospitalState {}

class ScChangeHospitalOnline extends HospitalState {}

class ErorrChangeHospitalOnline extends HospitalState {
  final String error;
  ErorrChangeHospitalOnline(this.error);
}

class LoadingAddDoctor extends HospitalState {}

class ScAddDoctor extends HospitalState {}

class ErorrAddDoctor extends HospitalState {
  final String error;
  ErorrAddDoctor(this.error);
}

class LoadingChangeDoctorBan extends HospitalState {}

class ScChangeDoctorBan extends HospitalState {}

class ErorrChangeDoctorBan extends HospitalState {
  final String error;
  ErorrChangeDoctorBan(this.error);
}

class LoadingChangeDoctorOnline extends HospitalState {}

class ScChangeDoctorOnline extends HospitalState {}

class ErorrChangeDoctorOnline extends HospitalState {
  final String error;
  ErorrChangeDoctorOnline(this.error);
}

class LoadingAddMother extends HospitalState {}

class ScAddMother extends HospitalState {}

class ErorrAddMother extends HospitalState {
  final String error;
  ErorrAddMother(this.error);
}

class LoadingChangeMotherBan extends HospitalState {}

class ScChangeMotherBan extends HospitalState {}

class ErorrChangeMotherBan extends HospitalState {
  final String error;
  ErorrChangeMotherBan(this.error);
}

class LoadingChangeBabyLeft extends HospitalState {}

class ScChangeBabyLeft extends HospitalState {}

class ErorrChangeBabyLeft extends HospitalState {
  final String error;
  ErorrChangeBabyLeft(this.error);
}

class LoadingChangeMotherLeft extends HospitalState {}

class ScChangeMotherLeft extends HospitalState {}

class ErorrChangeMotherLeft extends HospitalState {
  final String error;
  ErorrChangeMotherLeft(this.error);
}
