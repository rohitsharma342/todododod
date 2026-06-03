import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/app_theme.dart';
import '../config/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/notification_controller.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/category_chip.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthController, TaskController, NotificationController>(
      builder: (context, authController, taskController, notificationController, child) {
        final user = authController.currentUser;
        final upcomingTasks = taskController.upcomingTasks;

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => taskController.loadTasks(),
              color: AppTheme.primaryColor,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello, ${user?.name.split(' ').first ?? 'User'}!',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    )
                                        .animate()
                                        .fadeIn(duration: 400.ms)
                                        .slideX(begin: -0.1, end: 0),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    )
                                        .animate()
                                        .fadeIn(delay: 100.ms, duration: 400.ms)
                                        .slideX(begin: -0.1, end: 0),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(AppRoutes.notifications);
                                        },
                                        icon: const Icon(
                                          Icons.notifications_outlined,
                                          size: 28,
                                        ),
                                      ),
                                      if (notificationController.unreadCount > 0)
                                        Positioned(
                                          right: 8,
                                          top: 8,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: const BoxDecoration(
                                              color: AppTheme.errorColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                notificationController.unreadCount > 9
                                                    ? '9+'
                                                    : notificationController.unreadCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(AppRoutes.profile);
                                    },
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: AppTheme.primaryColor.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: user?.avatarUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: user!.avatarUrl!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Container(
                                                  color: AppTheme.pastelBlue,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: AppTheme.primaryColor,
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: AppTheme.pastelBlue,
                                                  child: const Icon(
                                                    Icons.person,
                                                    color: AppTheme.primaryColor,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: AppTheme.pastelBlue,
                                                child: const Icon(
                                                  Icons.person,
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: taskController.setSearchQuery,
                              decoration: InputDecoration(
                                hintText: 'Search tasks...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppTheme.textLight,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: AppTheme.textLight,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          taskController.setSearchQuery('');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 400.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatCard(
                                context,
                                'Total',
                                taskController.totalTasksCount.toString(),
                                Icons.list_alt_rounded,
                                AppTheme.pastelBlue,
                              ),
                              const SizedBox(width: 12),
                              _buildStatCard(
                                context,
                                'Pending',
                                taskController.pendingTasksCount.toString(),
                                Icons.pending_actions_rounded,
                                AppTheme.pastelYellow,
                              ),
                              const SizedBox(width: 12),
                              _buildStatCard(
                                context,
                                'Done',
                                taskController.completedTasksCount.toString(),
                                Icons.check_circle_outline_rounded,
                                AppTheme.pastelGreen,
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 400.ms)
                              .slideY(begin: 0.1, end: 0),
                          if (upcomingTasks.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.secondaryColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.upcoming_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Upcoming Tasks',
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              '${upcomingTasks.length} tasks in the next 7 days',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Colors.white.withOpacity(0.8),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ...upcomingTasks.take(3).map((task) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                task.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (task.dueDate != null)
                                              Text(
                                                DateFormat('MMM d').format(task.dueDate!),
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 500.ms, duration: 400.ms)
                                .slideY(begin: 0.1, end: 0),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            'Categories',
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                              .animate()
                              .fadeIn(delay: 600.ms, duration: 400.ms),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          CategoryChip(
                            category: null,
                            isSelected: taskController.selectedCategory == null,
                            onTap: () => taskController.setSelectedCategory(null),
                            showAll: true,
                          ),
                          const SizedBox(width: 8),
                          ...TaskCategory.values.map((category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CategoryChip(
                                  category: category,
                                  isSelected: taskController.selectedCategory == category,
                                  onTap: () => taskController.setSelectedCategory(category),
                                ),
                              )),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Tasks',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${taskController.tasks.length} tasks',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
                  ),
                  if (taskController.isLoading)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else if (taskController.tasks.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppTheme.pastelBlue,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  size: 50,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No tasks yet',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to create your first task',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textLight,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 900.ms).scale(begin: const Offset(0.9, 0.9)),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final task = taskController.tasks[index];
                            return TaskCard(
                              task: task,
                              index: index,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.editTask,
                                  arguments: task,
                                );
                              },
                              onCheckChanged: (value) {
                                taskController.toggleTaskCompletion(task.id);
                              },
                              onDelete: () {
                                taskController.deleteTask(task.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Task deleted'),
                                    backgroundColor: AppTheme.textPrimary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      textColor: AppTheme.accentColor,
                                      onPressed: () {
                                        taskController.addTask(task);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: taskController.tasks.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.addTask);
            },
            child: const Icon(Icons.add, size: 28),
          )
              .animate()
              .fadeIn(delay: 1000.ms)
              .scale(begin: const Offset(0.5, 0.5), curve: Curves.elasticOut),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}