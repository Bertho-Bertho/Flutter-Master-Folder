import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:product/database/database_helper.dart';
import 'package:product/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // connexion d'un nouvel utilisateur [Login utilisateur]
  Future<User?> login(String email, String password) async {
    final db = await _dbHelper.database;

    // Hachage du mot de passe
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    print("Email reçu: $email");
    print("Password reçu: $password");
    print("Password haché: $hashedPassword");

    // Vérifiez ce qui est dans la base
    final allUsers = await db.query('users');
    print("Utilisateurs en base: $allUsers");

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
      limit: 1,
    );

    print("Résultat query: $result");

    if (result.isEmpty) return null;

    final user = User.fromMap(result.first);
    print("Utilisateur trouvé: $user");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', user.id);

    return user;
  }

  // Deconnexion d'un utilisateur
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
  }

  // Utilisateur connecté a modifier pour prendre tout les utiliseurs connctees
  // Future<User?> getCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('current_user_id');

  //   if (userId == null) return null;

  //   final db = await _dbHelper.database;
  //   final result = await db.query(
  //     'users',
  //     where: 'id = ?',
  //     whereArgs: [userId],
  //     limit: 1,
  //   );

  //   if (result.isEmpty) return null;

  //   return User.fromMap(result.firs);
  // }
}
