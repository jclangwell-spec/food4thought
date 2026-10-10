import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/section_card.dart';
import '../../widgets/top_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TopBar(title: 'Profile'),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 96),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: c.line,
                      child: Icon(Icons.person, color: c.inkSecondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You're not signed in yet",
                        style: text.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(
                      child: _Stat(label: 'Reviews', value: '–'),
                    ),
                    Expanded(
                      child: _Stat(label: 'Avg rating', value: '–'),
                    ),
                    Expanded(
                      child: _Stat(label: 'Cuisines', value: '–'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const ComingSoon(
                  icon: Icons.login,
                  message:
                      'Sign in with Google to see your reviews, '
                      'favourites and wishlist.',
                  when: 'Coming in the next step.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$label: ${value == '–' ? 'none yet' : value}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.labelSmall),
          Text(
            value,
            style: text.displaySmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
