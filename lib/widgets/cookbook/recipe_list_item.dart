import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/models/recipe.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/screens/recipe/recipe_detail_screen.dart';
import 'package:mon_petit_carnet/services/recipe_service.dart';
import 'package:mon_petit_carnet/utils/date_formatter.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final Cookbook cookbook;

  const RecipeListItem({
    super.key,
    required this.recipe,
    required this.cookbook,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).currentUser!.uid;
    final canEdit = cookbook.canEdit(userId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(
                recipe: recipe,
                cookbook: cookbook,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.photos.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    recipe.photos.first,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (canEdit)
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text('Copier'),
                              onTap: () async {
                                final recipeService = RecipeService();
                                await recipeService.copyRecipe(
                                  recipe,
                                  cookbook.id,
                                );
                              },
                            ),
                            if (recipe.authorId == userId ||
                                cookbook.isAdmin(userId))
                              PopupMenuItem(
                                child: const Text(
                                  'Supprimer',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () async {
                                  final recipeService = RecipeService();
                                  await recipeService.deleteRecipe(recipe.id);
                                },
                              ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text('${recipe.cookingTime} min'),
                      const SizedBox(width: 16),
                      const Icon(Icons.star_outline, size: 16),
                      const SizedBox(width: 4),
                      Text('${recipe.difficulty}/5'),
                      const Spacer(),
                      Text(
                        DateFormatter.formatDate(recipe.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}