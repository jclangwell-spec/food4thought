/// A person's public profile, stored at `users/{uid}`.
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.handle,
    this.bio = '',
    this.reviewCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
  });

  final String uid;
  final String displayName;
  final String handle;
  final String bio;
  final int reviewCount;
  final int followerCount;
  final int followingCount;

  /// Up to two letters for the avatar, e.g. "JL" for Josh Langwell.
  String get initials {
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    String firstLetter(String word) => String.fromCharCode(word.runes.first);
    final last = parts.length > 1 ? firstLetter(parts.last) : '';
    return (firstLetter(parts.first) + last).toUpperCase();
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] as String? ?? '',
      handle: data['handle'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      followerCount: (data['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (data['followingCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Turns a display name into a handle: "Josh Langwell" -> "josh_langwell".
/// Keeps only a–z, 0–9 and underscores, at most 20 characters.
String handleFromName(String name) {
  final cleaned = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  final cut = cleaned.length > 20 ? cleaned.substring(0, 20) : cleaned;
  final trimmed = cut.replaceAll(RegExp(r'_+$'), '');
  return trimmed.isEmpty ? 'member' : trimmed;
}
