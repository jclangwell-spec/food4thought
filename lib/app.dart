import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data/auth_repository.dart';
import 'data/profile_repository.dart';
import 'features/auth/auth_gate.dart';
import 'theme/app_theme.dart';

class FoodForThoughtApp extends StatelessWidget {
  const FoodForThoughtApp({
    super.key,
    required this.auth,
    required this.profiles,
  });

  final AuthRepository auth;
  final ProfileRepository profiles;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      auth: auth,
      profiles: profiles,
      child: MaterialApp(
        title: 'Food for Thought',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const AuthGate(),
      ),
    );
  }
}
