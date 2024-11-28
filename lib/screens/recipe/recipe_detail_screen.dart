import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/models/recipe.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/screens/recipe/edit_recipe_screen.dart';
import 'package:mon_petit_carnet/services/recipe_service.dart';
import 'package:mon_petit_carnet/widgets/recipe/recipe_comments.dart';
import 'package:mon_petit_carnet/widgets/recipe/recipe_photos.dart';
import 'package:mon_petit_carnet/services/ad_service.dart';
import 'package:mon_petit_carnet/utils/date_formatter.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final Cookbook cookbook;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.cookbook,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).currentUser!.uid;
    final canEdit = recipe.authorId == userId || cookbook.isAdmin(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditRecipeScreen(
                      recipe: recipe,
                      cookbook: cookbook,
                    ),
                  ),
                );
              },
            ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Copier vers...'),
                onTap: () async {
                  // TODO: Implement copy to another cookbook
                },
              ),
              if (canEdit)
                PopupMenuItem(
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Supprimer la recette'),
                        content: const Text(
                          'Êtes-vous sûr de vouloir supprimer cette recette ? '
                          'Cette action est irréversible.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Supprimer',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      final recipeService = RecipeService();
                      await recipeService.deleteRecipe(recipe.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recipe.photos.isNotEmpty)
                    RecipePhotos(photos: recipe.photos),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... Rest of the recipe detail content ...
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const AdBanner(),
        ],
      ),
    );
  }
}