import 'package:flutter/material.dart';

import '../../widgets/list_rows.dart';
import '../../widgets/plate_tile.dart';
import '../../widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TopBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeading('Popular this week'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(6, (_) => const EmptyPlateTile()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(
              'The places reviewed most this week will fill this grid once '
              'other people are reviewing. Coming in phase 2.',
              style: text.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
