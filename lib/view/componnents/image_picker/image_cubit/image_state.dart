part of 'image_cubit.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class RegistrationnInitial extends ImageState {}

class LoadingPickImageState extends ImageState {}

class PickImageState extends ImageState {
  final File? image;
  const PickImageState(this.image);
}

class LoadingRemoveImageState extends ImageState {}

class RemoveImageState extends ImageState {}

class LoadingPicklicenseState extends ImageState {}

class ScPicklicenseState extends ImageState {}

class LoadingRemovelicenseState extends ImageState {}

class ScRemovelicenseState extends ImageState {}

class StartNotValidLicenseState extends ImageState {}

class EndNotValidLicenseState extends ImageState {}
