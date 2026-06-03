import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_overlay.dart';
import '../utils/validators.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskCategory _selectedCategory;
  late TaskPriority _selectedPriority;
  DateTime? _selectedDueDate;
  bool _isCompleted = false;
  bool _isSaving = false;

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedCategory = widget.task?.category ?? TaskCategory.personal;
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedDueDate = widget.task?.dueDate;
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppTheme.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: AppTheme.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );

      setState(() {
        _selectedDueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time?.hour ?? 12,
          time?.minute ?? 0,
        );
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      final taskController = context.read<TaskController>();

      final task = TaskModel(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        isCompleted: _isCompleted,
        createdAt: widget.task?.createdAt,
      );

      bool success;
      if (isEditing) {
        success = await taskController.updateTask(task);
      } else {
        success = await taskController.addTask(task);
      }

      setState(() => _isSaving = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Task updated successfully!' : 'Task created successfully!'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isSaving,
      message: isEditing ? 'Updating task...' : 'Creating task...',
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Task' : 'New Task'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (isEditing)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text('Delete Task'),
                      content: const Text('Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<TaskController>().deleteTask(widget.task!.id);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Task Title',
                    hint: 'What needs to be done?',
                    controller: _titleController,
                    validator: Validators.validateTaskTitle,
                    prefixIcon: const Icon(Icons.title),
                    autofocus: !isEditing,
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Description',
                    hint: 'Add more details about this task...',
                    controller: _descriptionController,
                    maxLines: 4,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.description_outlined),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TaskCategory.values.map((category) {
                      final isSelected = category == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : _getCategoryColor(category),
                            borderRadius: BorderRadius.circular(12),
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
                                _getCategoryIcon(category),
                                size: 18,
                                color: isSelected ? Colors.white : AppTheme.textPrimary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                TaskModel.categoryToString(category),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 24),
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 12),
                  Row(
                    children: TaskPriority.values.map((priority) {
                      final isSelected = priority == _selectedPriority;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPriority = priority),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                              right: priority != TaskPriority.high ? 8 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _getPriorityColor(priority)
                                  : _getPriorityColor(priority).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? _getPriorityColor(priority)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                TaskModel.priorityToString(priority),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : _getPriorityColor(priority),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 24),
                  Text(
                    'Due Date',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _selectDueDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.textLight.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: _selectedDueDate != null
                                ? AppTheme.primaryColor
                                : AppTheme.textLight,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDueDate != null
                                  ? DateFormat('EEEE, MMMM d, yyyy \u2022 h:mm a')
                                      .format(_selectedDueDate!)
                                  : 'Select due date',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: _selectedDueDate != null
                                        ? AppTheme.textPrimary
                                        : AppTheme.textLight,
                                  ),
                            ),
                          ),
                          if (_selectedDueDate != null)
                            IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: AppTheme.textLight,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _selectedDueDate = null),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                  if (isEditing) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.textLight.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isCompleted
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: _isCompleted
                                    ? AppTheme.successColor
                                    : AppTheme.textLight,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Mark as completed',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Switch(
                            value: _isCompleted,
                            onChanged: (value) => setState(() => _isCompleted = value),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 900.ms),
                  ],
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          type: ButtonType.outline,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: isEditing ? 'Update' : 'Create',
                          onPressed: _handleSave,
                          isLoading: _isSaving,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(TaskCategory category) {
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
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
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
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppTheme.successColor;
      case TaskPriority.medium:
        return AppTheme.warningColor;
      case TaskPriority.high:
        return AppTheme.errorColor;
    }
  }
}