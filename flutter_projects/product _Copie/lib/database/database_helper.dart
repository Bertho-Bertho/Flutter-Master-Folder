import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Getter pour recupere l'intance de la base de donnee

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // initialisation de l'instance de la base de donnee
  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'product.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Méthode pour hacher un mot de passe
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convertir en bytes
    var digest = sha256.convert(bytes); // Hasher avec SHA-256
    return digest.toString(); // Retourner le hash en string
  }

  // creation de la base de donnee
  Future<void> _onCreate(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,         -- Identifiant unique pour chaque utilisateur
        email TEXT NOT NULL UNIQUE,  -- Email unique pour la connexion
        password TEXT NOT NULL,      -- Mot de passe de l'utilisateur (hashé)
        role TEXT NOT NULL CHECK (role IN ('admin', 'caissier')), -- Rôle limité
        name TEXT NOT NULL,          -- Nom complet
        profileImage TEXT            -- Chemin vers l'image (optionnel)
      );
      ''');

    // Table des produits
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,         -- Identifiant unique pour chaque produit
        sku TEXT NOT NULL UNIQUE,                      -- Code produit unique (Stock Keeping Unit) pour référence interne
        name TEXT NOT NULL,                            -- Nom commercial du produit
        price REAL NOT NULL CHECK (price >= 0),        -- Prix de vente (doit être positif ou zéro)
        quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0), -- Quantité disponible en stock (valeur par défaut 0, toujours positive)
        description TEXT                               -- Description optionnelle du produit (peut être NULL)
      )
    ''');

    // Table des ventes (entête)
    await db.execute('''
      CREATE TABLE sales (
       id TEXT PRIMARY KEY,         -- Identifiant unique pour chaque transaction de vente
        date TEXT NOT NULL DEFAULT (datetime('now', 'localtime')), -- Date et heure de la vente (format ISO, valeur par défaut = maintenant)
        total REAL NOT NULL CHECK (total >= 0)         -- Montant total de la vente (doit être positif ou zéro)
      )
    ''');

    // Table des détails de vente (lignes de vente)
    await db.execute('''
      CREATE TABLE sale_items (
       id TEXT PRIMARY KEY,         -- Identifiant unique pour chaque ligne de vente
        sale_id INTEGER NOT NULL,                      -- Référence à l'ID de la vente parente (clé étrangère)
        product_id INTEGER NOT NULL,                   -- Référence à l'ID du produit vendu (clé étrangère)
        qty INTEGER NOT NULL CHECK (qty > 0),          -- Quantité vendue (doit être strictement positive)
        price REAL NOT NULL CHECK (price >= 0),        -- Prix unitaire au moment de la vente (historique des prix)
        FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,
        -- Si une vente est supprimée, tous ses détails sont automatiquement supprimés (cascade)
        FOREIGN KEY (product_id) REFERENCES products(id)
        -- Référence au produit dans la table products, empêche la suppression d'un produit référencé
      )
    ''');

    print("Base de données et tables créées avec succès!");

    await _createAdminUser(db);

    print("Base créée et admin ajouté !");
  }

  // Méthode pour créer l'utilisateur admin
  Future<void> _createAdminUser(Database db) async {
    try {
      // Vérifier d'abord si l'admin existe déjà
      List<Map<String, dynamic>> existingAdmin = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: ['admin@local.com'],
      );

      // Si l'admin n'existe pas, le créer
      if (existingAdmin.isEmpty) {
        String hashedPassword = _hashPassword(
          '@admin123',
        ); // Hash du mot de passe

        await db.insert(
          'users',
          {
            'id': 'admin-id-001', // id obligatoire
            'email': 'admin@local.com', // Connexion via email
            'password': hashedPassword, // Mot de passe hashé
            'role': 'admin', // Rôle pour accès total
            'name': 'Administrateur', // Nom affiché
            'profileImage': null, // Optionnel
          },
          conflictAlgorithm: ConflictAlgorithm.ignore, // Ignorer si doublon
        );

        print("Utilisateur admin créé avec succès!");
      } else {
        print("L'utilisateur admin existe déjà");
      }
    } catch (e) {
      print("Erreur lors de la création de l'admin: $e");
    }
  }

  Future<void> printAdminInfo() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: ['admin@local.com'],
    );
    print("Admin en base: $result");

    // Afficher le hash du mot de passe pour vérifier
    final hashedPassword = sha256.convert(utf8.encode('@admin123')).toString();
    print("Hash de '@admin123': $hashedPassword");
  }

  // Fermeture de la connexion a la base de donnee
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database!;
    }
  }
}
