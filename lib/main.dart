import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home.dart';

// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common/sqlite_api.dart';
// import 'package:sqflite_common/utils/utils.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite_common_ffi_web/src/sw/constants.dart';
// import 'package:sqflite_common_ffi_web/src/web/load_sqlite_web.dart'
//     show SqfliteFfiWebContextExt;
import 'SignIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'asu-carpool-driver',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  // await sqfliteInit('asucarpool_driver_v2.db');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Future<void> initializeApp() async {
  //   await Future.delayed(const Duration(seconds: 2));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final bool isLoggedIn = snapshot.hasData && snapshot.data != null;
            return isLoggedIn ? const home() : const SignIn();
          }
        },
      ),
    );
  }
}
