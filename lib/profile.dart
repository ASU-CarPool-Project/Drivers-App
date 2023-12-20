import 'package:asu_carpool_driver/DatabaseClass.dart';
import 'package:asu_carpool_driver/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MyWidgets.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  LocalDatabase mydb = LocalDatabase();
  User? _user;
  Map<String, dynamic>? _userData;
  String? connection;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  /////////////////////////////////////////////////////////////////////////////

  Future<void> _getUserInfo() async {
    // Check for internet connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("---------------> No internet connection");
      connection = "From Local Database";
      print("Local DB 1");
      _fetchDataFromSQLite();
      // _fetchDataFromFirestore();
    } else {
      connection = "From Online DataBase";
      print("Online DB 1");
      // _fetchDataFromFirestore();
      _fetchDataFromSQLite();
    }
  }

  Future<void> _fetchDataFromFirestore() async {
    print("Online DB 2");
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
      });
    }
  }

  Future<void> _fetchDataFromSQLite() async {
    print("Local DB 2");
    Map<String, dynamic>? RESPONSE =
        await mydb.reading('''SELECT * FROM '$userID' ''');
    _userData = RESPONSE;
    setState(() {});
  }

  /////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsPrimary,
        leading: iconBack(context),
        title: textPageTitle("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          color: Colors.white70,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (connection != null) textPlace("Connection: ", connection!),
                if (_userData != null)
                  textPlace(
                      "Name: ",
                      _userData!['firstName'] + " " + _userData!['lastName'] ??
                          ''),
                if (_userData != null)
                  textPlace("Email: ", _userData!['email'] ?? ''),
                if (_userData != null)
                  textPlace("Phone Number: ", _userData!['phone'] ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
