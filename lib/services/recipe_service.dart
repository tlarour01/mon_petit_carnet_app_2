import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mon_petit_carnet/models/recipe.dart';

class RecipeService {
  final CollectionReference _recipesCollection = 
      FirebaseFirestore.instance.collection('recipes');

  Future<List<Recipe>> getRecipesByCookbook(String cookbookId) async {
    final snapshot = await _recipesCollection
        .where('cookbookId', isEqualTo: cookbookId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Recipe.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final docRef = await _recipesCollection.add(recipe.toJson());
    return recipe.copyWith(id: docRef.id);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _recipesCollection.doc(recipe.id).update(recipe.toJson());
  }

  Future<void> deleteRecipe(String recipeId) async {
    await _recipesCollection.doc(recipeId).delete();
  }

  Future<Recipe> copyRecipe(Recipe recipe, String newCookbookId) async {
    final newRecipe = recipe.copyWith(
      id: '',
      cookbookId: newCookbookId,
      comments: [],
      createdAt: DateTime.now(),
    );
    
    final docRef = await _recipesCollection.add(newRecipe.toJson());
    return newRecipe.copyWith(id: docRef.id);
  }

  Future<void> addComment(String recipeId, Comment comment) async {
    await _recipesCollection.doc(recipeId).update({
      'comments': FieldValue.arrayUnion([comment.toJson()]),
    });
  }

  Future<void> updateComment(String recipeId, Comment comment) async {
    final recipe = await _recipesCollection.doc(recipeId).get();
    final comments = List<Map<String, dynamic>>.from(
      (recipe.data() as Map<String, dynamic>)['comments'] ?? [],
    );
    
    final index = comments.indexWhere((c) => c['id'] == comment.id);
    if (index != -1) {
      comments[index] = comment.toJson();
      await _recipesCollection.doc(recipeId).update({'comments': comments});
    }
  }

  Future<void> deleteComment(String recipeId, String commentId) async {
    final recipe = await _recipesCollection.doc(recipeId).get();
    final comments = List<Map<String, dynamic>>.from(
      (recipe.data() as Map<String, dynamic>)['comments'] ?? [],
    );
    
    comments.removeWhere((c) => c['id'] == commentId);
    await _recipesCollection.doc(recipeId).update({'comments': comments});
  }
}