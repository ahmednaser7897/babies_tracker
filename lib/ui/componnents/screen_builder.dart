import 'package:flutter/material.dart';

import '../../app/app_sized_box.dart';
import 'const_widget.dart';
import 'log_out_button.dart';

Widget screenBuilder({
  required bool isSc,
  required bool isErorr,
  required bool isLoading,
  required bool isEmpty,
  required Widget contant,
}) {
  if (isLoading) {
    return const CircularProgressComponent();
  } else if (isSc) {
    return contant;
  } else if (isErorr) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Erorr'),
          AppSizedBox.h10,
          LogOutButton(onTap: () {}),
        ],
      ),
    );
  } else if (isEmpty) {
    return const Center(
      child: Text('Empty'),
    );
  } else {
    return const Center(child: Text('No data to show')
        //LogOutButton(onTap: () {}),
        );
  }
}
