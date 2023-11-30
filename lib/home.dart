import 'package:asu_carpool_driver/TripsPage.dart';
import 'package:asu_carpool_driver/AddRide.dart';
import 'package:asu_carpool_driver/profile.dart';
import 'package:asu_carpool_driver/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'about.dart';

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
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        _user = user;
        _userData = userData.data();
      });
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Home"),
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
                      ? Text("${_userData!['firstName'] +" "+ _userData!['lastName']}")
                      : Text("Finn The Manager"),
                  accountEmail: _userData != null
                      ? Text("${_userData!['email']}")
                      : Text("finn@gstore.com"),
                  // You can provide an email address here if needed
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.white70,
                      backgroundImage: AssetImage('assets/logos/fin.png'),
                    ),
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.indigo // Change the background color of the header
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
                Divider(),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: Icon(Icons.list_alt_rounded,
                      color: Colors.indigo),
                  title: Text(
                    "Your Requests",
                    style: TextStyle(
                        color: Colors.indigo),
                  ),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => Requests()),
                    // );
                  },
                ),
                Divider(),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: const Icon(Icons.settings, color: Colors.indigo),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        color: Colors.indigo),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => settings()),
                    );
                  },
                ),

                Divider(),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: Icon(Icons.question_mark,
                      color: Colors.indigo),
                  title: Text(
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
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddRide()),
                          );
                        },
                        child: Text("Add Trip")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripsPage()),
                          );
                        },
                        child: Text("Show Trips")),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
