import 'package:flutter/foundation.dart';
import 'package:family_recipe_book/models/recipe.dart';
import 'package:family_recipe_book/services/database_service.dart';

class RecipeProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Future<void> loadRecipes() async {
    _recipes = await _db.getRecipes();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _db.insertRecipe(recipe);
    await loadRecipes();
  }

  Future<void> deleteRecipe(String id) async {
    await _db.deleteRecipe(id);
    await loadRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _db.updateRecipe(recipe);
    await loadRecipes();
  }
}