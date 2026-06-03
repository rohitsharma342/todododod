import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/task_model.dart';

class CategoryChip extends StatelessWidget {
  final TaskCategory? category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showAll;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.showAll = false,
  });

  Color _getCategoryColor() {
    if (showAll) return AppTheme.primaryColor;
    switch (category) {
      case TaskCategory.personal:
        return AppTheme.pastelPink;
      case TaskCategory.work:
        return AppTheme.pastelBlue;
      case TaskCategory.shopping:
        return AppTheme.pastelYellow;
      case TaskCategory.health:
        return AppTheme.pastelGreen;
      case TaskCategory.education:
        return AppTheme.pastelPurple;
      case TaskCategory.other:
        return AppTheme.backgroundColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getCategoryIcon() {
    if (showAll) return Icons.grid_view_rounded;
    switch (category) {
      case TaskCategory.personal:
        return Icons.person_outline;
      case TaskCategory.work:
        return Icons.work_outline;
      case TaskCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TaskCategory.health:
        return Icons.favorite_outline;
      case TaskCategory.education:
        return Icons.school_outlined;
      case TaskCategory.other:
        return Icons.more_horiz;
      default:
        return Icons.grid_view_rounded;
    }
  }

  String _getCategoryName() {
    if (showAll) return 'All';
    return category != null ? TaskModel.categoryToString(category!) : 'All';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : _getCategoryColor(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getCategoryIcon(),
              size: 18,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              _getCategoryName(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}