import 'package:flutter/material.dart';

import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

class FoodForThoughtApp extends StatelessWidget {
  const FoodForThoughtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food for Thought',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}
