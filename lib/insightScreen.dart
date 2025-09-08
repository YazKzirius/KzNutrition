import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:kznutrition/services/HealthService.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/CustomWigets/HealthInsightCard.dart';
import 'package:kznutrition/CustomWigets/RecommendationCard.dart';

class InsightsScreen extends StatefulWidget {
  final List<MealEntry> meals;
  final Set<String> goals;

  const InsightsScreen({super.key, required this.meals, required this.goals});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<Map<String, dynamic>?> _insightsFuture;
  final GeminiInsightsService _insightsService = GeminiInsightsService();

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  // When the screen is shown, if the data has changed, reload insights.
  @override
  void didUpdateWidget(covariant InsightsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.meals != oldWidget.meals || widget.goals != oldWidget.goals) {
      _loadInsights();
    }
  }

  void _loadInsights() {
    setState(() {
      _insightsFuture = _insightsService.fetchInsights(
        meals: widget.meals,
        goals: widget.goals,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColours.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Insights',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColours.textPrimary),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _insightsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load insights.', style: TextStyle(color: AppColours.textSecondary)),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _loadInsights, child: const Text('Try Again')),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final insights = (data['healthInsights'] as Map).map(
                (key, value) => MapEntry(key, HealthInsight.fromJson(value)),
          );
          final recommendations = (data['dietaryRecommendations'] as Map).map(
                (key, value) => MapEntry(key, DietaryRecommendation.fromJson(value, _getIconForKey(key))),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Health Insights', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColours.textPrimary)),
                const SizedBox(height: 20),
                HealthInsightCard(insight: insights['cognitive']!),
                const SizedBox(height: 16),
                HealthInsightCard(insight: insights['mood']!),
                const SizedBox(height: 16),
                HealthInsightCard(insight: insights['aging']!),
                const SizedBox(height: 40),
                const Text('Dietary Recommendations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColours.textPrimary)),
                const Text(
                  'Based on your tracked data, here are some recommendations to further enhance your well-being.',
                  style: TextStyle(color: AppColours.textSecondary, fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),
                RecommendationCard(recommendation: recommendations['omega3']!),
                const SizedBox(height: 16),
                RecommendationCard(recommendation: recommendations['antioxidant']!),
                const SizedBox(height: 16),
                RecommendationCard(recommendation: recommendations['hydration']!),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForKey(String key) {
    switch (key) {
      case 'omega3': return Symbols.set_meal;
      case 'antioxidant': return Symbols.eco;
      case 'hydration': return Symbols.water_drop;
      default: return Symbols.help;
    }
  }
}