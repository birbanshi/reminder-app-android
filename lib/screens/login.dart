import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/utils/helper.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode _currentFocus = FocusScope.of(context);
        if (!_currentFocus.hasPrimaryFocus) {
          _currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      labelText: "Email",
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isVisible = true;
                          });
                          // FutureBuilder(
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.done) {
                          //       setState(() {
                          //         isVisible = false;
                          //       });
                          //       if (snapshot.data == "Success") {
                          //         Navigator.pushNamedAndRemoveUntil(
                          //             context, "/home", (route) => false);
                          //       } else {
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(SnackBar(content: Text(snapshot.data.toString())));
                          //       }
                          //     }
                          //   },
                          //   future: Auth(auth: _auth).signIn(
                          //       email: _emailController.text.trim(),
                          //       password: _passwordController.text.trim()),
                          // );

                          final String? retVal = await Auth(auth: _auth).signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());
                          if (retVal == "Success") {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/home", (route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Welcome back"),
                              ),
                            );
                          } else {
                            setState(() {
                              isVisible = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(retVal!),
                              ),
                            );
                          }
                        },
                        child: const Text("Log In"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signUp");
                        },
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            showLoading(isVisible: isVisible),
          ],
        ),
      ),
    );
  }
}
