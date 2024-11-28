import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/screens/cookbook/add_recipe_screen.dart';
import 'package:mon_petit_carnet/screens/cookbook/cookbook_settings_screen.dart';
import 'package:mon_petit_carnet/widgets/cookbook/recipe_list.dart';
import 'package:mon_petit_carnet/widgets/common/responsive_container.dart';

class CookbookScreen extends StatelessWidget {
  final Cookbook cookbook;

  const CookbookScreen({
    super.key,
    required this.cookbook,
  });

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).currentUser!.uid;
    final canEdit = cookbook.canEdit(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(cookbook.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CookbookSettingsScreen(cookbook: cookbook),
                ),
              );
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: RecipeList(cookbook: cookbook),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddRecipeScreen(cookbook: cookbook),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle recette'),
            )
          : null,
    );
  }
}