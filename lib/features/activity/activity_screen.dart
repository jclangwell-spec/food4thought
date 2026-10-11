import 'package:flutter/material.dart';

import '../../widgets/coming_soon.dart';
import '../../widgets/top_bar.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: 'Activity'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ComingSoon(
            icon: Icons.bolt,
            message:
                'The latest reviews from people you follow will show '
                'up here, newest first.',
            when: 'Coming in phase 2, along with following friends.',
          ),
        ],
      ),
    );
  }
}
