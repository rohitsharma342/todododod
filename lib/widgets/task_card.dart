import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckChanged;
  final VoidCallback? onDelete;
  final int index;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onCheckChanged,
    this.onDelete,
    this.index = 0,
  });

  Color _getCategoryColor() {
    switch (task.category) {
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
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return AppTheme.successColor;
      case TaskPriority.medium:
        return AppTheme.warningColor;
      case TaskPriority.high:
        return AppTheme.errorColor;
    }
  }

  IconData _getCategoryIcon() {
    switch (task.category) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(
                  color: _getCategoryColor(),
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: onCheckChanged,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? AppTheme.textLight
                                        : AppTheme.textPrimary,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getPriorityColor().withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              TaskModel.priorityToString(task.priority),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getPriorityColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textLight,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(),
                                  size: 14,
                                  color: AppTheme.textPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  TaskModel.categoryToString(task.category),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (task.dueDate != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: isOverdue
                                      ? AppTheme.errorColor
                                      : AppTheme.textLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM d, y').format(task.dueDate!),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isOverdue
                                            ? AppTheme.errorColor
                                            : AppTheme.textLight,
                                        fontWeight: isOverdue
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: index * 50),
        )
        .slideX(
          begin: 0.1,
          end: 0,
          duration: 300.ms,
          delay: Duration(milliseconds: index * 50),
          curve: Curves.easeOutCubic,
        );
  }
}