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

  static Future<List<Map<String, dynamic>>> fetchEtudiants() async {
    final conn = await _getConnection();
    var results = await conn.query(
        'SELECT nom, prenom, genre, date_de_naissance, lieu_de_naissance, matricule, email, telephone FROM etudiant');

    List<Map<String, dynamic>> etudiant = results.map((row) {
      return {
        'nom': row[0],
        'prenom': row[1],
        'genre': row[2],
        'date_de_naissance': row[3],
        'lieu_de_naissance': row[4],
        'matricule': row[5],
        'email': row[6],
        'telephone': row[7],
      };
    }).toList();

    await conn.close();
    return etudiant;
  }

  static Future<void> registerStudent(
      String nom,
      String prenom,
      String genre,
      String date_de_naissance,
      String lieu_de_naissance,
      String matricule,
      String email,
      String telephone) async {
    final conn = await _getConnection();
    await conn.query(
        'INSERT INTO etudiant (nom, prenom, genre, date_de_naissance, lieu_de_naissance, matricule, email, telephone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          nom,
          prenom,
          genre,
          date_de_naissance,
          lieu_de_naissance,
          matricule,
          email,
          telephone
        ]);
    await conn.close();
  }

  static Future<int> updateStudent(
    int id,
    String nom,
    String prenom,
    int genre,
    String date_de_naissance,
    String lieu_de_naissance,
    String matricule,
    String email,
    String telephone,
  ) async {
    final conn = await _getConnection();
    try {
      var result = await conn.query(
          'UPDATE etudiant SET nom = ?, prenom = ?, genre = ?, date_de_naissance = ?, lieu_de_naissance = ?, matricule = ?, email = ?, telephone = ? WHERE id = ?',
          [
            nom,
            prenom,
            genre,
            date_de_naissance,
            lieu_de_naissance,
            matricule,
            email,
            telephone,
            id
          ]);
      return result.affectedRows ?? 0;
    } catch (e) {
      return 0; // Handle any errors
    } finally {
      await conn.close();
    }
  }

  static Future<void> deleteStudent(int id) async {
    final conn = await _getConnection();
    await conn.query('DELETE FROM etudiant WHERE id = ?', [id]);
    await conn.close();
  }
}
