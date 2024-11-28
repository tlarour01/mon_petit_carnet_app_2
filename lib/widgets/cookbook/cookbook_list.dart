import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/screens/cookbook/cookbook_screen.dart';
import 'package:mon_petit_carnet/services/cookbook_service.dart';
import 'package:mon_petit_carnet/widgets/cookbook/cookbook_list_item.dart';
import 'package:mon_petit_carnet/widgets/common/scrollable_list_container.dart';

class CookbookList extends StatelessWidget {
  const CookbookList({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).currentUser!.uid;
    final cookbookService = CookbookService();

    return StreamBuilder<List<Cookbook>>(
      stream: Stream.fromFuture(cookbookService.getUserCookbooks(userId)),
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

        final cookbooks = snapshot.data!;

        if (cookbooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun carnet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Créez votre premier carnet ou\nrejoignez un carnet existant',
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
            itemCount: cookbooks.length,
            itemBuilder: (context, index) {
              final cookbook = cookbooks[index];
              return CookbookListItem(
                cookbook: cookbook,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CookbookScreen(cookbook: cookbook),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}