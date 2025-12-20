import 'package:flutter/material.dart';
import 'package:product/controllers/user_controller.dart';

class EditUserForm extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditUserForm({super.key, required this.userData});

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final UserController _userController = UserController();

  bool _isLoading = false;
  String? _selectedRole;
  bool _changePassword = false;

  final Color _primaryColor = const Color(0xFF1E3A8A);

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userData['email'] ?? '';
    _nameController.text = widget.userData['name'] ?? '';
    _selectedRole = widget.userData['role'];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Style des champs de saisie
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white, size: 20),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), // Taille réduite
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Modifier le profil",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // EMAIL
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle('Email', Icons.email_outlined),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Email requis" : null,
                ),
                const SizedBox(height: 16),

                // NOM COMPLET
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputStyle('Nom complet', Icons.person_outline),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Nom requis" : null,
                ),
                const SizedBox(height: 16),

                // RÔLE (DROPDOWN SIMPLIFIÉ ET CENTRÉ)
                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  dropdownColor: const Color(0xFF1A1A1A),
                  icon: const Icon(
                    Icons.expand_more_rounded,
                    color: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  isExpanded: true, // Pour bien utiliser l'espace
                  decoration: _inputStyle('Rôle', Icons.verified_user_outlined),
                  items: const [
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrateur'),
                    ),
                    DropdownMenuItem(
                      value: 'caissier',
                      child: Text('Caissier'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) => v == null ? "Rôle requis" : null,
                ),

                const SizedBox(height: 24),

                // SECTION MOT DE PASSE
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text(
                          'Changer le mot de passe',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        value: _changePassword,
                        activeColor: _primaryColor,
                        onChanged: (val) => setState(() {
                          _changePassword = val ?? false;
                          if (!_changePassword) _passwordController.clear();
                        }),
                      ),
                      if (_changePassword)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputStyle(
                              'Nouveau mot de passe',
                              Icons.lock_reset,
                            ),
                            validator: (v) =>
                                (_changePassword && (v == null || v.length < 6))
                                ? "6 car. min"
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // BOUTONS
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'ANNULER',
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _updateUser,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'METTRE À JOUR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        Map<String, dynamic> updateData = {
          'email': _emailController.text.trim().toLowerCase(),
          'name': _nameController.text.trim(),
          'role': _selectedRole!,
        };
        if (_changePassword && _passwordController.text.isNotEmpty) {
          updateData['password'] = _passwordController.text;
        }
        await _userController.updateUser(
          id: widget.userData['id'],
          updateData: updateData,
        );
        Navigator.pop(context, {
          'success': true,
          'message': 'Utilisateur modifié',
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
