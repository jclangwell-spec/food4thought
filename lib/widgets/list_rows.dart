import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A full-width row with a label, an optional count and a chevron, like
/// Letterboxd's "Films 940 ›". Rows are separated by hairlines.
class ChevronRow extends StatelessWidget {
  const ChevronRow({
    super.key,
    required this.label,
    this.count,
    this.onTap,
    this.showChevron = true,
  });

  final String label;
  final String? count;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: onTap != null,
      label: count == null ? label : '$label, $count',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.line)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 19, color: c.ink),
                ),
              ),
              if (count != null)
                Text(
                  count!,
                  style: TextStyle(
                    fontSize: 19,
                    color: c.inkSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              if (showChevron) ...[
                const SizedBox(width: 6),
                Icon(Icons.chevron_right, color: c.inkSecondary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A heading above a group of rows or tiles, e.g. "Browse by".
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.text, {super.key, this.small = false});

  final String text;

  /// Small spaced capitals ("FAVOURITES") instead of a bold heading.
  final bool small;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Semantics(
        header: true,
        child: Text(
          small ? text.toUpperCase() : text,
          style: small ? t.titleSmall : t.titleLarge,
        ),
      ),
    );
  }
}

/// Shows a short "coming soon" note at the bottom of the screen.
void showComingSoon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(what),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
}
