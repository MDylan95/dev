import 'package:flutter/material.dart';
import 'package:ufr_mi/register_student_page.dart';
import 'package:ufr_mi/database.dart'; // Import du DatabaseHelper

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Map<String, dynamic>> etudiant = [];

  @override
  void initState() {
    super.initState();
    _loadStudents(); // Charge les étudiants au démarrage
  }

  Future<void> _loadStudents() async {
    List<Map<String, dynamic>> students = await DatabaseHelper.fetchEtudiants();
    setState(() {
      etudiant = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des étudiants')),
      body: ListView.builder(
        itemCount: etudiant.length,
        itemBuilder: (context, index) {
          final student = etudiant[index];
          return ListTile(
            title: Text('${student['nom']} ${student['prenom']}'),
            subtitle: Text('Matricule: ${student['matricule']}\n'
                'Email: ${student['email']}\n'
                'Téléphone: ${student['telephone']}'),
            isThreeLine: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterStudentPage()),
          ).then((_) {
            _loadStudents(); // Recharge la liste après inscription
          });
        },
      ),
    );
  }
}
