import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static Future<MySqlConnection> _getConnection() async {
    final settings = ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      db: 'urf_mi',
    );
    return await MySqlConnection.connect(settings);
  }

  static Future<bool> authenticateUser(String username, String password) async {
    final conn = await _getConnection();
    var results = await conn.query(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [username, password]);
    await conn.close();
    return results.isNotEmpty;
  }

  // ✅ Correction : fetchStudents retourne une List<Map<String, dynamic>>
  static Future<List<Map<String, dynamic>>> fetchEtudiants() async {
    final conn = await _getConnection();
    var results = await conn.query(
        'SELECT nom, prenom, date_de_naissance, lieu_de_naissance, matricule, email, telephone FROM etudiant');

    List<Map<String, dynamic>> etudiant = results.map((row) {
      return {
        'nom': row[0],
        'prenom': row[1],
        'date_de_naissance': row[2],
        'lieu_de_naissance': row[3],
        'matricule': row[4],
        'email': row[5],
        'telephone': row[6],
      };
    }).toList();

    await conn.close();
    return etudiant;
  }

  static Future<void> registerStudent(
      String nom,
      String prenom,
      String date_de_naissance,
      String lieu_de_naissance,
      String matricule,
      String email,
      String telephone) async {
    final conn = await _getConnection();
    await conn.query(
        'INSERT INTO etudiant (nom, prenom, date_de_naissance, lieu_de_naissance, matricule, email, telephone) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          nom,
          prenom,
          date_de_naissance,
          lieu_de_naissance,
          matricule,
          email,
          telephone
        ]);
    await conn.close();
  }
}
