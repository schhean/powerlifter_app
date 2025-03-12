import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:powerlifter_app/models/programmes.dart';

class DatabaseProgrammes {
  // Singleton de DatabaseRecords
  static final DatabaseProgrammes instance = DatabaseProgrammes._internal();

  static Database? _database;

  // Constructeur privé pour le singleton
  DatabaseProgrammes._internal();

  // Accéder à la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialiser la base de données
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'programmes.db');
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
        CREATE TABLE programme (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          squatPR REAL NOT NULL,
          benchPR REAL NOT NULL,
          deadliftPR REAL NOT NULL
        )
      ''');
        }
    );
  }

  // Récuperer le dernier programme ajouté dans la base de données
  Future<Map<String, dynamic>?> getLastProgram() async {
    final db = await _initDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'programme',
      orderBy: 'id DESC',
      limit: 1, // Récupère uniquement le dernier élément
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // Ajouter un programme
  Future<void> insertProgramme(Programme programme) async {
    final db = await database;
    await db.insert('programme', programme.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Récupérer un programme
  Future<List<Programme>> getProgramme() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('programme');
    return List.generate(maps.length, (i) => Programme.fromMap(maps[i]));
  }

  // Supprimer un programme
  Future<void> deleteProgramme(int id) async {
    final db = await database;
    await db.delete('programme', where: 'id = ?', whereArgs: [id]);
  }

}