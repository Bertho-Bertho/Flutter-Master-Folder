import 'package:flutter/material.dart';
import 'package:product/views/common/AppInitializer_widget.dart';
import 'package:product/views/user/SplashScreen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Produits',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AppInitializer(child: SplashScreen()),
    );
  }
}
