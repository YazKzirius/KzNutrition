import 'package:flutter/material.dart';
import 'package:kznutrition/utils/AppColours.dart';

class GoalChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDelete; // NEW: Add an optional delete callback

  const GoalChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onDelete, // NEW: Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColours.card : AppColours.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use Expanded to allow text to wrap and prevent overflow
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColours.textPrimary : AppColours.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // NEW: If onDelete is provided, show a delete icon
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  color: isSelected ? AppColours.textPrimary.withOpacity(0.7) : AppColours.textSecondary,
                  onPressed: onDelete,
                  splashRadius: 20,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                )
            ],
          ),
        ),
      ),
    );
  }
}