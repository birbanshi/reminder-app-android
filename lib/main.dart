import 'package:flutter/material.dart';
import 'package:to_do_app/routes/app_routes.dart';
import 'package:to_do_app/screens/add_todo.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/landing_screen.dart';
import 'package:to_do_app/screens/login.dart';
import 'package:to_do_app/screens/sign_up.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        MyAppRoutes.landingScreen: (context) => LandingScreen(),
        MyAppRoutes.homeScreen: (context) => const HomeScreen(),
        MyAppRoutes.loginScreen: (context) => const LogIn(),
        MyAppRoutes.signUpScreen: (context) => const SignUp(),
        MyAppRoutes.addToDo: (context) => const AddToDo(),
      },
    );
  }
}
