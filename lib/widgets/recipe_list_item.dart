import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:family_recipe_book/models/recipe.dart';
import 'package:family_recipe_book/screens/recipe_detail_screen.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;

  const RecipeListItem({
    super.key,
    required this.recipe,
  });

  void _shareRecipe(BuildContext context) {
    final String shareText = '''
${recipe.title}
by ${recipe.author}

${recipe.description}

Ingredients:
${recipe.ingredients.map((i) => "• $i").join('\n')}

Steps:
${recipe.steps.map((s) => "${recipe.steps.indexOf(s) + 1}. $s").join('\n')}
''';

    Share.share(shareText, subject: recipe.title);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          recipe.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          recipe.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareRecipe(context),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
}