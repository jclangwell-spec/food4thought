import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/list_rows.dart';
import '../../widgets/top_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const _browseBy = [
    'Opening date',
    'Cuisine',
    'Vibe',
    'City and area',
    'Most popular',
    'Highest rated',
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: TopBar(
        title: 'Search',
        bottom: TextField(
          readOnly: true,
          onTap: () => showComingSoon(context, 'Search is coming in phase 2.'),
          style: TextStyle(color: c.ink, fontSize: 17),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: c.field,
            hintText: 'Find restaurants, cuisines, members…',
            hintStyle: TextStyle(color: c.inkSecondary, fontSize: 17),
            prefixIcon: Icon(Icons.search, color: c.inkSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeading('Browse by'),
          for (final label in _browseBy)
            ChevronRow(
              label: label,
              onTap: () => showComingSoon(
                context,
                'Browsing by ${label.toLowerCase()} is coming in phase 2.',
              ),
            ),
        ],
      ),
    );
  }
}
