import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/utils/id_generator.dart';

class CookbookService {
  final CollectionReference _cookbooksCollection = 
      FirebaseFirestore.instance.collection('cookbooks');

  Future<List<Cookbook>> getUserCookbooks(String userId) async {
    final snapshot = await _cookbooksCollection
        .where('sharedWith.$userId', whereIn: [
          UserRole.admin.name,
          UserRole.collaborator.name,
          UserRole.reader.name
        ])
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Cookbook.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();
  }

  Future<Cookbook> createCookbook(String name, String ownerId) async {
    final cookbook = Cookbook(
      id: '',
      name: name,
      ownerId: ownerId,
      sharedWith: {ownerId: UserRole.admin},
      createdAt: DateTime.now(),
      uniqueIdentifier: generateUniqueId(name),
    );

    final docRef = await _cookbooksCollection.add(cookbook.toJson());
    return cookbook.copyWith(id: docRef.id);
  }

  Future<void> updateCookbook(Cookbook cookbook) async {
    await _cookbooksCollection.doc(cookbook.id).update(cookbook.toJson());
  }

  Future<void> deleteCookbook(String cookbookId) async {
    await _cookbooksCollection.doc(cookbookId).delete();
  }

  Future<Cookbook?> getCookbookByIdentifier(String identifier) async {
    final snapshot = await _cookbooksCollection
        .where('uniqueIdentifier', isEqualTo: identifier)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    
    final doc = snapshot.docs.first;
    return Cookbook.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
  }

  Future<void> updateUserRole(
    String cookbookId,
    String userId,
    UserRole role,
  ) async {
    await _cookbooksCollection.doc(cookbookId).update({
      'sharedWith.$userId': role.name,
    });
  }

  Future<void> removeUser(String cookbookId, String userId) async {
    await _cookbooksCollection.doc(cookbookId).update({
      'sharedWith.$userId': FieldValue.delete(),
    });
  }
}