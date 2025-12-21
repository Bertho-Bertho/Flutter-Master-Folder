import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _service = ProductService();

  // État privé
  List<Product> _products = [];
  bool _isBusy = false;

  // Getters pour l'UI
  List<Product> get products => _products;
  bool get isBusy => _isBusy;

  // 1. CHARGER LES PRODUITS
  Future<void> loadProducts() async {
    _isBusy = true;
    notifyListeners();
    try {
      _products = await _service.getAllProducts();
    } catch (e) {
      print("Erreur chargement: $e");
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  // 2. CRÉATION (Votre méthode déjà bien écrite)
  Future<String?> createNewProduct({
    required String name,
    required String sku,
    required double price,
    required int quantity,
    String? description,
  }) async {
    if (name.trim().isEmpty) return "Le nom est requis.";
    if (sku.trim().isEmpty) return "Le SKU est obligatoire.";
    if (price <= 0) return "Le prix doit être supérieur à zéro.";
    if (quantity < 0) return "Le stock ne peut pas être négatif.";

    _isBusy = true;
    notifyListeners();

    try {
      final newProduct = Product(
        id: const Uuid().v4(),
        name: name.trim(),
        sku: sku.trim().toUpperCase(),
        price: price,
        quantity: quantity,
        description: description ?? "",
      );

      await _service.saveProduct(newProduct);
      await loadProducts(); // Rafraîchit la liste locale après ajout
      return null;
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return "Ce code SKU est déjà utilisé.";
      }
      return "Erreur système : $e";
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  // 3. MISE À JOUR (Indispensable pour modifier le stock ou le prix)
  Future<String?> UpdatedProduct(Product updatedProduct) async {
    _isBusy = true;
    notifyListeners();
    try {
      await _service.UpdatedProduct(updatedProduct);
      await loadProducts(); // Rafraîchit la liste
      return null;
    } catch (e) {
      return "Erreur lors de la mise à jour: $e";
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  // 4. SUPPRESSION
  Future<bool> removeProduct(String id) async {
    try {
      await _service.deleteProduct(id);
      _products.removeWhere(
        (p) => p.id == id,
      ); // Optimisation : enlève direct de la liste
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
