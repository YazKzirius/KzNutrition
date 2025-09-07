import 'package:flutter/material.dart';
import 'package:kznutrition/services/HealthService.dart'; // Import the model
import 'package:kznutrition/utils/AppColours.dart';

class RecommendationCard extends StatelessWidget {
  final DietaryRecommendation recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColours.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColours.background,
            ),
            child: Icon(recommendation.icon, color: AppColours.textSecondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColours.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColours.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}