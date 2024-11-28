import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:family_recipe_book/providers/recipe_provider.dart';
import 'package:family_recipe_book/screens/add_recipe_screen.dart';
import 'package:family_recipe_book/widgets/recipe_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RecipeProvider>(context, listen: false).loadRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Recipe Book'),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          final recipes = recipeProvider.recipes;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return RecipeListItem(recipe: recipes[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}