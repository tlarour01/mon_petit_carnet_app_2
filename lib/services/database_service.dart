import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:family_recipe_book/models/recipe.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'recipe_book.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        steps TEXT NOT NULL,
        author TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) {
      Map<String, dynamic> recipeMap = maps[i];
      recipeMap['ingredients'] = recipeMap['ingredients'].split('||');
      recipeMap['steps'] = recipeMap['steps'].split('||');
      return Recipe.fromJson(recipeMap);
    });
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await database;
    Map<String, dynamic> recipeMap = recipe.toJson();
    recipeMap['ingredients'] = recipe.ingredients.join('||');
    recipeMap['steps'] = recipe.steps.join('||');
    await db.insert('recipes', recipeMap);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await database;
    Map<String, dynamic> recipeMap = recipe.toJson();
    recipeMap['ingredients'] = recipe.ingredients.join('||');
    recipeMap['steps'] = recipe.steps.join('||');
    await db.update(
      'recipes',
      recipeMap,
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(String id) async {
    final db = await database;
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}