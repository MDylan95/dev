import 'package:flutter/material.dart';
import 'package:ufr_mi/register_student_page.dart';
import 'package:ufr_mi/database.dart';
import 'package:ufr_mi/student_detail_page.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Map<String, dynamic>> etudiants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    List<Map<String, dynamic>> students = await DatabaseHelper.fetchEtudiants();
    setState(() {
      etudiants = students;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des étudiants',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : etudiants.isEmpty
              ? Center(
                  child: Text(
                    "Aucun étudiant enregistré",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: etudiants.length,
                  itemBuilder: (context, index) {
                    final student = etudiants[index];
                    IconData genreIcon =
                        student['genre'] == 1 ? Icons.male : Icons.female;
                    Color genreColor =
                        student['genre'] == 1 ? Colors.blue : Colors.pink;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailPage(etudiant: student),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: genreColor,
                            radius: 25,
                            child:
                                Icon(genreIcon, color: Colors.white, size: 30),
                          ),
                          title: Text(
                            '${student['nom']} ${student['prenom']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Matricule: ${student['matricule']}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterStudentPage()),
          ).then((_) {
            _loadStudents();
          });
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Déconnexion",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Voulez-vous vraiment vous déconnecter ?"),
          actions: [
            TextButton(
              child:
                  Text("Annuler", style: TextStyle(color: Colors.blueAccent)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Déconnexion", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
