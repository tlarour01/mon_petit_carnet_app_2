import 'package:flutter/material.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/models/recipe.dart';
import 'package:mon_petit_carnet/services/recipe_service.dart';
import 'package:mon_petit_carnet/widgets/cookbook/recipe_list_item.dart';
import 'package:mon_petit_carnet/widgets/common/scrollable_list_container.dart';

class RecipeList extends StatelessWidget {
  final Cookbook cookbook;

  const RecipeList({
    super.key,
    required this.cookbook,
  });

  @override
  Widget build(BuildContext context) {
    final recipeService = RecipeService();

    return FutureBuilder<List<Recipe>>(
      future: recipeService.getRecipesByCookbook(cookbook.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final recipes = snapshot.data!;

        if (recipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune recette',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ajoutez votre première recette\nen cliquant sur le bouton +',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ScrollableListContainer(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: recipes.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeListItem(
                recipe: recipe,
                cookbook: cookbook,
              );
            },
          ),
        );
      },
    );
  }
}