import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tcg.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deckId INTEGER,
        name TEXT NOT NULL,
        description TEXT,
        rarity TEXT,
        quantity INTEGER,
        imagePath TEXT,
        FOREIGN KEY(deckId) REFERENCES decks(id) ON DELETE CASCADE
      )
    ''');
  }

  // ===== Deck Queries =====
  Future<int> insertDeck(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('decks', row);
  }

  Future<List<Map<String, dynamic>>> getDecks() async {
    final db = await database;
    return await db.query('decks');
  }

  Future<int> deleteDeck(int id) async {
    final db = await database;
    return await db.delete('decks', where: 'id = ?', whereArgs: [id]);
  }

  // ===== Card Queries =====
  Future<int> insertCard(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('cards', row);
  }

  Future<List<Map<String, dynamic>>> getCards(int deckId) async {
    final db = await database;
    return await db.query('cards', where: 'deckId = ?', whereArgs: [deckId]);
  }

  Future<int> updateCard(Map<String, dynamic> row, int id) async {
    final db = await database;
    return await db.update('cards', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCard(int id) async {
    final db = await database;
    return await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }
}