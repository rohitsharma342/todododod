import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../data/static_data.dart';

class TaskController extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  TaskCategory? _selectedCategory;

  List<TaskModel> get tasks => _filterTasks();
  List<TaskModel> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  TaskCategory? get selectedCategory => _selectedCategory;

  int get completedTasksCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasksCount => _tasks.where((t) => !t.isCompleted).length;
  int get totalTasksCount => _tasks.length;

  List<TaskModel> get upcomingTasks {
    final now = DateTime.now();
    final upcoming = _tasks.where((t) {
      if (t.dueDate == null || t.isCompleted) return false;
      return t.dueDate!.isAfter(now) &&
          t.dueDate!.isBefore(now.add(const Duration(days: 7)));
    }).toList();
    upcoming.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return upcoming.take(5).toList();
  }

  TaskController() {
    loadTasks();
  }

  List<TaskModel> _filterTasks() {
    var filtered = _tasks;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedCategory != null) {
      filtered = filtered.where((task) => task.category == _selectedCategory).toList();
    }

    filtered.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _tasks = List.from(StaticData.sampleTasks);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTask(TaskModel task) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _tasks.add(task);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> updateTask(TaskModel task) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Task not found';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> toggleTaskCompletion(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
    return true;
  }

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}