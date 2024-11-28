import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/services/cookbook_service.dart';
import 'package:mon_petit_carnet/widgets/common/loading_overlay.dart';

class AddCookbookScreen extends StatefulWidget {
  const AddCookbookScreen({super.key});

  @override
  State<AddCookbookScreen> createState() => _AddCookbookScreenState();
}

class _AddCookbookScreenState extends State<AddCookbookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _cookbookService = CookbookService();
  bool _isLoading = false;
  bool _isNewCookbook = true;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _createCookbook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).currentUser!.uid;
      await _cookbookService.createCookbook(_nameController.text, userId);
      if (mounted) {
        Navigator.pop(context);
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

  Future<void> _addExistingCookbook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cookbook = await _cookbookService.getCookbookByIdentifier(
        _identifierController.text,
      );

      if (cookbook == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carnet introuvable')),
          );
        }
        return;
      }

      final userId = Provider.of<AuthProvider>(context, listen: false).currentUser!.uid;
      
      if (cookbook.sharedWith.containsKey(userId)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous avez déjà accès à ce carnet')),
          );
        }
        return;
      }

      await _cookbookService.updateUserRole(
        cookbook.id,
        userId,
        UserRole.reader,
      );

      if (mounted) {
        Navigator.pop(context);
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isNewCookbook ? 'Nouveau carnet' : 'Ajouter un carnet'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Créer'),
                      icon: Icon(Icons.create),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('Rejoindre'),
                      icon: Icon(Icons.add),
                    ),
                  ],
                  selected: {_isNewCookbook},
                  onSelectionChanged: (value) {
                    setState(() => _isNewCookbook = value.first);
                  },
                ),
                const SizedBox(height: 24),
                if (_isNewCookbook) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du carnet',
                      hintText: 'Ex: Recettes de famille',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _createCookbook,
                    child: const Text('Créer le carnet'),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _identifierController,
                    decoration: const InputDecoration(
                      labelText: 'Identifiant du carnet',
                      hintText: 'Ex: recettes#ABC12',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer l\'identifiant';
                      }
                      if (!value.contains('#')) {
                        return 'Format invalide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addExistingCookbook,
                    child: const Text('Rejoindre le carnet'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}