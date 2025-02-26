import 'package:flutter/material.dart';
import 'package:ufr_mi/database.dart'; // Assure-toi que le chemin est correct

class RegisterStudentPage extends StatefulWidget {
  @override
  _RegisterStudentPageState createState() => _RegisterStudentPageState();
}

class _RegisterStudentPageState extends State<RegisterStudentPage> {
  final _formKey =
      GlobalKey<FormState>(); // Clé pour la validation du formulaire

  // Contrôleurs pour récupérer les valeurs saisies
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();
  final TextEditingController _lieuNaissanceController =
      TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  Future<void> _registerStudent() async {
    if (_formKey.currentState!.validate()) {
      String nom = _nomController.text.trim();
      String prenom = _prenomController.text.trim();
      String date_de_naissance = _dateNaissanceController.text.trim();
      String lieu_de_naissance = _lieuNaissanceController.text.trim();
      String matricule = _matriculeController.text.trim();
      String email = _emailController.text.trim();
      String telephone = _telephoneController.text.trim();

      try {
        await DatabaseHelper.registerStudent(
          nom,
          prenom,
          date_de_naissance,
          lieu_de_naissance,
          matricule,
          email,
          telephone,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Étudiant inscrit avec succès !')),
        );

        Navigator.pop(
            context); // Retour à la page précédente après l'inscription
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription Étudiant')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_nomController, "Nom"),
              _buildTextField(_prenomController, "Prenom"),
              _buildTextField(_dateNaissanceController, "Date de naissance"),
              _buildTextField(_lieuNaissanceController, "Lieu de naissance"),
              _buildTextField(_matriculeController, "Matricule"),
              _buildTextField(
                  _emailController, "Email", TextInputType.emailAddress),
              _buildTextField(
                  _telephoneController, "Téléphone", TextInputType.phone),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _registerStudent,
                  child: Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction utilitaire pour construire un champ de texte
  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Veuillez entrer $label';
          }
          return null;
        },
      ),
    );
  }
}
