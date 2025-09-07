import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:kznutrition/CameraScanner.dart';
import 'package:kznutrition/NutritionalInfoScreen.dart';
import 'package:kznutrition/services/GeminiService.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/CustomWigets/MealGroup.dart';
import 'package:kznutrition/CustomWigets/ScanButton.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  int _selectedIndex = 0;
  final GeminiService _geminiService = GeminiService();
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  final List<MealEntry> _todayMeals = [];
  final List<MealEntry> _yesterdayMeals = [];
  String? _lastAnalysisSummary; // State to hold the latest summary

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addMealEntry(MealEntry entry) {
    setState(() {
      _todayMeals.add(entry);
      // If the new entry has a summary, update the state.
      // If it doesn't (e.g., from a barcode), the summary disappears.
      _lastAnalysisSummary = entry.summary;
    });
  }

  Future<void> _analyzeImageAndAddEntry(String imagePath) async {
    if (!mounted) return;

    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      final imageFile = File(imagePath);
      final analysis = await _geminiService.analyzeImage(imageFile);

      Navigator.pop(context); // Close loading dialog

      if (analysis != null && mounted) {
        // Helper to safely convert numbers from the JSON
        double? toDouble(dynamic value) {
          if (value is num) return value.toDouble();
          return null;
        }

        final newEntry = await Navigator.push<MealEntry>(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionalInfoScreen(
              foodName: analysis['foodName'] ?? 'Analyzed Food',
              calories: analysis['calories'] ?? 0,
              summary: analysis['summary'],
              // Pass new data
              protein: toDouble(analysis['protein']),
              carbs: toDouble(analysis['carbs']),
              fat: toDouble(analysis['fat']),
            ),
          ),
        );
        if (newEntry != null) {
          _addMealEntry(newEntry);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not analyze image')),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("An error occurred during image analysis: $e");
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Symbols.photo_camera),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final String? imagePath = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CameraScannerScreen()),
                  );
                  if (imagePath != null) {
                    _analyzeImageAndAddEntry(imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Symbols.collections),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery);
                  if (image != null) {
                    _analyzeImageAndAddEntry(image.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Track', style: TextStyle(fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColours.textPrimary)),
        actions: [
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This button now calls the action sheet
              ScanButton(icon: Symbols.photo_camera,
                  text: 'Scan camera',
                  onPressed: _showImageSourceActionSheet),
              const SizedBox(height: 32),

              // Meal Groups...
              MealGroup(title: 'Today', meals: _todayMeals),
              const SizedBox(height: 16),

              // --- NEW: Animated summary text widget ---
              AnimatedOpacity(
                opacity: _lastAnalysisSummary != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _lastAnalysisSummary != null
                    ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColours.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                          Symbols.lightbulb, color: Colors.yellow, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _lastAnalysisSummary!,
                          style: const TextStyle(
                              color: AppColours.textSecondary, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
              MealGroup(title: 'Yesterday', meals: _yesterdayMeals),
            ],
          ),
        ),
      ),
    );
  }
}