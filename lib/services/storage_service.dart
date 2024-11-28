import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<String> uploadImage(File file, String folder) async {
    final extension = path.extension(file.path);
    final fileName = '${_uuid.v4()}$extension';
    final ref = _storage.ref().child('$folder/$fileName');
    
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<List<String>> uploadImages(List<File> files, String folder) async {
    final uploadTasks = files.map((file) => uploadImage(file, folder));
    return await Future.wait(uploadTasks);
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Handle or log error
    }
  }
}