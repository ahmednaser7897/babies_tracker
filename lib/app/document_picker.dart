// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

enum PickImageFromEnum { camera, gallery }

class DocumentHelper {
  final ImagePicker _imagepicker = ImagePicker();
  final FilePicker _fileicker = FilePicker.platform;

  File? pickedFile;
  File? pickedImage;
  bool isValid = true;
  Future<File?> pickFile() async {
    FilePickerResult? filePickerResult = await _fileicker.pickFiles(
      type: FileType.any,
    );
    if (filePickerResult == null) {
      return null;
    } else {
      pickedFile = File(filePickerResult.files.single.path!);
      var ext = pickedFile?.path.split('.').last;
      print(ext);
      bool wrongExt =
          ext != 'jpg' && ext != 'pdf' && ext != 'png' && ext != 'jpeg';
      if (wrongExt) {
        isValid = false;
        return null;
      } else {
        bool isImage = ext == 'jpg' || ext == 'png' || ext == 'jpeg';
        if (isImage) {
          isValid = true;
          // pickedFile =
          //   await compressFile(filePath: filePickerResult.files.single.path!);
        }

        return pickedFile;
      }
    }
  }

  Future<File?> pickImage(PickImageFromEnum type) async {
    final XFile? photo;
    if (type == PickImageFromEnum.camera) {
      photo = await _imagepicker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _imagepicker.pickImage(source: ImageSource.gallery);
    }
    if (photo == null) {
      return null;
    } else {
      pickedImage = File(photo.path);
      await printFileData(image: pickedImage!, title: "image");
      //pickedImage = await compressFile(filePath: photo.path);
      // await printFileData(image: pickedImage!, title: "compressedImage");
      return pickedImage;
    }
  }

  // Future<File> compressFile({required String filePath}) async {
  //   Size imageSize = await getImageSize(filePath: filePath);
  //   File compressedFile = await FlutterNativeImage.compressImage(
  //     filePath,
  //     quality: 100,
  //     percentage: 60,
  //     targetHeight: imageSize.height.toInt(),
  //     targetWidth: imageSize.width.toInt(),
  //   );
  //   return compressedFile;
  // }

  Future<Size> getImageSize({required String filePath}) async {
    const double mainSize = 1024;
    double targetHeight = 0;
    double targetWidth = 0;
    ImageProperties imageProperties =
        await FlutterNativeImage.getImageProperties(filePath);
    if (imageProperties.width! < mainSize) {
      targetHeight = imageProperties.height!.toDouble();
      targetWidth = imageProperties.width!.toDouble();
    } else {
      targetHeight = (imageProperties.height!.toDouble() * mainSize) /
          imageProperties.width!.toDouble();
      targetWidth = mainSize;
    }
    return Size(targetWidth, targetHeight);
  }

  Future<void> printFileData(
      {required File image, required String title}) async {
    ImageProperties imageProperties =
        await FlutterNativeImage.getImageProperties(image.path);
    final bytes = image.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    print("$title width ${imageProperties.width}");
    print("$title height ${imageProperties.height}");
    print("$title ${kb.toStringAsFixed(2)} kb ${mb.toStringAsFixed(2)} mb");
  }

  void endUploadFile() {
    pickedFile = null;
    pickedImage = null;
  }
}
