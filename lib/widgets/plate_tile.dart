import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// An empty square cell holding a faint plate outline. Stands in for a
/// restaurant until there is real data to show.
class EmptyPlateTile extends StatelessWidget {
  const EmptyPlateTile({super.key, this.child});

  /// Shown in the middle of the plate, e.g. a + icon.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: c.line),
        ),
        child: FractionallySizedBox(
          widthFactor: 0.72,
          heightFactor: 0.72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.field, width: 3),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
