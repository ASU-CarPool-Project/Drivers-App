// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDMIpKFICa4CivXAGz9rQJGgf-5lR4Rdkc',
    appId: '1:663588902068:web:ff9369ab91ffde9acff3e1',
    messagingSenderId: '663588902068',
    projectId: 'asu-carpool-driver',
    authDomain: 'asu-carpool-driver.firebaseapp.com',
    storageBucket: 'asu-carpool-driver.appspot.com',
    databaseURL: 'https://asu-carpool-driver-default-rtdb.europe-west1.firebasedatabase.app/', // IMPORTANT!
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdg07Gj0Yd3x16anvz_uBKKsKyNCzi9fU',
    appId: '1:663588902068:android:a5422c2f9c18094acff3e1',
    messagingSenderId: '663588902068',
    projectId: 'asu-carpool-driver',
    storageBucket: 'asu-carpool-driver.appspot.com',
    databaseURL: 'https://asu-carpool-driver-default-rtdb.europe-west1.firebasedatabase.app/',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJkOuUm3JScKBwlyutQB55WnTSVjVbwFw',
    appId: '1:663588902068:ios:af1283380072ce89cff3e1',
    messagingSenderId: '663588902068',
    projectId: 'asu-carpool-driver',
    storageBucket: 'asu-carpool-driver.appspot.com',
    iosBundleId: 'com.example.asuCarpoolDriver',
    databaseURL: 'https://asu-carpool-driver-default-rtdb.europe-west1.firebasedatabase.app/',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJkOuUm3JScKBwlyutQB55WnTSVjVbwFw',
    appId: '1:663588902068:ios:74515c6b8b7026e4cff3e1',
    messagingSenderId: '663588902068',
    projectId: 'asu-carpool-driver',
    storageBucket: 'asu-carpool-driver.appspot.com',
    iosBundleId: 'com.example.asuCarpoolDriver.RunnerTests',
    databaseURL: 'https://asu-carpool-driver-default-rtdb.europe-west1.firebasedatabase.app/',
  );
}
