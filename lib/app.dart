import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';

class TododododApp extends StatelessWidget {
  const TododododApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todododod',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}