import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:615875532061:web:xxxxxxxxxxxxxxxxxxxxxxxx',
    messagingSenderId: '615875532061',
    projectId: 'mon-petit-carnet-b8887',
    authDomain: 'mon-petit-carnet-b8887.firebaseapp.com',
    storageBucket: 'mon-petit-carnet-b8887.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:615875532061:android:xxxxxxxxxxxxxxxxxxxxxxxx',
    messagingSenderId: '615875532061',
    projectId: 'mon-petit-carnet-b8887',
    storageBucket: 'mon-petit-carnet-b8887.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:615875532061:ios:6fa4cb1ed139d3e639bdf4',
    messagingSenderId: '615875532061',
    projectId: 'mon-petit-carnet-b8887',
    storageBucket: 'mon-petit-carnet-b8887.appspot.com',
    iosClientId: '615875532061-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com',
    iosBundleId: 'com.larour.monPetitCarnet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:615875532061:ios:6fa4cb1ed139d3e639bdf4',
    messagingSenderId: '615875532061',
    projectId: 'mon-petit-carnet-b8887',
    storageBucket: 'mon-petit-carnet-b8887.appspot.com',
    iosClientId: '615875532061-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com',
    iosBundleId: 'com.larour.monPetitCarnet',
  );
}