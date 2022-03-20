import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_app/models/database/database_provider.dart';
import 'package:to_do_app/models/reminder.dart';
import 'package:to_do_app/screens/search_screen.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/widgets/home_body.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/widgets/loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Reminder> searchList;

  showErr() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Error occured!")));
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 3);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            fontSize: 16,
            backgroundColor: Colors.grey[400],
          );
          return false;
        } else {
          Fluttertoast.cancel();
          DatabaseProvider.instance.closeDB();
          return true;
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode _currentFocus = FocusScope.of(context);
          if (!_currentFocus.hasPrimaryFocus) {
            _currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                searchList = snapshot.data as List<Reminder>;
                return HomeBody(remList: snapshot.data as List<Reminder>);
              }
              return const Center(
                child: Loading(),
              );
            },
            future: DatabaseProvider.instance.readAll(),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Reminder"),
            actions: [
              IconButton(
                onPressed: () async {
                  String? retVal = await Auth(auth: _auth).signOut();
                  if (retVal == "Success") {
                    // TODO fix the _castError exception
                    await Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error occured!"),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/addReminder");
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchScreen(searchList: searchList)));
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
