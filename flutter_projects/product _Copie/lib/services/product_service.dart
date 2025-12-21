import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class ProductService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // CHARGER LES PRODUITS
  Future<List<Product>> getAllProducts() async {
    final db = await _dbHelper.database;

    // On fait la requête SQL
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'name ASC',
    );

    // On transforme les Map en objets Product (grâce à votre factory fromMap)
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // INSERTION
  Future<void> saveProduct(Product product) async {
    final db = await _dbHelper.database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // MISE À JOUR
  Future<void> UpdatedProduct(Product updatedProduct) async {
    final db = await _dbHelper.database;
    await db.update(
      'products',
      updatedProduct.toMap(),
      where: 'id = ?',
      whereArgs: [updatedProduct.id],
    );
  }

  // SUPPRESSION
  Future<void> deleteProduct(String id) async {
    final db = await _dbHelper.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
