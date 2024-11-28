import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  final CollectionReference _configCollection = 
      FirebaseFirestore.instance.collection('config');

  Future<bool> isUpdateRequired() async {
    try {
      final configDoc = await _configCollection.doc('app_version').get();
      final minVersion = (configDoc.data() as Map<String, dynamic>)['minVersion'];
      
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      return _compareVersions(currentVersion, minVersion) < 0;
    } catch (e) {
      return false;
    }
  }

  int _compareVersions(String v1, String v2) {
    final v1Parts = v1.split('.').map(int.parse).toList();
    final v2Parts = v2.split('.').map(int.parse).toList();
    
    for (var i = 0; i < 3; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return 0;
  }
}