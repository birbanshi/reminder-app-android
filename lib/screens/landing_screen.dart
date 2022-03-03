import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';
import '../widgets/root.dart';
import '../widgets/something_went_wrong.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SomeThingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const Root();
          }
          return const Loading();
        });
  }
}
