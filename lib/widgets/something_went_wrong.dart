import 'package:flutter/material.dart';

class SomeThingWentWrong extends StatelessWidget {
  const SomeThingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SnackBar(
        content: Text("Something Went Wrong"),
      ),
    );
  }
}
