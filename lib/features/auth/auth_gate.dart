import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/app_user.dart';
import '../../shell/app_shell.dart';
import '../../theme/app_colors.dart';
import 'sign_in_screen.dart';

/// Shows the sign-in screen until someone is signed in, then makes sure
/// they have a profile and opens the app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: AppScope.of(context).auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _Loading();
        }
        final user = snapshot.data;
        if (user == null) return const SignInScreen();
        return _ProfileSetup(key: ValueKey(user.uid), user: user);
      },
    );
  }
}

class _ProfileSetup extends StatefulWidget {
  const _ProfileSetup({super.key, required this.user});

  final AppUser user;

  @override
  State<_ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<_ProfileSetup> {
  late Future<void> _setup;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setup = AppScope.of(context).profiles.ensureProfile(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _setup,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _SetupFailed(
            error: snapshot.error.toString(),
            onRetry: () => setState(() {
              _setup = AppScope.of(context).profiles.ensureProfile(widget.user);
            }),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const _Loading();
        }
        return AppShell(uid: widget.user.uid);
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: context.colors.accent,
          semanticsLabel: 'Loading',
        ),
      ),
    );
  }
}

class _SetupFailed extends StatelessWidget {
  const _SetupFailed({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Couldn't set up your profile", style: text.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Check your connection and try again. If it keeps failing, '
                'send Claude this message: $error',
                style: text.bodyMedium,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  FilledButton(
                    onPressed: onRetry,
                    child: const Text('Try again'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => AppScope.of(context).auth.signOut(),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
