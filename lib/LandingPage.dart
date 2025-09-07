import 'package:flutter/material.dart';
import 'package:kznutrition/TrackScreen.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/GoalScreen.dart';
import 'package:kznutrition/insightScreen.dart';

class TrackPage extends StatelessWidget {
  const TrackPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const TrackScreen();
  }
}

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const GoalsScreen();
  }
}

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const InsightsScreen();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
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
  // 1. State variable to keep track of the currently selected tab index.
  int _selectedIndex = 0;

  // 2. A list of the widgets to display for each tab.
  static const List<Widget> _pageOptions = <Widget>[
    TrackPage(),
    GoalsPage(),
    InsightsPage(),
    ProfilePage()
  ];

  // 3. A function that updates the state when a tab is tapped.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4. The Scaffold widget provides the main layout structure.
    return Scaffold(
      backgroundColor: const Color(0xFF090909),

      // 5. The body displays the currently selected page widget.
      body: _pageOptions.elementAt(_selectedIndex),

      // 6. The BottomNavigationBar widget is the Flutter equivalent of BottomNavigationView.
      bottomNavigationBar: BottomNavigationBar(
        // 7. These are the items (tabs) to display in the navigation bar.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        // 8. Styling and state properties for the navigation bar.
        currentIndex: _selectedIndex, // Highlights the correct tab.
        onTap: _onItemTapped, // Calls our function when a tab is tapped.

        // --- Styling ---
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible.
        backgroundColor: AppColours.background, // Equivalent to `?android:attr/windowBackground`.
        selectedItemColor: Colors.white, // Color for the active tab's icon and label.
        unselectedItemColor: Colors.grey.shade600, // Color for inactive tabs.
      ),
    );
  }
}