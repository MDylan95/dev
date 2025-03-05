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
  final TextEditingController _lieuNaissanceController =
      TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  int? _genre; // Stocke 0 pour Féminin et 1 pour Masculin
  DateTime? _selectedDate;

  Future<void> _registerStudent() async {
    if (_formKey.currentState!.validate()) {
      String nom = _nomController.text.trim();
      String prenom = _prenomController.text.trim();
      String date_de_naissance = _selectedDate != null
          ? "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}"
          : ""; // Convertir la date en String (format YYYY-MM-DD)
      String lieu_de_naissance = _lieuNaissanceController.text.trim();
      String matricule = _matriculeController.text.trim();
      String email = _emailController.text.trim();
      String telephone = _telephoneController.text.trim();

      try {
        await DatabaseHelper.registerStudent(
          nom,
          prenom,
          _genre
              .toString(), // Convertit l'entier en String pour la base de données
          _selectedDate.toString(),
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
      appBar: AppBar(
        title: Text('Inscription Étudiant'),
        backgroundColor: Colors.blue,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_nomController, "Nom"),
              _buildTextField(_prenomController, "Prénom"),

              // Dropdown pour choisir le genre
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField<int>(
                  value: _genre,
                  decoration: InputDecoration(
                    labelText: "Civilité",
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
                  ),
                  items: [
                    DropdownMenuItem(value: 1, child: Text("Masculin")),
                    DropdownMenuItem(value: 0, child: Text("Féminin")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _genre = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Sélectionnez une civilité" : null,
                ),
              ),

              _buildDateField(),
              _buildTextField(_lieuNaissanceController, "Lieu de naissance"),
              _buildTextField(_matriculeController, "Matricule"),
              _buildTextField(
                  _emailController, "Email", TextInputType.emailAddress),
              _buildTextField(
                  _telephoneController, "Téléphone", TextInputType.phone),

              SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: _registerStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Changer la couleur du bouton
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5, // Ajout de l'ombre au bouton
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Fonction pour afficher un champ de sélection de date
  Widget _buildDateField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null && pickedDate != _selectedDate) {
            setState(() {
              _selectedDate = pickedDate;
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: "Date de naissance",
            labelStyle:
                TextStyle(color: const Color.fromARGB(255, 68, 138, 255)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
          ),
          child: Text(
            _selectedDate != null
                ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                : "Sélectionner une date",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  // ✅ Fonction générique pour les champs texte
  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        ),
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
