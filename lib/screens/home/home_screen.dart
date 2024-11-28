import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/screens/home/add_cookbook_screen.dart';
import 'package:mon_petit_carnet/screens/profile/profile_screen.dart';
import 'package:mon_petit_carnet/widgets/cookbook/cookbook_list.dart';
import 'package:mon_petit_carnet/widgets/common/responsive_container.dart';
import 'package:mon_petit_carnet/services/ad_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Petit Carnet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ResponsiveContainer(
              child: CookbookList(),
            ),
          ),
          const AdBanner(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCookbookScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau carnet'),
      ),
    );
  }
}