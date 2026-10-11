import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Dark bar across the top of each tab with a centred title, like
/// Letterboxd. Home passes no [title] and gets the wordmark. [bottom] holds
/// segmented tabs where a screen has them.
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.title,
    this.leading,
    this.actions = const [],
    this.bottom,
  });

  final String? title;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? bottom;

  static const _bottomHeight = 60.0;

  @override
  Size get preferredSize =>
      Size.fromHeight(56 + (bottom == null ? 0 : _bottomHeight));

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: false,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: c.ink,
              ),
            )
          : const Wordmark(size: 28),
      actions: [...actions, const SizedBox(width: 4)],
      bottom: bottom == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(_bottomHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: bottom,
              ),
            ),
    );
  }
}

/// "FOOD4THOUGHT" with the 4 in the accent colour.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: 'Food for Thought',
      header: true,
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontFamily: AppFonts.condensed,
            fontWeight: FontWeight.w800,
            fontSize: size,
            height: 1,
            letterSpacing: 0.3,
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
    );
  }
}
