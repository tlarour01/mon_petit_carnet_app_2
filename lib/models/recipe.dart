class Recipe {
  final String id;
  final String cookbookId;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> photos;
  final String authorId;
  final DateTime createdAt;
  final int cookingTime;
  final int difficulty;
  final List<Comment> comments;

  Recipe({
    required this.id,
    required this.cookbookId,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.photos,
    required this.authorId,
    required this.createdAt,
    required this.cookingTime,
    required this.difficulty,
    required this.comments,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      cookbookId: json['cookbookId'],
      title: json['title'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      photos: List<String>.from(json['photos']),
      authorId: json['authorId'],
      createdAt: DateTime.parse(json['createdAt']),
      cookingTime: json['cookingTime'],
      difficulty: json['difficulty'],
      comments: (json['comments'] as List? ?? [])
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cookbookId': cookbookId,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'photos': photos,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  Recipe copyWith({
    String? id,
    String? cookbookId,
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
    List<String>? photos,
    String? authorId,
    DateTime? createdAt,
    int? cookingTime,
    int? difficulty,
    List<Comment>? comments,
  }) {
    return Recipe(
      id: id ?? this.id,
      cookbookId: cookbookId ?? this.cookbookId,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? List.from(this.ingredients),
      steps: steps ?? List.from(this.steps),
      photos: photos ?? List.from(this.photos),
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      comments: comments ?? List.from(this.comments),
    );
  }
}

class Comment {
  final String id;
  final String authorId;
  final String text;
  final List<String> photos;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.authorId,
    required this.text,
    required this.photos,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      authorId: json['authorId'],
      text: json['text'],
      photos: List<String>.from(json['photos']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'text': text,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Comment copyWith({
    String? id,
    String? authorId,
    String? text,
    List<String>? photos,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      photos: photos ?? List.from(this.photos),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}