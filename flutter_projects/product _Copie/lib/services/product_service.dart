// import 'package:product/database/database_helper.dart';

// import '../models/product.dart';

// class ProductController {
//   static final ProductController _instance = ProductController._internal();
//   factory ProductController() => _instance;
//   ProductController._internal();

//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   //Ajout d'un nouvel Produit
//   Future<void> addProduct(Product product) async {
//     final db = await _dbHelper.database;
//     await db.insert('products', product.toMap());
//     print('produit ${product.name}ajouter avec sucess');
//   }

//   // Mis a jour d'un produit existant
//   Future<void> updatedProduct(Product updatedProduct) async {
//     final db = await _dbHelper.database;
//     await db.update(
//       'products',
//       updatedProduct.toMap(),
//       where: 'id = ?',
//       whereArgs: [updatedProduct.id],
//     );
//     print('produit ${updatedProduct.name} mis a jour');
//   }

//   // Suppresion d'un produit
//   Future<void> deleteProduct(String productId) async {
//     final db = await _dbHelper.database;
//     await db.delete('products', where: 'id', whereArgs: [productId]);
//     print('produit $productId suprime');
//   }

//   //Recuperation de tous les sproduits
//   Future<List<Product>> getAllProducts() async {
//     final db = await _dbHelper.database;

//     final List<Map<String, dynamic>> maps = await db.query(
//       'products',
//       orderBy: 'name ASC',
//     );

//     return List.generate(maps.length, (i) {
//       return Product.fromMap(maps[i]);
//     });
//   }

//   //recuperation complete des Produits [Produits EN RUPTURE de stock (quantity = 0)]
//   Future<List<Product>> getOutOfStockProducts() async {
//     final db = await _dbHelper.database;

//     final List<Map<String, dynamic>> maps = await db.query(
//       'products',
//       where: 'quantity = ?',
//       whereArgs: [0],
//     );

//     return maps.map((map) => Product.fromMap(map)).toList();
//   }

//   // Recupation des Produits en cours [Produits disponibles (quantity > 0)]
//   Future<List<Product>> getAvailableProducts() async {
//     final db = await _dbHelper.database;

//     final List<Map<String, dynamic>> maps = await db.query(
//       'products',
//       where: 'quantity > ?',
//       whereArgs: [0],
//       orderBy: 'name ASC',
//     );

//     return maps.map((map) => Product.fromMap(map)).toList();
//   }

//   //recuperation des produits en retars [Produits en faible stock]
//   Future<List<Product>> getLowStockProducts(int threshold) async {
//     final db = await _dbHelper.database;

//     final List<Map<String, dynamic>> maps = await db.query(
//       'products',
//       where: 'quantity < ?',
//       whereArgs: [threshold], // exemple threshold = 5
//     );

//     return maps.map((map) => Product.fromMap(map)).toList();
//   }

//   // recherche des produits par mot-cle [Recherche des produits par nom, sku ou description]
//   Future<List<Product>> searchProducts(String query) async {
//     final db = await _dbHelper.database;

//     final List<Map<String, dynamic>> maps = await db.query(
//       'products',
//       where: 'name LIKE ? OR sku LIKE ? OR description LIKE ?',
//       whereArgs: ['%$query%', '%$query%', '%$query%'],
//     );

//     return maps.map((map) => Product.fromMap(map)).toList();
//   }
// }
