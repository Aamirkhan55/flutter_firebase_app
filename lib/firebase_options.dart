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
    apiKey: 'AIzaSyDQEr7Heu6GeNk3WglKH24RuWn_b7U5E4o',
    appId: '1:57615969126:web:7266751624c978cbb2b6a7',
    messagingSenderId: '57615969126',
    projectId: 'notes-app-6b7f8',
    authDomain: 'notes-app-6b7f8.firebaseapp.com',
    storageBucket: 'notes-app-6b7f8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAt_dDHpD047jUkS3udNMVAze5bTN3GVL0',
    appId: '1:57615969126:android:ba3d5d59e739576ab2b6a7',
    messagingSenderId: '57615969126',
    projectId: 'notes-app-6b7f8',
    storageBucket: 'notes-app-6b7f8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD72z0NlR5GlqGV0Phi2ooQa9MSspIIuIA',
    appId: '1:57615969126:ios:0b6a53f2bb11c4f5b2b6a7',
    messagingSenderId: '57615969126',
    projectId: 'notes-app-6b7f8',
    storageBucket: 'notes-app-6b7f8.appspot.com',
    iosClientId: '57615969126-be04imtnedfv2iqjoh7lqvjlgrhm0kqi.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFirebaseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD72z0NlR5GlqGV0Phi2ooQa9MSspIIuIA',
    appId: '1:57615969126:ios:0b6a53f2bb11c4f5b2b6a7',
    messagingSenderId: '57615969126',
    projectId: 'notes-app-6b7f8',
    storageBucket: 'notes-app-6b7f8.appspot.com',
    iosClientId: '57615969126-be04imtnedfv2iqjoh7lqvjlgrhm0kqi.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterFirebaseApp',
  );
}
