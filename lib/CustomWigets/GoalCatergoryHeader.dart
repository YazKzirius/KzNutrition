import 'package:flutter/material.dart';
import 'package:kznutrition/utils/AppColours.dart';

class GoalCategoryHeader extends StatelessWidget {
  final String title;
  const GoalCategoryHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColours.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}