part of 'admin_cubit.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class LoadingChangeHomeIndex extends AdminState {}

class ScChangeHomeIndex extends AdminState {}

class LoadingGetAdmin extends AdminState {}

class ScGetAdmin extends AdminState {}

class ErorrGetAdmin extends AdminState {
  final String error;
  ErorrGetAdmin(this.error);
}

class LoadingAddAdmin extends AdminState {}

class ScAddAdmin extends AdminState {}

class ErorrAddAdmin extends AdminState {
  final String error;
  ErorrAddAdmin(this.error);
}

class LoadingGetHomeData extends AdminState {}

class ScGetHomeData extends AdminState {}

class ErorrGetHomeData extends AdminState {
  final String error;
  ErorrGetHomeData(this.error);
}

class LoadingEditAdmin extends AdminState {}

class ScEditAdmin extends AdminState {}

class ErorrEditAdmin extends AdminState {
  final String error;
  ErorrEditAdmin(this.error);
}

class LoadingChangeAdminBan extends AdminState {}

class ScChangeAdminBan extends AdminState {}

class ErorrChangeAdminBan extends AdminState {
  final String error;
  ErorrChangeAdminBan(this.error);
}

class LoadingChangeAdminOnline extends AdminState {}

class ScChangeAdminOnline extends AdminState {}

class ErorrChangeAdminOnline extends AdminState {
  final String error;
  ErorrChangeAdminOnline(this.error);
}

class LoadingAddHospital extends AdminState {}

class ScAddHospital extends AdminState {}

class ErorrAddHospital extends AdminState {
  final String error;
  ErorrAddHospital(this.error);
}

class LoadingChangeHospitalBan extends AdminState {}

class ScChangeHospitalBan extends AdminState {}

class ErorrChangeHospitalBan extends AdminState {
  final String error;
  ErorrChangeHospitalBan(this.error);
}

class LoadingChangeHospitalOnline extends AdminState {}

class ScChangeHospitalOnline extends AdminState {}

class ErorrChangeHospitalOnline extends AdminState {
  final String error;
  ErorrChangeHospitalOnline(this.error);
}
