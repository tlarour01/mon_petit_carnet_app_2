import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/services/cookbook_service.dart';
import 'package:mon_petit_carnet/services/user_service.dart';
import 'package:mon_petit_carnet/widgets/common/loading_overlay.dart';

class CookbookSettingsScreen extends StatefulWidget {
  final Cookbook cookbook;

  const CookbookSettingsScreen({
    super.key,
    required this.cookbook,
  });

  @override
  State<CookbookSettingsScreen> createState() => _CookbookSettingsScreenState();
}

class _CookbookSettingsScreenState extends State<CookbookSettingsScreen> {
  final _cookbookService = CookbookService();
  final _userService = UserService();
  bool _isLoading = false;

  Future<void> _updateUserRole(String userId, UserRole role) async {
    setState(() => _isLoading = true);

    try {
      await _cookbookService.updateUserRole(
        widget.cookbook.id,
        userId,
        role,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removeUser(String userId) async {
    setState(() => _isLoading = true);

    try {
      await _cookbookService.removeUser(
        widget.cookbook.id,
        userId,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<AuthProvider>(context).currentUser!.uid;
    final isAdmin = widget.cookbook.isAdmin(currentUserId);

    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Paramètres du carnet'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Identifiant du carnet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.cookbook.uniqueIdentifier,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              // TODO: Implement copy to clipboard
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Partagez cet identifiant avec vos proches pour leur permettre '
                        'd\'accéder à ce carnet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Participants',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: Future.wait(
                  widget.cookbook.sharedWith.keys.map(
                    (userId) => _userService.getUser(userId),
                  ),
                ),
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

                  final users = snapshot.data!
                      .where((user) => user != null)
                      .map((user) => user!);

                  return Column(
                    children: users.map((user) {
                      final role = widget.cookbook.sharedWith[user.uid]!;
                      final isCurrentUser = user.uid == currentUserId;

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? Text(
                                    user.displayName?[0].toUpperCase() ?? 
                                    user.email[0].toUpperCase(),
                                  )
                                : null,
                          ),
                          title: Text(user.displayName ?? user.email),
                          subtitle: Text(role.name),
                          trailing: isAdmin && !isCurrentUser
                              ? PopupMenuButton<UserRole>(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: UserRole.reader,
                                      child: Text('Lecteur'),
                                    ),
                                    const PopupMenuItem(
                                      value: UserRole.collaborator,
                                      child: Text('Collaborateur'),
                                    ),
                                    const PopupMenuItem(
                                      value: UserRole.admin,
                                      child: Text('Administrateur'),
                                    ),
                                    const PopupMenuDivider(),
                                    const PopupMenuItem(
                                      value: UserRole.reader,
                                      child: Text(
                                        'Retirer',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == UserRole.reader &&
                                        role != UserRole.reader) {
                                      _removeUser(user.uid);
                                    } else {
                                      _updateUserRole(user.uid, value);
                                    }
                                  },
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}