import 'package:flutter/material.dart';
import 'package:babies_tracker/app/app_colors.dart';

class CircularProgressComponent extends StatelessWidget {
  const CircularProgressComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primerColor,
        strokeWidth: 2,
      ),
    );
  }

  static void showSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
      ),
    );
  }
}
