import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/models/recipe.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/services/recipe_service.dart';
import 'package:mon_petit_carnet/services/storage_service.dart';
import 'package:mon_petit_carnet/services/user_service.dart';
import 'package:mon_petit_carnet/utils/date_formatter.dart';
import 'package:mon_petit_carnet/utils/image_picker_helper.dart';
import 'package:mon_petit_carnet/widgets/common/loading_overlay.dart';
import 'package:uuid/uuid.dart';

class RecipeComments extends StatefulWidget {
  final Recipe recipe;
  final Cookbook cookbook;

  const RecipeComments({
    super.key,
    required this.recipe,
    required this.cookbook,
  });

  @override
  State<RecipeComments> createState() => _RecipeCommentsState();
}

class _RecipeCommentsState extends State<RecipeComments> {
  final _commentController = TextEditingController();
  final _recipeService = RecipeService();
  final _userService = UserService();
  final _storageService = StorageService();
  final _uuid = const Uuid();
  List<String> _photos = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final file = await ImagePickerHelper.pickImage(
      fromCamera: false,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (file != null) {
      setState(() => _isLoading = true);

      try {
        final url = await _storageService.uploadImage(
          file,
          'comments/${widget.recipe.id}',
        );

        setState(() {
          _photos.add(url);
        });
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
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty && _photos.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).currentUser!.uid;
      
      final comment = Comment(
        id: _uuid.v4(),
        authorId: userId,
        text: _commentController.text,
        photos: _photos,
        createdAt: DateTime.now(),
      );

      await _recipeService.addComment(widget.recipe.id, comment);

      if (mounted) {
        _commentController.clear();
        setState(() {
          _photos = [];
        });
      }
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
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Commentaires',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Ajouter un commentaire...',
                  ),
                  maxLines: null,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: _addPhoto,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _addComment,
              ),
            ],
          ),
          if (_photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _photos[index],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _photos.removeAt(index);
                              });
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
          ...widget.recipe.comments.map((comment) {
            return FutureBuilder(
              future: _userService.getUser(comment.authorId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final user = snapshot.data!;
                final isAuthor = comment.authorId ==
                    Provider.of<AuthProvider>(context).currentUser!.uid;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName ?? user.email,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormatter.timeAgo(comment.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (isAuthor)
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Text(
                                    'Supprimer',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () async {
                                    await _recipeService.deleteComment(
                                      widget.recipe.id,
                                      comment.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (comment.text.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(comment.text),
                      ],
                      if (comment.photos.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: comment.photos.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    comment.photos[index],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}