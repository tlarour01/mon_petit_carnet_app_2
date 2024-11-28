import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mon_petit_carnet/providers/auth_provider.dart';
import 'package:mon_petit_carnet/screens/auth/login_screen.dart';
import 'package:mon_petit_carnet/screens/home/home_screen.dart';
import 'package:mon_petit_carnet/services/version_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _versionService = VersionService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndVersion();
  }

  Future<void> _checkAuthAndVersion() async {
    final updateRequired = await _versionService.isUpdateRequired();
    
    if (!mounted) return;

    if (updateRequired) {
      _showUpdateDialog();
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      _navigateToHome();
    } else {
      _navigateToLogin();
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Mise à jour requise'),
        content: const Text(
          'Une nouvelle version de l\'application est disponible. '
          'Veuillez mettre à jour pour continuer.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Add store URL
              // launchUrl(Uri.parse('store_url'));
            },
            child: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            const Text(
              'Mon Petit Carnet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}