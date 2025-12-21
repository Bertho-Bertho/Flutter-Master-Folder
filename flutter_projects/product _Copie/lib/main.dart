import 'package:flutter/material.dart';
import 'package:product/controllers/product_controller.dart'; // 2. Importez votre contrôleur
import 'package:product/views/common/AppInitializer_widget.dart';
import 'package:product/views/user/SplashScreen_view.dart';
import 'package:provider/provider.dart'; // 1. Importez le package provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // 3. Enveloppez l'application avec le Provider
    ChangeNotifierProvider(
      create: (_) => ProductController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optionnel : enlève la bannière debug
      title: 'Gestion de Produits',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Recommandé pour les designs modernes
      ),
      home: AppInitializer(child: const SplashScreen()),
    );
  }
}
