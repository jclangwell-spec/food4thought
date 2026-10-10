import 'package:flutter/material.dart';

import '../../widgets/section_card.dart';

/// Opened by the + button. The real form arrives in phase 1, step 6.
Future<void> showWriteReviewSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'WRITE A REVIEW',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            const ComingSoon(
              icon: Icons.edit_note,
              message:
                  'Pick a restaurant, give it stars, choose a vibe and '
                  'note your standout dish.',
              when: 'Coming later in phase 1.',
            ),
          ],
        ),
      ),
    ),
  );
}
