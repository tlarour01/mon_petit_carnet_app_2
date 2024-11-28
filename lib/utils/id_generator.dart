import 'dart:math';

String generateUniqueId(String name) {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final randomString = List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();
  
  final sanitizedName = name
      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
      .toLowerCase()
      .substring(0, min(name.length, 10));
  
  return '$sanitizedName#$randomString';
}