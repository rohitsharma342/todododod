import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/add_edit_task_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../screens/notifications_screen.dart';
import '../models/task_model.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String profile = '/profile';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildPageRoute(const SplashScreen(), settings);
      case login:
        return _buildPageRoute(const LoginScreen(), settings);
      case signup:
        return _buildPageRoute(const SignupScreen(), settings);
      case dashboard:
        return _buildPageRoute(const DashboardScreen(), settings);
      case addTask:
        return _buildPageRoute(const AddEditTaskScreen(), settings);
      case editTask:
        final task = settings.arguments as TaskModel;
        return _buildPageRoute(AddEditTaskScreen(task: task), settings);
      case profile:
        return _buildPageRoute(const ProfileSettingsScreen(), settings);
      case notifications:
        return _buildPageRoute(const NotificationsScreen(), settings);
      default:
        return _buildPageRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}