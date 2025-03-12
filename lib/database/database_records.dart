import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:powerlifter_app/models/records.dart';

class DatabaseRecords {
  // Singleton de DatabaseRecords
  static final DatabaseRecords instance = DatabaseRecords._internal();

  static Database? _database;

  // Constructeur privé pour le singleton
  DatabaseRecords._internal();

  // Accéder à la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialiser la base de données
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE record (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          exercice TEXT NOT NULL,
          date TEXT NULL,
          charge REAL NOT NULL,
          commentaire TEXT NOT NULL
        )
      ''');
      }
    );
  }

  // Ajouter un record
  Future<void> insertRecord(Record record) async {
    final db = await database;
    await db.insert('record', record.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Récupérer un record
  Future<List<Record>> getRecord() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('record');
    return List.generate(maps.length, (i) => Record.fromMap(maps[i]));
  }

  // Supprimer un record
  Future<void> deleteRecord(int id) async {
    final db = await database;
    await db.delete('record', where: 'id = ?', whereArgs: [id]);
  }

}