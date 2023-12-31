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
    apiKey: 'AIzaSyDoIjadfOD6mc1mNBGsWibksiu-_CLsvlA',
    appId: '1:1022783032176:web:768ef6894952dadf121db5',
    messagingSenderId: '1022783032176',
    projectId: 'timemanagement456-104db',
    authDomain: 'timemanagement456-104db.firebaseapp.com',
    storageBucket: 'timemanagement456-104db.appspot.com',
    measurementId: 'G-3LHENJVCW7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjgXzFtM7iO7u-YE_NnRH8WxBqb7pimEo',
    appId: '1:1022783032176:android:2266bd914781f93f121db5',
    messagingSenderId: '1022783032176',
    projectId: 'timemanagement456-104db',
    storageBucket: 'timemanagement456-104db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXoKZvVGT-A83yj54vTtY6BcY9n_SDVHM',
    appId: '1:1022783032176:ios:aea102bc7bb6e2a8121db5',
    messagingSenderId: '1022783032176',
    projectId: 'timemanagement456-104db',
    storageBucket: 'timemanagement456-104db.appspot.com',
    iosBundleId: 'com.example.individualprojectfinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXoKZvVGT-A83yj54vTtY6BcY9n_SDVHM',
    appId: '1:1022783032176:ios:e0a1891932c4e8db121db5',
    messagingSenderId: '1022783032176',
    projectId: 'timemanagement456-104db',
    storageBucket: 'timemanagement456-104db.appspot.com',
    iosBundleId: 'com.example.individualprojectfinal.RunnerTests',
  );
}
