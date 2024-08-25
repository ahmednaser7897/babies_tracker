abstract class MotherState {}

class MotherInitial extends MotherState {}

class LoadingChangeHomeIndex extends MotherState {}

class ScChangeHomeIndex extends MotherState {}

class LoadingGetMother extends MotherState {}

class ScGetMother extends MotherState {}

class ErorrGetMother extends MotherState {
  final String error;
  ErorrGetMother(this.error);
}

class LoadingGetHomeData extends MotherState {}

class ScGetHomeData extends MotherState {}

class ErorrGetHomeData extends MotherState {
  final String error;
  ErorrGetHomeData(this.error);
}

class LoadingEditMother extends MotherState {}

class ScEditMother extends MotherState {}

class ErorrEditMother extends MotherState {
  final String error;
  ErorrEditMother(this.error);
}

class LoadingChangeMotherOnline extends MotherState {}

class ScChangeMotherOnline extends MotherState {}

class ErorrChangeMotherOnline extends MotherState {
  final String error;
  ErorrChangeMotherOnline(this.error);
}

class LoadingSendMessage extends MotherState {}

class ScSendMessage extends MotherState {}

class ErorrSendMessage extends MotherState {
  final String error;
  ErorrSendMessage(this.error);
}

class LoadingGetdMessages extends MotherState {}

class ScGetdMessages extends MotherState {}

class ErorrGetdMessages extends MotherState {
  final String error;
  ErorrGetdMessages(this.error);
}

class LoadingUploadFile extends MotherState {}

class ScUploadFile extends MotherState {}

class ErorrUploadFile extends MotherState {
  final String error;
  ErorrUploadFile(this.error);
}
