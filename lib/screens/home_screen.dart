import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/database/database_provider.dart';
import 'package:to_do_app/models/reminder.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/utils/helper_methods.dart';
import 'package:to_do_app/widgets/home_body.dart';
import 'dart:developer' as developer;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Icon icon = const Icon(Icons.search);
  Widget customWidget = const Text("To Do");
  final TextEditingController searchController = TextEditingController();

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
        key: _scaffoldKey,
        // TODO got work to do here
        body: Center(
          child: TextButton(
            onPressed: () async {
              List<Reminder> remList =
                  await DatabaseProvider.instance.readAll();
              developer.log(remList.length.toString());
              developer.log(remList.map((e) => e.toString()).toString());
            },
            child: const Text("Get all data"),
          ),
        ),
        // DataHandler().getToDos().isEmpty
        //     ? const Center(child: Text("Nothing to show"))
        //     : const HomeBody(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: customWidget,
          actions: [
            IconButton(
              onPressed: () async {
                String? retVal = await Auth(auth: _auth).signOut();
                if (retVal == "Success") {
                  // TODO fix the _castError exception
                  Navigator.pushNamedAndRemoveUntil(
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
            Navigator.pushNamed(context, "/addToDo");
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
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
                  setState(() {
                    if (icon.icon == Icons.search) {
                      icon = const Icon(Icons.cancel);
                      customWidget = ListTile(
                        leading: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        title: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search..",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(
                            Icons.clear_all,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      icon = const Icon(Icons.search);
                      customWidget = const Text("To Do");
                    }
                  });
                },
                icon: icon,
              ),
            ],
          ),
        ),
        drawer: const Drawer(),
      ),
    );
  }
}
