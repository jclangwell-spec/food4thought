import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// White bar across the top of each tab. Home shows the wordmark;
/// other tabs pass a [title].
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key, this.title, this.actions = const []});

  final String? title;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = TextStyle(
      fontFamily: AppFonts.condensed,
      fontWeight: FontWeight.w800,
      fontSize: 24,
      letterSpacing: 0.3,
      color: c.ink,
    );
    return AppBar(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      shape: Border(bottom: BorderSide(color: c.line)),
      title: title != null
          ? Text(title!.toUpperCase(), style: style)
          : Semantics(
              label: 'Food for Thought',
              excludeSemantics: true,
              child: Text.rich(
                TextSpan(
                  style: style,
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
      actions: [...actions, const SizedBox(width: 4)],
    );
  }
}
