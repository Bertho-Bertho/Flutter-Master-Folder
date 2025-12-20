import 'package:flutter/material.dart';
import 'package:product/services/auth_service.dart';
import 'package:product/views/user/dashboard/dashboardAdmin.dart';
import 'package:product/views/user/dashboard/dashboardCaissier.dart'; // Assurez-vous d'utiliser cette version
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static final AuthController _instance = AuthController.internal();
  factory AuthController() => _instance;
  AuthController.internal();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Méthode login qui prend email et password en paramètres
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _isLoading = true;

    try {
      final user = await _authService.login(email.trim(), password.trim());

      if (user != null) {
        final String role = user.role ?? 'caissier';

        // Redirection en fonction du rôle
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardAdmin()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardCaissier()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_id');
    } catch (e) {
      print('Erreur logout: $e');
    }
  }
}
