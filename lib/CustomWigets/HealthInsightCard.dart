import 'package:flutter/material.dart';
import 'package:kznutrition/services/HealthService.dart';
import 'package:kznutrition/utils/AppColours.dart';

class HealthInsightCard extends StatelessWidget {
  final HealthInsight insight;

  const HealthInsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure card takes full width
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColours.card,
        borderRadius: BorderRadius.circular(16),
      ),
      // --- UPDATED LAYOUT: Changed from a Row to a Column ---
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            insight.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColours.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: const TextStyle(
              fontSize: 15,
              color: AppColours.textSecondary,
              height: 1.5, // Improves readability
            ),
          ),
        ],
      ),
    );
  }
}