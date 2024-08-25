import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/ui/componnents/custom_dialog.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_sized_box.dart';
import '../../../app/document_picker.dart';
import '../../../app/text_style.dart';
import 'image_cubit/image_cubit.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, this.init});
  final String? init;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return addingImageWidget();
    });
  }

  Widget addingImageWidget() {
    return BlocBuilder<ImageCubit, ImageState>(builder: (context, state) {
      ImageCubit cubit = ImageCubit.get(context);
      return FormField<File>(
        initialValue: cubit.image,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (File? value) {
          // if (init != null && init!.isNotEmpty) {
          //   return null;
          // }
          // if (cubit.image == null) {
          //   return "add photo";
          // }
          return null;
        },
        builder: (state) => Column(
          children: [
            SizedBox(
              width: 40.w,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 20.w,
                    backgroundColor: Colors.grey[200],
                    foregroundImage:
                        cubit.image != null ? FileImage(cubit.image!) : null,
                    child: (init != null && init!.isNotEmpty)
                        ? Container(
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(init!),
                              ),
                            ),
                          )
                        : Icon(
                            Icons.photo_library_outlined,
                            size: 20.w,
                            color: AppColors.primerColor,
                          ),
                  ),
                  cameraIconWidget(state),
                ],
              ),
            ),
            AppSizedBox.h3,
            if (init == null &&
                state.hasError &&
                state.errorText != null &&
                state.errorText != "")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  state.errorText!,
                  style: AppTextStyle.getRegularStyle(
                      color: AppColors.errorColor, fontSize: 10.sp),
                ),
              )
          ],
        ),
      );
    });
  }

  Widget cameraIconWidget(FormFieldState<File> state) {
    return Builder(builder: (context) {
      ImageCubit cubit = ImageCubit.get(context);
      return Align(
        alignment: AlignmentDirectional.topEnd,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primer,
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkResponse(
                onTap: cubit.image != null
                    ? () {
                        cubit.removeImage();
                        state.didChange(cubit.image);
                      }
                    : () async {
                        var result = await showImagePikerDialog(context);
                        if (result != null) {
                          if (result == PickImageFromEnum.gallery) {
                            await cubit.pickImage(PickImageFromEnum.gallery);
                          } else {
                            await cubit.pickImage(PickImageFromEnum.camera);
                            print("object");
                          }
                          state.didChange(cubit.image);
                        }
                      },
                child: Container(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: Icon(
                    cubit.image == null ? Icons.camera_alt : Icons.delete,
                    color: Colors.white,
                    size: 13.sp,
                  ),
                )),
          ),
        ),
      );
    });
  }

  Future<PickImageFromEnum?> showImagePikerDialog(BuildContext context) async {
    var result = await CustomDialog.show(
        context: context,
        dialogContent: Container(
          alignment: AlignmentDirectional.center,
          color: Colors.grey[200],
          height: 30.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              imageTypeWidget(Icons.camera, 'camera', () {
                Navigator.pop(context, PickImageFromEnum.camera);
              }),
              imageTypeWidget(Icons.photo_camera_back, 'gallery', () {
                Navigator.pop(context, PickImageFromEnum.gallery);
              }),
            ],
          ),
        ));
    return result;
  }

  Widget imageTypeWidget(IconData icon, String text, Function onTap) {
    return Builder(builder: (context) {
      return Material(
        color: Colors.grey[200],
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          onTap: () => onTap(),
          child: Container(
            padding: EdgeInsets.all(10.sp),
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                border: Border.all(color: AppColors.grey, width: 2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color: AppColors.primerColor,
                ),
                AppSizedBox.h2,
                FittedBox(
                  child: Text(
                    text,
                    style: AppTextStyle.getRegularStyle(
                        color: AppColors.primerColor, fontSize: 15.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
