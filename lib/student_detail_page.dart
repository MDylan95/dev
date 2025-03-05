import 'package:flutter/material.dart';
import 'edit_student_page.dart';
import 'package:ufr_mi/database.dart'; // Assurez-vous que la base de données est bien importée

class StudentDetailPage extends StatefulWidget {
  final Map<String, dynamic> etudiant;

  StudentDetailPage({required this.etudiant});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  late Map<String, dynamic> etudiant;

  @override
  void initState() {
    super.initState();
    etudiant = widget.etudiant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${etudiant['nom']} ${etudiant['prenom']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.person, 'Nom', etudiant['nom']),
                _buildDetailRow(
                    Icons.person_outline, 'Prénom', etudiant['prenom']),
                _buildDetailRow(
                    Icons.badge, 'Matricule', etudiant['matricule']),
                _buildDetailRow(Icons.email, 'Email', etudiant['email']),
                _buildDetailRow(
                    Icons.phone, 'Téléphone', etudiant['telephone']),
                _buildDetailRow(Icons.cake, 'Date de naissance',
                    _formatDate(etudiant['date_de_naissance'])),
                _buildDetailRow(Icons.location_city, 'Lieu de naissance',
                    etudiant['lieu_de_naissance']),
                _buildDetailRow(Icons.wc, 'Civilité',
                    etudiant['genre'] == 1 ? 'Masculin' : 'Féminin'),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Retour à la liste'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "edit",
            child: Icon(Icons.edit, color: Colors.white),
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              final updatedStudent = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentPage(etudiant: etudiant),
                ),
              );
              if (updatedStudent != null) {
                setState(() {
                  etudiant = updatedStudent;
                });
              }
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "delete",
            icon: Icon(Icons.delete, color: Colors.white),
            label: Text("Supprimer"),
            backgroundColor: Colors.red,
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: '$label : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return "Non renseigné";
    try {
      if (date is String) {
        if (date.contains('/')) return date;
        DateTime parsedDate = DateTime.parse(date);
        return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
      }
      if (date is DateTime) {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      print("Erreur de formatage de la date: $e");
    }
    return "Non renseigné";
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmer la suppression"),
          content: Text("Voulez-vous vraiment supprimer cet étudiant ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Annuler", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteStudent();
              },
              child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteStudent() async {
    try {
      await DatabaseHelper.deleteStudent(etudiant['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Étudiant supprimé avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, {'deleted': true});
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
