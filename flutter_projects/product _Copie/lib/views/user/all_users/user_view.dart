import 'package:flutter/material.dart';
import 'package:product/controllers/user_controller.dart';
import 'package:product/models/user.dart';
import 'package:product/views/user/all_users/user_edit.dart';

import 'user_form.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final UserController _userController = UserController();
  List<User> _users = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final Color _primaryColor = const Color(0xFF1E3A8A);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _userController.getAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Erreur: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildUserItem(User user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Fond sombre translucide
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${user.email}\nRole: ${user.role}',
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // BOUTON ÉDITER
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white70),
              onPressed: () async {
                final userData = {
                  'id': user.id,
                  'email': user.email,
                  'name': user.name,
                  'role': user.role,
                };

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserForm(userData: userData),
                  ),
                );

                if (result != null && result['success'] == true) {
                  _loadUsers();
                }
              },
            ),
            // BOUTON SUPPRIMER
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () => _confirmDelete(user),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Supprimer ?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Voulez-vous supprimer ${user.name} ?',
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
      try {
        await _userController.deleteUser(user.id);
        _loadUsers();
        _showMessage('${user.name} supprimé');
      } catch (e) {
        _showMessage('Erreur: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fond noir cohérent
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Utilisateurs',
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
                hintText: 'Rechercher un membre...',
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: _primaryColor))
                : _users.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun utilisateur',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) =>
                        _buildUserItem(_users[index]),
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
            MaterialPageRoute(builder: (context) => UserForm()),
          );
          if (result != null && result['success'] == true) _loadUsers();
        },
      ),
    );
  }
}
