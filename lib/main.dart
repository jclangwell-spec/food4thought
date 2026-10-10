import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'data/auth_repository.dart';
import 'data/profile_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (firebaseOptions.apiKey == 'TODO') {
    // Firebase settings not filled in yet; keep the live link from breaking.
    runApp(const _NotConnectedYet());
    return;
  }
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(
    FoodForThoughtApp(
      auth: FirebaseAuthRepository(FirebaseAuth.instance),
      profiles: FirestoreProfileRepository(FirebaseFirestore.instance),
    ),
  );
}

class _NotConnectedYet extends StatelessWidget {
  const _NotConnectedYet();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Almost ready: sign-in is being connected. Check back soon.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
