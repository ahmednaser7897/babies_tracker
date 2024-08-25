abstract class DoctorState {}

class DoctorInitial extends DoctorState {}

class LoadingChangeHomeIndex extends DoctorState {}

class ScChangeHomeIndex extends DoctorState {}

class LoadingGetDoctor extends DoctorState {}

class ScGetDoctor extends DoctorState {}

class ErorrGetDoctor extends DoctorState {
  final String error;
  ErorrGetDoctor(this.error);
}

class LoadingGetHomeData extends DoctorState {}

class ScGetHomeData extends DoctorState {}

class ErorrGetHomeData extends DoctorState {
  final String error;
  ErorrGetHomeData(this.error);
}

class LoadingEditDoctor extends DoctorState {}

class ScEditDoctor extends DoctorState {}

class ErorrEditDoctor extends DoctorState {
  final String error;
  ErorrEditDoctor(this.error);
}

class LoadingChangeDoctorOnline extends DoctorState {}

class ScChangeDoctorOnline extends DoctorState {}

class ErorrChangeDoctorOnline extends DoctorState {
  final String error;
  ErorrChangeDoctorOnline(this.error);
}

class LoadingGetdMessages extends DoctorState {}

class ScGetdMessages extends DoctorState {}

class ErorrGetdMessages extends DoctorState {
  final String error;
  ErorrGetdMessages(this.error);
}

class LoadingUploadFile extends DoctorState {}

class ScUploadFile extends DoctorState {}

class ErorrUploadFile extends DoctorState {
  final String error;
  ErorrUploadFile(this.error);
}

class LoadingAddBaby extends DoctorState {}

class ScAddBaby extends DoctorState {}

class ErorrAddBaby extends DoctorState {
  final String error;
  ErorrAddBaby(this.error);
}

class LoadingEditBaby extends DoctorState {}

class ScEditBaby extends DoctorState {}

class ErorrEditBaby extends DoctorState {
  final String error;
  ErorrEditBaby(this.error);
}

class LoadingSendMessage extends DoctorState {}

class ScSendMessage extends DoctorState {}

class ErorrSendMessage extends DoctorState {
  final String error;
  ErorrSendMessage(this.error);
}

class LoadingAddMedications extends DoctorState {}

class ScAddMedications extends DoctorState {}

class ErorrAddMedications extends DoctorState {
  final String error;
  ErorrAddMedications(this.error);
}

class LoadingAddVaccination extends DoctorState {}

class ScAddVaccination extends DoctorState {}

class ErorrAddVaccination extends DoctorState {
  final String error;
  ErorrAddVaccination(this.error);
}

class LoadingAddSleepDetails extends DoctorState {}

class ScAddSleepDetails extends DoctorState {}

class ErorrAddSleepDetails extends DoctorState {
  final String error;
  ErorrAddSleepDetails(this.error);
}

class LoadingAddFeedingTime extends DoctorState {}

class ScAddFeedingTime extends DoctorState {}

class ErorrAddFeedingTime extends DoctorState {
  final String error;
  ErorrAddFeedingTime(this.error);
}
