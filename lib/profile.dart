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
      await FirebaseFirestore.instance.collection('users_driver').doc(user.uid).get();

      setState(() {
        _user = user;
        _userData = userData.data();
      });
    }
  }

  Widget textPlace(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsPrimary,
        leading: IconButton(
          icon: const Icon(
            IconData(0xe093,
                fontFamily: 'MaterialIcons', matchTextDirection: true),
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                if (_userData != null)
                  textPlace("Name: ", _userData!['firstName'] +" "+ _userData!['lastName'] ?? ''),
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
