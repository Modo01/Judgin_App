// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDzbMBrotiv26QJ8F1BQtWlS2VEMqBWuTA',
    appId: '1:886142281613:web:dd59d35313529676667fc4',
    messagingSenderId: '886142281613',
    projectId: 'judgingapp-449cd',
    authDomain: 'judgingapp-449cd.firebaseapp.com',
    storageBucket: 'judgingapp-449cd.appspot.com',
    measurementId: 'G-D00DL8Q38Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfJz3gWi1dhZu9Nh6AIezKNRaDN77zdsQ',
    appId: '1:886142281613:android:2a335f2c490040fa667fc4',
    messagingSenderId: '886142281613',
    projectId: 'judgingapp-449cd',
    storageBucket: 'judgingapp-449cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCABsN6RUWauCZvF-3TSyKIvdT4HfC2dHU',
    appId: '1:886142281613:ios:a8d81991998a4591667fc4',
    messagingSenderId: '886142281613',
    projectId: 'judgingapp-449cd',
    storageBucket: 'judgingapp-449cd.appspot.com',
    iosBundleId: 'com.example.judgingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCABsN6RUWauCZvF-3TSyKIvdT4HfC2dHU',
    appId: '1:886142281613:ios:a8d81991998a4591667fc4',
    messagingSenderId: '886142281613',
    projectId: 'judgingapp-449cd',
    storageBucket: 'judgingapp-449cd.appspot.com',
    iosBundleId: 'com.example.judgingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDzbMBrotiv26QJ8F1BQtWlS2VEMqBWuTA',
    appId: '1:886142281613:web:8f185ea0a6135846667fc4',
    messagingSenderId: '886142281613',
    projectId: 'judgingapp-449cd',
    authDomain: 'judgingapp-449cd.firebaseapp.com',
    storageBucket: 'judgingapp-449cd.appspot.com',
    measurementId: 'G-HL89G19WW5',
  );
}
