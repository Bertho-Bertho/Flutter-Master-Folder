import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/product_controller.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final Color _primaryColor = const Color(0xFF1E3A8A);

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : _primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // Widget réutilisable pour les champs de texte (Design translucide)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    int lines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // On écoute le status 'isBusy' du controller
    final isBusy = context.watch<ProductController>().isBusy;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Nouveau Produit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(
              controller: _nameController,
              hint: 'Nom du produit',
              icon: Icons.shopping_bag_outlined,
            ),
            _buildTextField(
              controller: _skuController,
              hint: 'Référence SKU (Unique)',
              icon: Icons.qr_code_2_rounded,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _priceController,
                    hint: 'Prix (€)',
                    icon: Icons.euro_symbol_rounded,
                    type: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTextField(
                    controller: _qtyController,
                    hint: 'Quantité',
                    icon: Icons.numbers_rounded,
                    type: TextInputType.number,
                  ),
                ),
              ],
            ),
            _buildTextField(
              controller: _descController,
              hint: 'Description (Optionnel)',
              icon: Icons.notes_rounded,
              lines: 3,
            ),
            const SizedBox(height: 30),

            // BOUTON VALIDER
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isBusy
                    ? null
                    : () async {
                        final error = await context
                            .read<ProductController>()
                            .createNewProduct(
                              name: _nameController.text,
                              sku: _skuController.text,
                              price:
                                  double.tryParse(_priceController.text) ?? -1,
                              quantity: int.tryParse(_qtyController.text) ?? -1,
                              description: _descController.text,
                            );

                        if (error != null) {
                          _showMessage(error, isError: true);
                        } else {
                          _showMessage("Produit ajouté avec succès !");
                          if (mounted) {
                            Navigator.pop(context, {'success': true});
                          }
                        }
                      },
                child: isBusy
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'ENREGISTRER LE PRODUIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
