import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/CustomWigets/MealEntryCard.dart';
import 'package:kznutrition/CustomWigets/ScanButton.dart';
// Import your scanner screen if you have one
// import 'package:kznutrition/screens/scanner_screen.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _scanBarcode() {
    // Navigate to your barcode scanner page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const BarcodeScannerPage()));
    print("Scan Barcode Tapped");
  }

  void _scanWithCamera() {
    // Navigate to your camera analysis page
    print("Scan Camera Tapped");
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
          title: const Text('Track',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColours.textPrimary)),
          actions: [
            IconButton(
              icon: const Icon(
                Symbols.add,
                color: AppColours.textPrimary,
                size: 32,
                weight: 600,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: AppColours.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search for food',
                    hintStyle: const TextStyle(color: AppColours.textSecondary),
                    prefixIcon:
                    const Icon(Symbols.search, color: AppColours.textSecondary),
                    filled: true,
                    fillColor: AppColours.card,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: AppColours.border, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ScanButton(
                  icon: Symbols.barcode,
                  text: 'Scan a barcode',
                  onPressed: _scanBarcode,
                ),
                const SizedBox(height: 12),
                ScanButton(
                  icon: Symbols.photo_camera,
                  text: 'Scan camera',
                  onPressed: _scanWithCamera,
                ),
                const SizedBox(height: 32),
                const Text('Today',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const MealEntryCard(mealType: 'Lunch', time: '12:00 PM', calories: '350'),
                const SizedBox(height: 12),
                const MealEntryCard(mealType: 'Dinner', time: '7:00 PM', calories: '600'),
                const SizedBox(height: 12),
                const MealEntryCard(mealType: 'Snack', time: '10:00 PM', calories: '150'),
                const SizedBox(height: 32),
                const Text('Yesterday',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const MealEntryCard(mealType: 'Lunch', time: '12:00 PM', calories: '400'),
                const SizedBox(height: 12),
                const MealEntryCard(mealType: 'Dinner', time: '7:00 PM', calories: '650'),
                const SizedBox(height: 12),
                const MealEntryCard(mealType: 'Snack', time: '10:00 PM', calories: '200'),
              ],
            ),
          ),
        ),
    );
  }
}