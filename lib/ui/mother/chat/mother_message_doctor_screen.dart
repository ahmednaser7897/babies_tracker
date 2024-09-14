import 'dart:io';

import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/ui/mother/chat/build_my_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_colors.dart';
import '../../../app/app_prefs.dart';
import '../../../app/document_picker.dart';
import '../../../app/icon_broken.dart';
import '../../../controller/mother/mother_cubit.dart';
import '../../../controller/mother/mother_state.dart';
import '../../../model/doctor_model.dart';
import '../../../model/message_model.dart';

class MotherMessageDoctorScreen extends StatefulWidget {
  final DoctorModel doctor;
  const MotherMessageDoctorScreen({super.key, required this.doctor});

  @override
  State<MotherMessageDoctorScreen> createState() =>
      _MotherMessageDoctorScreenState();
}

class _MotherMessageDoctorScreenState extends State<MotherMessageDoctorScreen> {
  TextEditingController messageController = TextEditingController();
  File? file;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MotherCubit, MotherState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToEnd();
        });
      },
      builder: (context, state) {
        MotherCubit cubit = MotherCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.doctor.name}'),
          ),
          body: state is LoadingGetdMessages
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: cubit.messages.isNotEmpty
                            ? ListView.separated(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  MessageModel message = cubit.messages[index];
                                  if (message.type == AppStrings.mother) {
                                    return BuildMyMessageWidget(
                                        model: message,
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        backgroundColor:
                                            AppColors.primer.withOpacity(0.2));
                                  }
                                  return BuildMyMessageWidget(
                                    model: message,
                                    alignment: AlignmentDirectional.centerStart,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.2),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return AppSizedBox.h1;
                                },
                                itemCount: cubit.messages.length,
                              )
                            : const Center(
                                child: Text('No messages yet'),
                              ),
                      ),
                      if (file != null) ...[
                        ListTile(
                          title: Text(
                              'Selected file : ${file!.path.split('/').last}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.highlight_remove_outlined),
                            onPressed: () {
                              setState(() {
                                file = null;
                              });
                            },
                          ),
                        ),
                        AppSizedBox.h1
                      ],
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: 50,
                          padding: const EdgeInsetsDirectional.only(
                            start: 15,
                            end: 0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey,
                              )),
                          child: TextFormField(
                            controller: messageController,
                            maxLines: 999,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 3),
                              border: InputBorder.none,
                              hintText: 'Type your message here...',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (state is LoadingUploadFile)
                                      ? const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: CircularProgressIndicator(),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            var documentHelper =
                                                DocumentHelper();
                                            var value =
                                                await documentHelper.pickFile();
                                            if (value != null) {
                                              print(value.path);
                                              setState(() {
                                                file = value;
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.attachment_sharp)),
                                  MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      if (messageController.text.isNotEmpty ||
                                          file != null) {
                                        cubit.sendMessage(
                                          file: file,
                                          messageModel: MessageModel(
                                            motherId: AppPreferences.uId,
                                            doctorId: widget.doctor.id,
                                            message: messageController.text,
                                            dateTime: DateTime.now().toString(),
                                            type: AppStrings.mother,
                                          ),
                                        );
                                        file = null;
                                        messageController.clear();
                                      }
                                    },
                                    color: AppColors.primer,
                                    elevation: 2,
                                    height: 10.h,
                                    minWidth: 15.w,
                                    child: const Icon(
                                      IconBroken.Send,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
