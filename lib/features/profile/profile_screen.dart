import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/user_profile.dart';
import '../../theme/app_colors.dart';
import '../../widgets/coming_soon.dart';
import '../../widgets/list_rows.dart';
import '../../widgets/plate_tile.dart';
import '../../widgets/segment_tabs.dart';
import '../../widgets/top_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _segments = ['Profile', 'Reviews', 'Wishlist'];
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return StreamBuilder<UserProfile?>(
      stream: scope.profiles.watch(widget.uid),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return Scaffold(
          appBar: TopBar(
            title: profile?.handle ?? '',
            actions: [
              PopupMenuButton<void>(
                tooltip: 'More',
                icon: const Icon(Icons.more_horiz),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () => scope.auth.signOut(),
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ],
            bottom: SegmentTabs(
              labels: _segments,
              selected: _segment,
              onChanged: (i) => setState(() => _segment = i),
            ),
          ),
          body: profile == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: context.colors.accent,
                    semanticsLabel: 'Loading your profile',
                  ),
                )
              : switch (_segment) {
                  0 => _ProfileTab(
                    profile: profile,
                    openSegment: (i) => setState(() => _segment = i),
                  ),
                  1 => const _Placeholder(
                    icon: Icons.rate_review_outlined,
                    message:
                        'Your reviews will be listed here, with '
                        'sorting by date, rating or opening date, and '
                        'filters for cuisine and vibe.',
                  ),
                  _ => const _Placeholder(
                    icon: Icons.bookmark_border,
                    message: 'Places you want to try will be listed here.',
                  ),
                },
        );
      },
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.profile, required this.openSegment});

  final UserProfile profile;
  final ValueChanged<int> openSegment;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 24),
        Center(
          child: ExcludeSemantics(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: c.field,
              child: Text(
                profile.initials,
                style: TextStyle(
                  color: c.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            profile.displayName,
            style: text.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 19,
            ),
          ),
        ),
        if (profile.bio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 6, 32, 0),
            child: Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: c.inkSecondary),
            ),
          ),
        const SizedBox(height: 20),
        Divider(indent: 16, endIndent: 16, color: c.line),
        const SectionHeading('Favourites', small: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: 'Add a favourite',
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => showComingSoon(
                        context,
                        'Picking favourites is coming soon in phase 1.',
                      ),
                      child: EmptyPlateTile(
                        child: Icon(Icons.add, color: c.inkSecondary),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Divider(height: 1, color: c.line),
        ChevronRow(
          label: 'Reviews',
          count: '${profile.reviewCount}',
          onTap: () => openSegment(1),
        ),
        ChevronRow(label: 'Wishlist', count: '0', onTap: () => openSegment(2)),
        ChevronRow(
          label: 'Following',
          count: '${profile.followingCount}',
          onTap: () =>
              showComingSoon(context, 'Following people is coming in phase 2.'),
        ),
        ChevronRow(
          label: 'Followers',
          count: '${profile.followerCount}',
          onTap: () =>
              showComingSoon(context, 'Followers are coming in phase 2.'),
        ),
      ],
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ComingSoon(
          icon: icon,
          message: message,
          when:
              'Coming in the next steps, once your saved places are '
              'imported.',
        ),
      ],
    );
  }
}
