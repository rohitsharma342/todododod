import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/task_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/profile_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: const TododododApp(),
    ),
  );
}