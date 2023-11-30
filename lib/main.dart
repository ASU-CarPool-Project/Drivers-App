import 'package:asu_carpool_driver/home.dart';
import 'package:flutter/material.dart';
import 'AddRide.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SignIn.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        home: SignIn()
    );
  }
}