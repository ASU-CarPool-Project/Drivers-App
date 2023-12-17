import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'TripsPage.dart';
import 'AddRide.dart';
import 'profile.dart';
import 'requests.dart';
import 'SignIn.dart';
import 'about.dart';
import 'auth.dart';
import 'tracking.dart';

String username = "";
String phone = "";
String userID = "";

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  User? _user;
  Map<String, dynamic>? _userData;

  DatabaseReference tripsReference =
      FirebaseDatabase.instance.ref().child("Requests");

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  /////////////////////////////////////////////////////////////////////////////

  Future<void> _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users_driver')
          .doc(user.uid)
          .get();

      setState(() {
        _user = user;
        _userData = userData.data();
        username = _userData!['firstName'] + " " + _userData!['lastName'];
        phone = _userData!['phone'];
        userID = user.uid;
      });
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorsPrimary,
          // leading: iconBack(context),
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
                      ? Text(
                          "${_userData!['firstName'] + " " + _userData!['lastName']}")
                      : const Text("Jake The Dog"),
                  accountEmail: _userData != null
                      ? Text("${_userData!['email']}")
                      : const Text("jake@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.white70,
                      backgroundImage: AssetImage('assets/logos/jake.jpg'),
                    ),
                  ),
                  decoration: BoxDecoration(color: colorsPrimary),
                ),
                ListTile(
                  // tileColor: Theme.of(context).colorScheme.secondary,
                  leading: Icon(Icons.face, color: colorsPrimary),
                  title: Text(
                    "Profile",
                    style: TextStyle(color: colorsPrimary),
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
                  leading: Icon(Icons.question_mark, color: colorsPrimary),
                  title: Text(
                    "About",
                    style: TextStyle(color: colorsPrimary),
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
                  leading: Icon(Icons.list_alt_rounded, color: colorsPrimary),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(color: colorsPrimary),
                  ),
                  onTap: () {
                    signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          // color: Colors.blue,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    // color: Colors.yellow,
                    child: Expanded(
                        child: StreamBuilder(
                      stream: tripsReference.onValue,
                      builder:
                          (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                        if (snapshot.hasData &&
                            !snapshot.hasError &&
                            snapshot.data!.snapshot.value != null) {
                          Map<dynamic, dynamic>? trips = snapshot
                              .data!.snapshot.value as Map<dynamic, dynamic>?;
                          List<MapEntry> allList =
                              trips?.entries.toList() ?? [];
                          String status = "Accepted";
                          List<MapEntry> tripList = allList
                              .where((entry) => entry.value["reqStatus"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(status.toLowerCase()))
                              .toList();

                          return ListView.builder(
                            itemCount: tripList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => tracking(
                                            tripData: tripList[index].value,
                                            tripKey:
                                                tripList[index].key.toString()),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.lightGreen,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.pin_drop_sharp,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              textPageTitle(
                                                  "Route: ${tripList[index].value["route"]}"),
                                              textPageTitle(
                                                  "${tripList[index].value["date"]} / ${tripList[index].value["time"]}"),
                                              textPageTitle(
                                                  "Client: ${tripList[index].value["client"]}"),
                                              textPageTitle(
                                                  "Status: ${tripList[index].value["reqStatus"]}"),
                                            ],
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.check),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          print("Errooooooooooor: ${snapshot.error}");
                          return Card(
                            color: colorsCards,
                            child: ListTile(
                              tileColor: Colors.transparent,
                              leading: const Icon(
                                Icons.bus_alert,
                                color: Colors.white,
                              ),
                              title: textPageTitle("No Accepted Trips yet!"),
                            ),
                          );
                        }
                      },
                    )),
                  ),
                  Container(
                    // color: Colors.yellow,
                    child: Expanded(
                        child: StreamBuilder(
                      stream: tripsReference.onValue,
                      builder:
                          (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                        if (snapshot.hasData &&
                            !snapshot.hasError &&
                            snapshot.data!.snapshot.value != null) {
                          Map<dynamic, dynamic>? trips = snapshot
                              .data!.snapshot.value as Map<dynamic, dynamic>?;
                          List<MapEntry> allList =
                              trips?.entries.toList() ?? [];
                          String status = "in-service";
                          List<MapEntry> tripList = allList
                              .where((entry) => entry.value["reqStatus"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(status.toLowerCase()))
                              .toList();

                          return ListView.builder(
                            itemCount: tripList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => tracking(
                                            tripData: tripList[index].value,
                                            tripKey:
                                                tripList[index].key.toString()),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.deepOrangeAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.pin_drop_sharp,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              textPageTitle(
                                                  "Route: ${tripList[index].value["route"]}"),
                                              textPageTitle(
                                                  "${tripList[index].value["date"]} / ${tripList[index].value["time"]}"),
                                              textPageTitle(
                                                  "Client: ${tripList[index].value["client"]}"),
                                              textPageTitle(
                                                  "Status: ${tripList[index].value["reqStatus"]}"),
                                            ],
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: const Icon(Icons.check),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          print("Errooooooooooor: ${snapshot.error}");
                          return Card(
                            color: colorsCards,
                            child: ListTile(
                              tileColor: Colors.transparent,
                              leading: const Icon(
                                Icons.bus_alert,
                                color: Colors.white,
                              ),
                              title: textPageTitle("No Accepted Trips yet!"),
                            ),
                          );
                        }
                      },
                    )),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: ListTile(
                                  tileColor: colorsPrimary,
                                  title: const Text(
                                    "Add Trip",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: const Icon(
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
                                child: ListTile(
                                  tileColor: colorsPrimary,
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
                                child: ListTile(
                                  tileColor: colorsPrimary,
                                  title: Text(
                                    "Requests",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Icon(
                                    Icons.add_task,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => requests()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
