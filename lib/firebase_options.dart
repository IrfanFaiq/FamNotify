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
    apiKey: 'AIzaSyCSLuk7CWQmvLWLw6F5FcOejEfQUJKr9I0',
    appId: '1:105897902395:web:42c6dcd76c48a4a414371e',
    messagingSenderId: '105897902395',
    projectId: 'famnotify-c2366',
    authDomain: 'famnotify-c2366.firebaseapp.com',
    storageBucket: 'famnotify-c2366.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrpwN6fdn0_1L5UUSGhuYe0oTyK1blUi0',
    appId: '1:105897902395:android:5b072e1694b03ac914371e',
    messagingSenderId: '105897902395',
    projectId: 'famnotify-c2366',
    storageBucket: 'famnotify-c2366.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZHrVnhyPQjrxU_gIdcITrXuWovRGtaZ0',
    appId: '1:105897902395:ios:e34b408ff76f649714371e',
    messagingSenderId: '105897902395',
    projectId: 'famnotify-c2366',
    storageBucket: 'famnotify-c2366.appspot.com',
    iosClientId: '105897902395-iktg9kom5bugnn3lm0ru2u1n307eoo9f.apps.googleusercontent.com',
    iosBundleId: 'com.example.famNotify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZHrVnhyPQjrxU_gIdcITrXuWovRGtaZ0',
    appId: '1:105897902395:ios:e34b408ff76f649714371e',
    messagingSenderId: '105897902395',
    projectId: 'famnotify-c2366',
    storageBucket: 'famnotify-c2366.appspot.com',
    iosClientId: '105897902395-iktg9kom5bugnn3lm0ru2u1n307eoo9f.apps.googleusercontent.com',
    iosBundleId: 'com.example.famNotify',
  );
}
