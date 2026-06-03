import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../config/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_overlay.dart';
import '../utils/validators.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _notificationsEnabled = true;
  bool _isSaving = false;
  bool _showPasswordFields = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _notificationsEnabled = user?.notificationsEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      final authController = context.read<AuthController>();

      if (_showPasswordFields &&
          _currentPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty) {
        final passwordChanged = await authController.changePassword(
          _currentPasswordController.text,
          _newPasswordController.text,
        );

        if (!passwordChanged) {
          setState(() => _isSaving = false);
          return;
        }
      }

      final success = await authController.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        notificationsEnabled: _notificationsEnabled,
      );

      setState(() => _isSaving = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthController>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final user = authController.currentUser;

        return LoadingOverlay(
          isLoading: _isSaving,
          message: 'Saving changes...',
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Profile & Settings'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(27),
                                child: user?.avatarUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: user!.avatarUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: AppTheme.pastelBlue,
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: AppTheme.pastelBlue,
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: AppTheme.pastelBlue,
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms).scale(
                            begin: const Offset(0.8, 0.8),
                            curve: Curves.easeOutBack,
                          ),
                      const SizedBox(height: 32),
                      Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: _nameController,
                        validator: Validators.validateName,
                        prefixIcon: const Icon(Icons.person_outlined),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => setState(() => _showPasswordFields = !_showPasswordFields),
                        child: Row(
                          children: [
                            Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _showPasswordFields
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      if (_showPasswordFields) ...[
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Current Password',
                          hint: 'Enter current password',
                          controller: _currentPasswordController,
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outlined),
                        ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'New Password',
                          hint: 'Enter new password',
                          controller: _newPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (_currentPasswordController.text.isNotEmpty &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter a new password';
                            }
                            if (value != null && value.isNotEmpty && value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(Icons.lock_outlined),
                        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                      ],
                      if (authController.errorMessage != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.errorColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppTheme.errorColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  authController.errorMessage!,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.errorColor,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn().shake(),
                      ],
                      const SizedBox(height: 32),
                      Text(
                        'Preferences',
                        style: Theme.of(context).textTheme.titleLarge,
                      ).animate().fadeIn(delay: 500.ms),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppTheme.pastelYellow,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.notifications_outlined,
                                        color: AppTheme.warningColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notifications',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        Text(
                                          'Receive task reminders',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppTheme.textLight,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: _notificationsEnabled,
                                  onChanged: (value) =>
                                      setState(() => _notificationsEnabled = value),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Save Changes',
                        onPressed: _handleSave,
                        isLoading: _isSaving,
                      ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Logout',
                        type: ButtonType.outline,
                        icon: const Icon(Icons.logout, size: 20),
                        onPressed: _handleLogout,
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'App Version 1.0.0',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textLight,
                              ),
                        ),
                      ).animate().fadeIn(delay: 900.ms),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}