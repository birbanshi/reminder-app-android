import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../widgets/loading.dart';
import '../widgets/root.dart';
import '../widgets/something_went_wrong.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SomeThingWentWrong();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return const Root();
          }
          return const Loading();
        });
  }
}
