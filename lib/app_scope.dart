import 'package:flutter/widgets.dart';

import 'data/auth_repository.dart';
import 'data/profile_repository.dart';

/// Hands the data repositories to every screen below it.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.auth,
    required this.profiles,
    required super.child,
  });

  final AuthRepository auth;
  final ProfileRepository profiles;

  static AppScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      auth != oldWidget.auth || profiles != oldWidget.profiles;
}
