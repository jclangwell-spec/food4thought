import 'package:flutter/material.dart';

import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/review/write_review_sheet.dart';
import '../features/search/search_screen.dart';

/// Bottom tabs (Home, Search, Profile) plus the + button that writes a
/// review from any tab. Each tab keeps its scroll position when you switch.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  static const _screens = [HomeScreen(), SearchScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Write a review',
        onPressed: () => showWriteReviewSheet(context),
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerTheme.color!),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
