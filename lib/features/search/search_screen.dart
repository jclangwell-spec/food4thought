import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/top_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: 'Search'),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 96),
        children: const [
          SectionCard(
            child: ComingSoon(
              icon: Icons.search,
              message:
                  'Find restaurants by name, city or area, and filter by '
                  'cuisine, vibe, rating and opening date.',
              when: 'Coming in phase 2.',
            ),
          ),
        ],
      ),
    );
  }
}
