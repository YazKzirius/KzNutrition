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
      title: const Text('Add a Custom Goal', style: TextStyle(color: AppColours.textPrimary)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'e.g., Learn a new skill'),
        onSubmitted: (_) => _save(), // Allow saving with the keyboard's "done" button
        style: const TextStyle(color: AppColours.textSecondary),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: AppColours.textSecondary)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Save', style: TextStyle(color: AppColours.textPrimary)),
          onPressed: _save,
        ),
      ],
    );
  }
}

class GoalsScreen extends StatefulWidget {
  final Set<String> savedGoals;
  final Function(Set<String>) onSaveGoals;

  const GoalsScreen({
    super.key,
    required this.savedGoals,
    required this.onSaveGoals,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  bool _isEditing = false;

  late Set<String> _selectedGoals;
  late Map<String, List<String>> _goalCategories;

  final Map<String, List<String>> _initialGoalCategories = {
    'Cognitive Health': ['Memory Improvement'],
    'Mood & Well-being': ['Stress Reduction'],
    'Biological Aging': ['Cellular Health'],
  };

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  @override
  void didUpdateWidget(covariant GoalsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.savedGoals != oldWidget.savedGoals) {
      _initializeState();
    }
  }

  /// Helper to set up the local state from the parent widget's data.
  void _initializeState() {
    _goalCategories = {
      for (var entry in _initialGoalCategories.entries)
        entry.key: List<String>.from(entry.value)
    };
    _selectedGoals = Set<String>.from(widget.savedGoals);
  }

  /// Toggles the selection state of a given goal.
  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
    });
  }

  /// Deletes a user-added custom goal from a category.
  void _deleteGoal(String category, String goal) {
    setState(() {
      _goalCategories[category]?.remove(goal);
      _selectedGoals.remove(goal);
    });
  }

  /// Shows a dialog for the user to type and add a new goal.
  Future<void> _showAddGoalDialog(String category) async {
    final newGoal = await showDialog<String>(
      context: context,
      builder: (context) => const AddGoalDialog(),
    );
    if (newGoal != null) {
      setState(() {
        _goalCategories[category]?.add(newGoal);
        _selectedGoals.add(newGoal);
      });
    }
  }

  /// Saves the current selections and switches back to View Mode.
  void _saveGoals() {
    widget.onSaveGoals(_selectedGoals);
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goals have been saved!')),
    );
  }

  /// Reverts any local changes and switches back to View Mode.
  void _cancelEdit() {
    setState(() {
      _initializeState();
      _isEditing = false;
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
        automaticallyImplyLeading: false,
        title: Text(
          _isEditing ? 'Set Your Goals' : 'Your Goals',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColours.textPrimary,
          ),
        ),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _cancelEdit,
              child: const Text('Cancel', style: TextStyle(color: AppColours.textSecondary, fontSize: 16)),
            )
          else
            IconButton(
              icon: const Icon(Symbols.edit, color: AppColours.textSecondary),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isEditing ? _buildEditView() : _buildReadView(),
      bottomNavigationBar: _isEditing ? _buildActionButtons() : null,
    );
  }
  void _deleteAndSaveGoal(String goal) {
    // Create a mutable copy of the current saved goals
    final updatedGoals = Set<String>.from(widget.savedGoals);
    // Remove the goal
    updatedGoals.remove(goal);
    // Call the parent's save function to persist the change immediately
    widget.onSaveGoals(updatedGoals);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$goal" removed.')),
    );
  }
  Widget _buildReadView() {
    if (widget.savedGoals.isEmpty) {
      return const Center( /* ... same as before ... */ );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: widget.savedGoals.map((goal) {
          // Check if the goal is one of the original, non-deletable ones
          final bool isPredefined = _initialGoalCategories.values
              .expand((goals) => goals)
              .contains(goal);

          return Container(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 4),
            decoration: BoxDecoration(
              color: AppColours.card,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Make the chip only as wide as its content
              children: [
                Text(
                  goal,
                  style: const TextStyle(
                    color: AppColours.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Only show the delete button for non-predefined, custom goals
                if (!isPredefined)
                // Use a constrained IconButton to keep the tap area small
                  IconButton(
                    splashRadius: 18,
                    iconSize: 18,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    icon: const Icon(Icons.close, color: AppColours.textSecondary),
                    onPressed: () => _deleteAndSaveGoal(goal),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// A dedicated widget for the editing view.
  Widget _buildEditView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100), // Padding for the bottom save button
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
    );
  }

  /// A helper widget for the "Add Goal" button.
  Widget _buildAddGoalButton(VoidCallback onPressed) {
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

  /// A helper widget for the bottom "Save Goals" button.
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: ElevatedButton(
        onPressed: _saveGoals,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColours.card,
          foregroundColor: AppColours.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Save Goals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}