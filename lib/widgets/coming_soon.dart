import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A placeholder shown where a feature hasn't been built yet.
class ComingSoon extends StatelessWidget {
  const ComingSoon({
    super.key,
    required this.icon,
    required this.message,
    required this.when,
  });

  final IconData icon;
  final String message;
  final String when;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: c.inkSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: text.bodyMedium),
                const SizedBox(height: 4),
                Text(when, style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
