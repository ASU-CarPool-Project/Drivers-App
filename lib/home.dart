import 'package:asu_carpool_driver/TripsPage.dart';
import 'package:asu_carpool_driver/AddRide.dart';
import 'package:asu_carpool_driver/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'about.dart';

String username = "";
String phone = "";

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  /////////////////////////////////////////////////////////////////////////////

  Future<void> _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
      await FirebaseFirestore.instance.collection('users_driver')
          .doc(user.uid)
          .get();

      setState(() {
        _user = user;
        _userData = userData.data();
        username = _userData!['firstName'] + " " + _userData!['lastName'];
        phone = _userData!['phone'];
      });
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          leading: iconBack(context),
          title: textPageTitle("Home"),
          centerTitle: true,
        ),
        endDrawer: Drawer(
          child: Container(
            color: Colors.white70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  accountName: _userData != null
                      ? Text("${_userData!['firstName'] + " " +
                      _userData!['lastName']}")
                      : const Text("Jake The Dog"),
                  accountEmail: _userData != null
                      ? Text("${_userData!['email']}")
                      : const Text("jake@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.white70,
                      backgroundImage: AssetImage('assets/logos/fin.png'),
                    ),
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.indigo
                  ),
                ),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: const Icon(Icons.face,
                      color: Colors.indigo),
                  title: const Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.indigo),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => profile()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: const Icon(Icons.question_mark,
                      color: Colors.indigo),
                  title: const Text(
                    "About",
                    style: TextStyle(
                        color: Colors.indigo),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => about()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: const Icon(Icons.list_alt_rounded,
                      color: Colors.indigo),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(
                        color: Colors.indigo),
                  ),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => Requests()),
                    // );
                  },
                ),

              ],
            ),
          ),
        ),
        body: Container(
          // color: Colors.blue,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const ListTile(
                          tileColor: Colors.indigo,
                          title: Text(
                            "Add Trip",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddRide()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const ListTile(
                          tileColor: Colors.indigo,
                          title: Text(
                            "Show Trips",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.receipt,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripsPage()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        child: const ListTile(
                          tileColor: Colors.indigo,
                          title: Text(
                            "Requests",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Icon(
                            Icons.add_task ,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => AddRide()),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
