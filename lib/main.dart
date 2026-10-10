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
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(
    FoodForThoughtApp(
      auth: FirebaseAuthRepository(FirebaseAuth.instance),
      profiles: FirestoreProfileRepository(FirebaseFirestore.instance),
    ),
  );
}
