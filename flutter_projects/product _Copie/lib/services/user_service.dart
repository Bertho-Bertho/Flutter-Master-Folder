import 'package:product/database/database_helper.dart';
import 'package:product/models/user.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  //Ajout d'un nouvel utilisateur
  Future<void> addUser(User user) async {
    final db = await _dbHelper.database;
    await db.insert('users', user.toMap());
    print('produit ${user.name}ajouter avec sucess');
  }

  // Mis a jour d'un utilisateur existant
  Future<void> updatedUser(User updatedUser) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      updatedUser.toMap(),
      where: 'id = ?',
      whereArgs: [updatedUser.id],
    );
    print('utilisateur ${updatedUser.name} mis a jour');
  }

  // Suppresion d'un utilisateur
  Future<void> deleteUser(String userId) async {
    final db = await _dbHelper.database;
    await db.delete('users', where: 'id', whereArgs: [userId]);
    print('utilisateur $userId suprimé');
  }

  //Recuperation des toutes les taches [Récupération d'un utilisateur par ID]
  Future<List<User>> getAllUser() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // verifier si un email deja utilise existe deja
  // Dans UserService
  Future<bool> isEmailTaken(String email) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Erreur isEmailTaken: $e');
      return false;
    }
  }

  //  Recherche d'utilisateurs par mot-cle
  Future<List<User>> searchUser(String query) async {
    final db = await _dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'name LIKE ? OR email LIKE ? OR role LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return maps.map((map) => User.fromMap(map)).toList();
  }
}
