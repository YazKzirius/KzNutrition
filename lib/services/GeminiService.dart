import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<Map<String, dynamic>?> analyzeImage(File imageFile) async {
    if (_apiKey.isEmpty) {
      print('ERROR: Please add your Gemini API Key to lib/services/gemini_service.dart');
      return null;
    }

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: _apiKey);
      final imageBytes = await imageFile.readAsBytes();

      final prompt = [
        Content.multi([
          // --- UPDATED PROMPT: Now asks for protein, carbs, and fat ---
          TextPart(
              'Analyze the food in this image. Provide the food\'s name, estimated calories, protein, carbs, and fat in grams, plus a brief nutritional summary. Respond ONLY in this exact JSON format: {"foodName": "...", "calories": 123, "protein": 10, "carbs": 20, "fat": 5, "summary": "..."}. The nutritional values must be numbers.'),
          DataPart('image/jpeg', imageBytes),
        ]),
      ];

      final response = await model.generateContent(prompt);

      if (response.text != null) {
        final cleanedJson = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        return json.decode(cleanedJson) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error analyzing image with Gemini: $e');
    }
    return null;
  }
}