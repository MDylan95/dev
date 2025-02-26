import 'package:flutter/material.dart';
import 'package:ufr_mi/database.dart';
import 'package:ufr_mi/student_list_page.dart';

// Page de connexion
class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true, // Masque le mot de passe
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Se connecter'),
              onPressed: () async {
                // Vérification des identifiants de l'utilisateur
                bool authenticated = await DatabaseHelper.authenticateUser(
                    usernameController.text, passwordController.text);
                if (authenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentListPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Identifiants incorrects')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
