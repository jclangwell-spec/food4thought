import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';
import '../../widgets/top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 96),
        children: const [
          SectionCard(
            title: 'Popular this week',
            child: ComingSoon(
              icon: Icons.leaderboard_outlined,
              message:
                  "The places reviewed most this week will rank here, 1 to 12.",
              when: 'Coming in phase 2, once other people are reviewing.',
            ),
          ),
        ],
      ),
    );
  }
}
