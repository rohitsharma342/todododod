import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/app_routes.dart';
import '../controllers/notification_controller.dart';
import '../controllers/task_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/custom_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationController, TaskController>(
      builder: (context, notificationController, taskController, child) {
        final notifications = notificationController.notifications;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              if (notifications.isNotEmpty)
                TextButton(
                  onPressed: notificationController.markAllAsRead,
                  child: Text(
                    'Mark all read',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.pastelBlue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.notifications_off_outlined,
                            size: 50,
                            color: AppTheme.primaryColor,
                          ),
                        )
                            .animate()
                            .fadeIn()
                            .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
                        const SizedBox(height: 24),
                        Text(
                          'No notifications',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ).animate().fadeIn(delay: 100.ms),
                        const SizedBox(height: 8),
                        Text(
                          'You\'re all caught up!',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textLight,
                              ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Back to Dashboard',
                          isFullWidth: false,
                          width: 200,
                          onPressed: () => Navigator.of(context).pop(),
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: notificationController.loadNotifications,
                    color: AppTheme.primaryColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationTile(
                          notification: notification,
                          index: index,
                          onTap: () {
                            notificationController.markAsRead(notification.id);
                            if (notification.taskId != null) {
                              final task = taskController.getTaskById(notification.taskId!);
                              if (task != null) {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.editTask,
                                  arguments: task,
                                );
                              }
                            }
                          },
                          onDismiss: () {
                            notificationController.clearNotification(notification.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Notification dismissed'),
                                backgroundColor: AppTheme.textPrimary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}