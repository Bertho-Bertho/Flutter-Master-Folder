import 'package:flutter/material.dart';
import 'package:product/views/product/edit_product_form.dart';
import 'package:product/views/product/product_form.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_controller.dart';
import '../../models/product.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _searchController = TextEditingController();
  final Color _primaryColor = const Color(0xFF1E3A8A);

  @override
  void initState() {
    super.initState();
    // Charger les produits au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- WIDGET ITEM PRODUIT (STYLE USER ITEM) ---
  Widget _buildProductItem(Product product) {
    final controller = context.read<ProductController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Icon(
              Icons.inventory_2_rounded,
              color: Color(0xFF1E3A8A),
              size: 28,
            ),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'SKU: ${product.sku}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            Text(
              'Stock: ${product.quantity} | ${product.price} €',
              style: TextStyle(
                color: product.quantity < 5
                    ? Colors.orangeAccent
                    : Colors.greenAccent,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // BOUTON ÉDITER (À implémenter si besoin)
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white70),
              onPressed: () async {
                // 1. Préparer les données sous forme de Map (exactement comme pour User)
                final productData = {
                  'id': product.id,
                  'name': product.name,
                  'sku': product.sku,
                  'price': product.price,
                  'quantity': product.quantity,
                  'description': product.description,
                };

                // 2. Naviguer vers le formulaire d'édition
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductForm(
                      productData: productData, // On ne passe QUE la Map
                    ),
                  ),
                );

                // 3. Recharger la liste si la modification a réussi
                if (result != null && result['success'] == true) {
                  // Si vous utilisez la méthode du controller :
                  context.read<ProductController>().loadProducts();
                  // Ou si vous avez une méthode locale : _loadProducts();
                }
              },
            ),
            // BOUTON SUPPRIMER
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () => _confirmDelete(product),
            ),
          ],
        ),
      ),
    );
  }

  // --- DIALOGUE DE CONFIRMATION ---
  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Supprimer ?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Voulez-vous supprimer ${product.name} ?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await context.read<ProductController>().removeProduct(
        product.id,
      );
      if (success) {
        _showMessage('Produit supprimé');
      } else {
        _showMessage('Erreur lors de la suppression', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écoute des changements dans le controller
    final controller = context.watch<ProductController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Stock Produits',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // CHAMP DE RECHERCHE DESIGN
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: controller.isBusy
                ? Center(child: CircularProgressIndicator(color: _primaryColor))
                : controller.products.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun produit en stock',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) =>
                        _buildProductItem(controller.products[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductForm()),
          );
          // Si le produit a été ajouté, le controller a déjà notifié les changements
          // La liste se mettra à jour toute seule grâce au notifyListeners() du controller
        },
      ),
    );
  }
}
