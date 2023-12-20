import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'MyWidgets.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Map<String, dynamic>? _userData;

  String? connection;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? phone;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  Future<SharedPreferences> getPref() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return myPref;
  }

  Future<void> _getUserInfo() async {
    try {
      // Check for internet connection using the connectivity package
      var connectivityResult = await Connectivity().checkConnectivity();
      bool hasInternetConnection =
          connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi;
      print(hasInternetConnection);
      if (hasInternetConnection) {
        print("Internet connection");
        print("Online DB 1");
        await _fetchDataFromFirestore();
        // await _fetchDataFromPref();
      } else {
        print("No internet connection");
        print("Local DB 1");
        await _fetchDataFromPref();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      print("Online DB 2");
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance
                .collection('users_driver')
                .doc(user.uid)
                .get();

        setState(() {
          _userData = userData.data();
          connection = "From Online DataBase";

          name = '${_userData!['firstName']} ${_userData!['lastName']}';
          email = _userData!['email'];
          phone = _userData!['phone'];
        });
      } else {
        await _fetchDataFromPref();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchDataFromPref() async {
    try {
      print("Local DB 2");
      SharedPreferences myPref = await getPref();
      setState(() {
        connection = "From Local Database";

        firstName = myPref.getString('firstName') ?? '';
        lastName = myPref.getString('lastName') ?? '';
        email = myPref.getString('email') ?? '';
        phone = myPref.getString('phone') ?? '';
        name = '$firstName $lastName';

        print(name);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

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
                textPlace("Connection: ", connection ?? ''),
                textPlace("Name: ", name ?? ''),
                textPlace("Email: ", email ?? ''),
                textPlace("Phone Number: ", phone ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
