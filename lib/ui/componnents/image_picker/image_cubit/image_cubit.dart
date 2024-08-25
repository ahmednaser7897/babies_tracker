import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/document_picker.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(RegistrationnInitial());

  static ImageCubit get(context) => BlocProvider.of(context);

  File? image;
  DocumentHelper documentHelper = DocumentHelper();
  Future<void> pickImage(PickImageFromEnum imageType) async {
    image = await documentHelper.pickImage(imageType);
    emit(PickImageState(image));
  }

  void removeImage() {
    image = null;
    emit(RemoveImageState());
  }
}
