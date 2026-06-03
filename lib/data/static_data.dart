import '../models/task_model.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';

class StaticData {
  static final UserModel demoUser = UserModel(
    id: '1',
    name: 'Alex Johnson',
    email: 'demo@todododod.com',
    avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
    notificationsEnabled: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  static final List<TaskModel> sampleTasks = [
    TaskModel(
      id: '1',
      title: 'Complete Flutter project',
      description: 'Finish the todododod app with all screens and features.',
      category: TaskCategory.work,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.high,
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: '2',
      title: 'Morning yoga session',
      description: '30 minutes of yoga to start the day fresh.',
      category: TaskCategory.health,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.medium,
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TaskModel(
      id: '3',
      title: 'Buy groceries',
      description: 'Milk, bread, eggs, vegetables, and fruits.',
      category: TaskCategory.shopping,
      dueDate: DateTime.now().add(const Duration(hours: 5)),
      priority: TaskPriority.high,
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    TaskModel(
      id: '4',
      title: 'Read a book chapter',
      description: 'Continue reading "Atomic Habits" - Chapter 5.',
      category: TaskCategory.personal,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.low,
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    TaskModel(
      id: '5',
      title: 'Online course lecture',
      description: 'Watch the next lecture on Advanced Flutter Development.',
      category: TaskCategory.education,
      dueDate: DateTime.now().add(const Duration(days: 4)),
      priority: TaskPriority.medium,
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TaskModel(
      id: '6',
      title: 'Team meeting',
      description: 'Weekly sync with the development team.',
      category: TaskCategory.work,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    TaskModel(
      id: '7',
      title: 'Pay electricity bill',
      description: 'Monthly utility payment due.',
      category: TaskCategory.other,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      priority: TaskPriority.medium,
      isCompleted: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TaskModel(
      id: '8',
      title: 'Dentist appointment',
      description: 'Regular dental checkup at 3 PM.',
      category: TaskCategory.health,
      dueDate: DateTime.now().add(const Duration(days: 6)),
      priority: TaskPriority.high,
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
  ];

  static final List<NotificationModel> sampleNotifications = [
    NotificationModel(
      id: '1',
      title: 'Task Due Soon',
      message: 'Complete Flutter project is due in 2 days.',
      taskId: '1',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: 'Reminder',
      message: 'Don\'t forget to buy groceries today!',
      taskId: '3',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      title: 'Task Completed',
      message: 'Great job! You completed "Team meeting".',
      taskId: '6',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      title: 'Weekly Summary',
      message: 'You completed 5 tasks this week. Keep it up!',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: 'New Feature',
      message: 'Check out the new category filters on your dashboard!',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];
}