import 'package:flutter/material.dart';
import 'package:ufr_mi/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Identification Des Etudiants',
      debugShowCheckedModeBanner: false, // Supprime le bandeau "Debug"
      theme: ThemeData(
        useMaterial3: true, // Active Material 3
        colorSchemeSeed: Colors.blue, // Couleur principale
        brightness: Brightness.light, // Mode clair
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark, // Mode sombre
      ),
      themeMode: ThemeMode.system, // Basé sur les préférences du téléphone
      home: LoginPage(),
      routes: {
        '/login': (context) =>
            LoginPage(), // Ajout de la route pour la connexion
      },
    );
  }
}
