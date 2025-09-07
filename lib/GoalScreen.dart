import 'package:flutter/material.dart';
import 'package:kznutrition/utils/AppColours.dart';
import 'package:kznutrition/CustomWigets/GoalCatergoryHeader.dart';
import 'package:kznutrition/CustomWigets/GoalChip.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddGoalDialog extends StatefulWidget {
  const AddGoalDialog({super.key});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_controller.text.trim().isNotEmpty) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColours.card,
      title: const Text('Add a Custom Goal'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'e.g., Learn a new skill'),
        onSubmitted: (_) => _save(), // Allow saving with the keyboard's "done" button
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: _save,
        ),
      ],
    );
  }
}


class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final Set<String> _selectedGoals = {};
  late Map<String, List<String>> _goalCategories;

  final Map<String, List<String>> _initialGoalCategories = {
    'Cognitive Health': ['Memory Improvement'],
    'Mood & Well-being': ['Stress Reduction'],
    'Biological Aging': ['Cellular Health'],
  };

  @override
  void initState() {
    super.initState();
    _goalCategories = {
      for (var entry in _initialGoalCategories.entries)
        entry.key: List<String>.from(entry.value)
    };
  }

  void _toggleGoal(String goal) { /* ... same as before ... */ }
  void _deleteGoal(String category, String goal) { /* ... same as before ... */ }
  void _saveGoals() { /* ... same as before ... */ }
  void _cancel() { /* ... same as before ... */ }

  Future<void> _showAddGoalDialog(String category) async {
    // We now just show our new, self-contained dialog widget.
    final newGoal = await showDialog<String>(
      context: context,
      builder: (context) => const AddGoalDialog(), // Use the new widget
    );
    if (newGoal != null) {
      // It is now perfectly safe to call setState.
      setState(() {
        _goalCategories[category]?.add(newGoal);
        _selectedGoals.add(newGoal);
      });
    }
  }

  // All other methods are the same...
  @override
  Widget build(BuildContext context) {
    // The build method is unchanged.
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColours.textPrimary),
          onPressed: _cancel,
        ),
        title: const Text(
          'Set Your Goals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColours.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _goalCategories.entries.map((entry) {
                  final categoryName = entry.key;
                  final goals = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GoalCategoryHeader(title: categoryName),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: goals.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == goals.length) {
                            return _buildAddGoalButton(() => _showAddGoalDialog(categoryName));
                          }

                          final goal = goals[index];
                          final isPredefined = _initialGoalCategories[categoryName]?.contains(goal) ?? false;

                          return GoalChip(
                            label: goal,
                            isSelected: _selectedGoals.contains(goal),
                            onTap: () => _toggleGoal(goal),
                            onDelete: isPredefined ? null : () => _deleteGoal(categoryName, goal),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAddGoalButton(VoidCallback onPressed) {
    // This helper method is unchanged.
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Symbols.add, size: 20),
      label: const Text('Add a goal'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColours.textSecondary,
        backgroundColor: AppColours.card,
        side: BorderSide(color: AppColours.border.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ).copyWith(
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
      ),
    );
  }

  Widget _buildActionButtons() {
    // This helper method is unchanged.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _cancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.card,
                foregroundColor: AppColours.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveGoals,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.card,
                foregroundColor: AppColours.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Goals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}