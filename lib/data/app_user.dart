/// The signed-in person, as the sign-in provider describes them.
class AppUser {
  const AppUser({required this.uid, this.displayName, this.email});

  final String uid;
  final String? displayName;
  final String? email;
}
