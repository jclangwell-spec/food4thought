import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

/// Shown to anyone who isn't signed in.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AppScope.of(context).auth.signInWithGoogle();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _friendlyError(Object e) {
    final text = e.toString();
    if (text.contains('popup-closed-by-user') ||
        text.contains('cancelled-popup-request')) {
      return 'Sign-in was closed before it finished. Tap the button to try again.';
    }
    if (text.contains('popup-blocked')) {
      return 'Safari blocked the sign-in window. Tap the button again, and '
          'allow pop-ups if Safari asks.';
    }
    if (text.contains('network-request-failed')) {
      return "Couldn't reach the internet. Check your connection and try again.";
    }
    return "Sign-in didn't work. Try again, and if it keeps failing, send "
        'Claude this message: $text';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: c.card,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Food for Thought',
                    header: true,
                    excludeSemantics: true,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: AppFonts.condensed,
                          fontWeight: FontWeight.w800,
                          fontSize: 44,
                          height: 1,
                          color: c.ink,
                        ),
                        children: [
                          const TextSpan(text: 'FOOD'),
                          TextSpan(
                            text: '4',
                            style: TextStyle(color: c.accent),
                          ),
                          const TextSpan(text: 'THOUGHT'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Log the places you eat. Rate them, review them, and see '
                    "what's popular with everyone this week.",
                    style: text.bodyLarge?.copyWith(color: c.inkSecondary),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _busy ? null : _signIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: c.accent,
                        foregroundColor: c.onAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: AppFonts.body,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: _busy
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: c.onAccent,
                                semanticsLabel: 'Signing in',
                              ),
                            )
                          : const Text('Continue with Google'),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: text.bodyMedium?.copyWith(color: c.accentText),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
