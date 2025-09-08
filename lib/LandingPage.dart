import 'package:flutter/material.dart';
import 'package:kznutrition/TrackScreen.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/GoalScreen.dart';
import 'package:kznutrition/insightScreen.dart';
import 'package:kznutrition/services/MealStorageService.dart';
import 'package:kznutrition/models/MealEntry.dart';
import 'package:kznutrition/services/GoalStorageService.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Library Page', style: TextStyle(color: Colors.white)));
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  final MealStorageService _storageService = MealStorageService();
  final GoalStorageService _goalStorageService = GoalStorageService();

  List<MealEntry> _allMeals = [];
  Set<String> _userGoals = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedMeals = await _storageService.loadMeals();
    final loadedGoals = await _goalStorageService.loadGoals();

    setState(() {
      _allMeals = loadedMeals;
      _userGoals = loadedGoals.isNotEmpty ? loadedGoals : {'Memory Improvement', 'Stress Reduction'};
    });
  }

  Future<void> _addMeal(MealEntry newMeal) async {
    setState(() {
      _allMeals.add(newMeal);
    });
    await _storageService.saveMeals(_allMeals);
  }

  Future<void> _saveGoals(Set<String> newGoals) async {
    setState(() {
      _userGoals = newGoals;
    });
    // Persist the changes using the new service.
    await _goalStorageService.saveGoals(_userGoals); // <-- NEW
    print("Goals saved to device: $_userGoals");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _deleteMeal(MealEntry mealToDelete) async {
    setState(() {
      _allMeals.remove(mealToDelete);
    });
    // Persist the change to the device
    await _storageService.saveMeals(_allMeals);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TrackScreen(
        meals: _allMeals,
        onAddMeal: _addMeal,
        onDeleteMeal: _deleteMeal,
      ),
      InsightsScreen(meals: _allMeals, goals: _userGoals),
      GoalsScreen(savedGoals: _userGoals, onSaveGoals: _saveGoals)
    ];
    return Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: pages.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Goals',
          ),
        ],
        currentIndex: _selectedIndex, // Highlights the correct tab.
        onTap: _onItemTapped, // Calls our function when a tab is tapped.

        type: BottomNavigationBarType.fixed, // Ensures all labels are visible.
        backgroundColor: AppColours.background, // Equivalent to `?android:attr/windowBackground`.
        selectedItemColor: Colors.white, // Color for the active tab's icon and label.
        unselectedItemColor: Colors.grey.shade600, // Color for inactive tabs.
      ),
    );
  }
}