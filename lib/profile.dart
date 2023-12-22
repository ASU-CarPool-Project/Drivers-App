import 'package:asu_carpool_driver/DatabaseClass.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'MyWidgets.dart';
import 'auth.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Map<String, dynamic>? _userData;
  String? connection;
  String? name;
  String? email;
  String? phone;

  final LocalDatabase db = LocalDatabase();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  Future<void> _getUserInfo() async {
    final isConnected = await checkConnection();

    if (isConnected) {
      // Fetch user profile data from Firestore
      final userData = await fetchUserProfile();
      setState(() {
        _userData = userData;
        connection = "From Online DataBase";

        name = '${_userData!['firstName']} ${_userData!['lastName']}';
        email = _userData!['email'];
        phone = _userData!['phone'];
      });
    } else {
      // Fetch user profile data from local database
      final response = await db.reading('''SELECT * FROM 'USERS' LIMIT 1''');
      if (response.isNotEmpty) {
        final userFromDB = response.first;
        setState(() {
          connection = "From Local Database";
          name = '${userFromDB['FIRST_NAME']} ${userFromDB['LAST_NAME']}';
          email = userFromDB['EMAIL'];
          phone = userFromDB['PHONE'];
        });
      }
    }
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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
