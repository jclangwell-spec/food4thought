import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/user_profile.dart';
import '../../theme/app_colors.dart';
import '../../widgets/section_card.dart';
import '../../widgets/top_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: const TopBar(title: 'Profile'),
      body: StreamBuilder<UserProfile?>(
        stream: scope.profiles.watch(uid),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          if (profile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: context.colors.accent,
                semanticsLabel: 'Loading your profile',
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 96),
            children: [
              SectionCard(child: _Header(profile: profile)),
              const SizedBox(height: 8),
              const SectionCard(
                title: 'Reviews',
                child: ComingSoon(
                  icon: Icons.rate_review_outlined,
                  message:
                      'Your reviews, favourites and wishlist will show '
                      'here once your saved places are imported.',
                  when: 'Coming in the next step.',
                ),
              ),
              const SizedBox(height: 8),
              SectionCard(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => scope.auth.signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                    style: TextButton.styleFrom(
                      foregroundColor: context.colors.accentText,
                      minimumSize: const Size(44, 44),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ExcludeSemantics(
              child: CircleAvatar(
                radius: 28,
                backgroundColor: c.ink,
                child: Text(
                  profile.initials,
                  style: TextStyle(
                    color: c.card,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: text.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text('@${profile.handle}', style: text.bodySmall),
                ],
              ),
            ),
          ],
        ),
        if (profile.bio.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(profile.bio, style: text.bodyMedium),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Stat(label: 'Reviews', value: '${profile.reviewCount}'),
            ),
            Expanded(
              child: _Stat(
                label: 'Following',
                value: '${profile.followingCount}',
              ),
            ),
            Expanded(
              child: _Stat(
                label: 'Followers',
                value: '${profile.followerCount}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.labelSmall),
          Text(
            value,
            style: text.displaySmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
