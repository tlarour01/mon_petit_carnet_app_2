import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mon_petit_carnet/services/user_service.dart';
import 'package:mon_petit_carnet/models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService();
  
  User? get currentUser => _auth.currentUser;
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _userService.createOrUpdateUser(userCredential.user!);
    
    notifyListeners();
    return userCredential;
  }

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    await _userService.createOrUpdateUser(userCredential.user!);
    notifyListeners();
    return userCredential;
  }

  Future<UserCredential> registerWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    await userCredential.user!.updateDisplayName(displayName);
    await _userService.createOrUpdateUser(userCredential.user!);
    
    notifyListeners();
    return userCredential;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (currentUser != null) {
      if (displayName != null) {
        await currentUser!.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await currentUser!.updatePhotoURL(photoUrl);
      }
      await _userService.createOrUpdateUser(currentUser!);
      notifyListeners();
    }
  }
}