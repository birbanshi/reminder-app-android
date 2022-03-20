import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/routes/app_routes.dart';
import 'package:to_do_app/screens/add_reminder.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/landing_screen.dart';
import 'package:to_do_app/screens/login.dart';
import 'package:to_do_app/screens/search_screen.dart';
import 'package:to_do_app/screens/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // await Hive.openBox<ToDo>("data");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        MyAppRoutes.landingScreen: (context) => const LandingScreen(),
        MyAppRoutes.homeScreen: (context) => const HomeScreen(),
        MyAppRoutes.loginScreen: (context) => const LogIn(),
        MyAppRoutes.signUpScreen: (context) => const SignUp(),
        MyAppRoutes.addReminder: (context) => const AddReminder(),
      },
    );
  }
}
