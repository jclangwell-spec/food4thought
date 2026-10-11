import 'package:flutter/material.dart';

import '../features/activity/activity_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/review/write_review_sheet.dart';
import '../features/search/search_screen.dart';
import '../theme/app_colors.dart';

/// Bottom bar like Letterboxd's: Home, Search, + (write a review),
/// Activity, Profile. Each tab keeps its scroll position when you switch.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.uid});

  /// The signed-in person.
  final String uid;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          const HomeScreen(),
          const SearchScreen(),
          const ActivityScreen(),
          ProfileScreen(uid: widget.uid),
        ],
      ),
      bottomNavigationBar: _TabBar(
        selected: _tab,
        onSelected: (i) => setState(() => _tab = i),
        onWrite: () => showWriteReviewSheet(context),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selected,
    required this.onSelected,
    required this.onWrite,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final VoidCallback onWrite;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    Widget tab(int index, IconData icon, IconData selectedIcon, String label) {
      final on = index == selected;
      return Expanded(
        child: Semantics(
          selected: on,
          button: true,
          label: label,
          excludeSemantics: true,
          child: InkResponse(
            key: ValueKey('tab-${label.toLowerCase()}'),
            onTap: () => onSelected(index),
            child: SizedBox(
              height: 56,
              child: Icon(
                on ? selectedIcon : icon,
                size: 28,
                color: on ? c.accentText : c.inkSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: c.field,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            tab(0, Icons.home_outlined, Icons.home, 'Home'),
            tab(1, Icons.search, Icons.search, 'Search'),
            Expanded(
              child: Tooltip(
                message: 'Write a review',
                child: InkResponse(
                  onTap: onWrite,
                  child: SizedBox(
                    height: 56,
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 34,
                      color: c.accent,
                    ),
                  ),
                ),
              ),
            ),
            tab(2, Icons.bolt_outlined, Icons.bolt, 'Activity'),
            tab(3, Icons.person_outline, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }
}
