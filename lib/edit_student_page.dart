import 'package:flutter/material.dart';
import 'package:ufr_mi/database.dart';

class EditStudentPage extends StatefulWidget {
  final Map<String, dynamic> etudiant;

  EditStudentPage({required this.etudiant});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late int _genre;
  late DateTime _selectedDate;
  late TextEditingController _lieuNaissanceController;
  late TextEditingController _matriculeController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.etudiant['nom']);
    _prenomController = TextEditingController(text: widget.etudiant['prenom']);
    _genre = widget.etudiant['genre'] ?? 0;
    _selectedDate = DateTime.tryParse(widget.etudiant['date_de_naissance']) ??
        DateTime.now();
    _lieuNaissanceController =
        TextEditingController(text: widget.etudiant['lieu_de_naissance']);
    _matriculeController =
        TextEditingController(text: widget.etudiant['matricule']);
    _emailController = TextEditingController(text: widget.etudiant['email']);
    _telephoneController =
        TextEditingController(text: widget.etudiant['telephone']);
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await DatabaseHelper.updateStudent(
          widget.etudiant['id'],
          _nomController.text.trim(),
          _prenomController.text.trim(),
          _genre,
          _selectedDate.toString(),
          _lieuNaissanceController.text.trim(),
          _matriculeController.text.trim(),
          _emailController.text.trim(),
          _telephoneController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Étudiant mis à jour avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, {
            'nom': _nomController.text.trim(),
            'prenom': _prenomController.text.trim(),
            'genre': _genre,
            'date_de_naissance': _selectedDate.toString(),
            'lieu_de_naissance': _lieuNaissanceController.text.trim(),
            'matricule': _matriculeController.text.trim(),
            'email': _emailController.text.trim(),
            'telephone': _telephoneController.text.trim(),
          });
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'étudiant',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nomController, "Nom", Icons.person),
              _buildTextField(
                  _prenomController, "Prénom", Icons.person_outline),
              _buildDropdownField(),
              _buildDatePickerField(),
              _buildTextField(_lieuNaissanceController, "Lieu de naissance",
                  Icons.location_city),
              _buildTextField(_matriculeController, "Matricule", Icons.badge),
              _buildTextField(_emailController, "Email", Icons.email,
                  TextInputType.emailAddress),
              _buildTextField(_telephoneController, "Téléphone", Icons.phone,
                  TextInputType.phone),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _updateStudent,
                    icon: Icon(Icons.save),
                    label: Text('Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text("Annuler", style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: keyboardType,
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Veuillez entrer $label'
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<int>(
        value: _genre,
        items: [
          DropdownMenuItem(value: 0, child: Text("Féminin")),
          DropdownMenuItem(value: 1, child: Text("Masculin")),
        ],
        onChanged: (value) => setState(() => _genre = value!),
        decoration: InputDecoration(
          labelText: "Genre",
          prefixIcon: Icon(Icons.wc, color: Colors.blueAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: _buildTextField(
            TextEditingController(
                text:
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
            "Date de naissance",
            Icons.calendar_today,
            TextInputType.datetime,
          ),
        ),
      ),
    );
  }
}
