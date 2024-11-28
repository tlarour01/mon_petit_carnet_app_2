import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mon_petit_carnet/models/user.dart';

class UserService {
  final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');

  Future<void> createOrUpdateUser(User firebaseUser) async {
    final userData = {
      'uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'displayName': firebaseUser.displayName,
      'photoUrl': firebaseUser.photoURL,
      'lastLogin': DateTime.now().toIso8601String(),
    };

    final userDoc = await _usersCollection.doc(firebaseUser.uid).get();
    
    if (!userDoc.exists) {
      userData['createdAt'] = DateTime.now().toIso8601String();
    }

    await _usersCollection.doc(firebaseUser.uid).set(userData, SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}