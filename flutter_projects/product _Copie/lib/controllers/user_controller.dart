import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:product/models/user.dart';
import 'package:product/services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  // Ajouter une méthode de hachage
  String _hashPassword(String password) {
    // Exemple avec sha256, utilisez la même méthode que pour la vérification
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Ajouter un utilisateur
  Future<void> addUser({
    required String id,
    required String email,
    required String password,
    required String role,
    required String name,
    String? profileImage,
  }) async {
    // Hacher le mot de passe
    //  final db = await database;
    final hashedPassword = _hashPassword(password);

    final user = User(
      id: id,
      email: email.trim().toLowerCase(), // Normaliser l'email
      password: hashedPassword, // Utiliser le mot de passe haché
      role: role,
      name: name,
      profileImage: profileImage,
    );

    // Vérification si l'email existe déjà
    final emailTaken = await _userService.isEmailTaken(email);
    if (emailTaken) {
      throw Exception('Cet email est déjà utilisé');
    }

    // Validation du rôle
    if (role != 'admin' && role != 'caissier') {
      throw Exception('Le rôle doit être "admin" ou "caissier"');
    }

    await _userService.addUser(user);
  }

  // Mettre à jour un utilisateur
  // Méthode de mise à jour d'utilisateur
  Future<void> updateUser({
    required String id,
    required Map<String, dynamic> updateData,
  }) async {
    // 1. Récupérer l'utilisateur actuel depuis la base
    final currentUser = await _getUserById(id);

    // 2. Fusionner les données
    String newEmail = updateData['email'] ?? currentUser.email;
    String newName = updateData['name'] ?? currentUser.name;
    String newRole = updateData['role'] ?? currentUser.role;

    // Gérer le mot de passe
    String newPassword = currentUser.password;
    if (updateData.containsKey('password') &&
        updateData['password'] != null &&
        (updateData['password'] as String).isNotEmpty) {
      newPassword = _hashPassword(updateData['password'] as String);
    }

    // 3. Vérifier si l'email est disponible (si changé)
    if (newEmail != currentUser.email) {
      final emailTaken = await _userService.isEmailTaken(newEmail);
      if (emailTaken) {
        throw Exception('Cet email est déjà utilisé par un autre utilisateur');
      }
    }

    // 4. Valider le rôle
    if (newRole != 'admin' && newRole != 'caissier') {
      throw Exception('Le rôle doit être "admin" ou "caissier"');
    }

    // 5. Créer l'objet utilisateur mis à jour
    final updatedUser = User(
      id: id,
      email: newEmail.trim().toLowerCase(),
      password: newPassword,
      role: newRole,
      name: newName,
      profileImage: currentUser.profileImage, // Conserver l'image existante
    );

    // 6. Mettre à jour dans la base
    await _userService.updatedUser(updatedUser);
  }

  // Méthode helper pour récupérer un utilisateur par ID
  Future<User> _getUserById(String id) async {
    final allUsers = await getAllUsers();
    final user = allUsers.firstWhere(
      (user) => user.id == id,
      orElse: () => throw Exception('Utilisateur non trouvé'),
    );
    return user;
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
  }

  // Récupérer tous les utilisateurs
  Future<List<User>> getAllUsers() async {
    return await _userService.getAllUser();
  }

  // Rechercher des utilisateurs
  Future<List<User>> searchUsers(String query) async {
    if (query.isEmpty) {
      return await getAllUsers();
    }
    return await _userService.searchUser(query);
  }

  // Vérifier si l'email existe
  Future<bool> isEmailAvailable(String email) async {
    return !(await _userService.isEmailTaken(email));
  }

  // Filtrer les utilisateurs par rôle
  Future<List<User>> getUsersByRole(String role) async {
    final allUsers = await getAllUsers();
    return allUsers.where((user) => user.role == role).toList();
  }
}
