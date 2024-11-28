enum UserRole {
  admin,
  collaborator,
  reader,
}

class Cookbook {
  final String id;
  final String name;
  final String ownerId;
  final Map<String, UserRole> sharedWith;
  final DateTime createdAt;
  final String uniqueIdentifier;

  Cookbook({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.sharedWith,
    required this.createdAt,
    required this.uniqueIdentifier,
  });

  factory Cookbook.fromJson(Map<String, dynamic> json) {
    return Cookbook(
      id: json['id'],
      name: json['name'],
      ownerId: json['ownerId'],
      sharedWith: Map<String, UserRole>.from(json['sharedWith'].map(
        (key, value) => MapEntry(key, UserRole.values.byName(value)),
      )),
      createdAt: DateTime.parse(json['createdAt']),
      uniqueIdentifier: json['uniqueIdentifier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ownerId': ownerId,
      'sharedWith': sharedWith.map(
        (key, value) => MapEntry(key, value.name),
      ),
      'createdAt': createdAt.toIso8601String(),
      'uniqueIdentifier': uniqueIdentifier,
    };
  }

  Cookbook copyWith({
    String? id,
    String? name,
    String? ownerId,
    Map<String, UserRole>? sharedWith,
    DateTime? createdAt,
    String? uniqueIdentifier,
  }) {
    return Cookbook(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? Map.from(this.sharedWith),
      createdAt: createdAt ?? this.createdAt,
      uniqueIdentifier: uniqueIdentifier ?? this.uniqueIdentifier,
    );
  }

  bool canEdit(String userId) {
    return ownerId == userId || sharedWith[userId] == UserRole.collaborator;
  }

  bool isAdmin(String userId) {
    return ownerId == userId;
  }
}