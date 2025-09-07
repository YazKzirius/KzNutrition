import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:flutter/material.dart';

class HealthInsight {
  final String title;
  final String description;

  HealthInsight({required this.title, required this.description});

  factory HealthInsight.fromJson(Map<String, dynamic> json) {
    return HealthInsight(
      title: json['title'],
      description: json['description'],
    );
  }
}

class DietaryRecommendation {
  final String title;
  final String description;
  final IconData icon;

  DietaryRecommendation({required this.title, required this.description, required this.icon});

  factory DietaryRecommendation.fromJson(Map<String, dynamic> json, IconData icon) {
    return DietaryRecommendation(
      title: json['title'],
      description: json['description'],
      icon: icon,
    );
  }
}

class GeminiInsightsService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<Map<String, dynamic>?> fetchInsights({
    required List<MealEntry> meals,
    required Set<String> goals,
  }) async {
    if (_apiKey.isEmpty) {
      print('ERROR: GEMINI_API_KEY not found in .env file.');
      return null;
    }

    final String dietSummary = meals.map((m) => '${m.foodName} (${m.calories} cal)').join(', ');
    final String goalSummary = goals.join(', ');

    final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: _apiKey);
    
    final prompt = [
      Content.text(
          'Act as a nutritional expert. Based on the user\'s diet and health goals, provide personalized health insights and dietary recommendations. '
              'User\'s recent diet: [$dietSummary]. '
              'User\'s goals: [$goalSummary]. '
              'Respond ONLY with a valid JSON object in the following format, no markdown or extra text: '
              '{'
              '  "healthInsights": {'
              '    "cognitive": {"title": "Cognitive Health", "description": "A score-based summary..."},'
              '    "mood": {"title": "Mood", "description": "A summary about mood..."},'
              '    "aging": {"title": "Biological Aging", "description": "A summary about biological age..."}'
              '  },'
              '  "dietaryRecommendations": {'
              '    "omega3": {"title": "Omega-3 Boost", "description": "A specific recommendation about omega-3..."},'
              '    "antioxidant": {"title": "Antioxidant Power", "description": "A recommendation about fruits/veg..."},'
              '    "hydration": {"title": "Hydration", "description": "A recommendation about hydration..."}'
              '  }'
              '}'
      ),
    ];

    try {
      final response = await model.generateContent(prompt);
      if (response.text != null) {
        final cleanedJson = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
        return json.decode(cleanedJson) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching insights from Gemini: $e');
    }
    return null;
  }
}