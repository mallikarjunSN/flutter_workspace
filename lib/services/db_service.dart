import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello/model/words_model.dart';
import 'package:hello/services/other_services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final ExerciseDatabase _db = ExerciseDatabase.instance;

  Future<List<ReadingWord>> getReadingWordsByLevel(String level) async {
    List<Map<String, dynamic>> data = await _db.read("readingWords", level);

    List<ReadingWord> rWords = [];

    if (data.length == 0) {
      await populateReadingWords().then((value) async {
        data = await _db.read("readingWords", level);
      });
    }
    data.forEach((element) {
      rWords.add(ReadingWord.fromJsom(element));
    });

    return rWords;
  }

  Future<void> deleteReadingWords() async {
    await _db.delete("readingWords");
  }

  Future<void> populateReadingWords() async {
    QuerySnapshot snapshot = await OtherServices().getAllReadingWords();

    for (var doc in snapshot.docs) {
      await _db.insert("readingWords", doc.data());
    }
  }

  Future<void> populate() async {}
}

class ExerciseDatabase {
  static Database _database;
  static final instance = ExerciseDatabase._init();

  ExerciseDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB('exercise.db');
    return _database;
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

  Future<void> close() async {
    _database = await instance.database;
    await _database.close();
  }

  //Create of CRUD
  Future<void> _createDB(Database db, int version) async {
    //create reading exercise table
    await db.execute("""
    CREATE TABLE readingWords(
      word TEXT PRIMARY KEY NOT NULL,
      level TEXT NOT NULL,
      syllables TEXT NOT NULL,
      syllablesPron TEXT NOT NULL,
      lastAccuracy REAL DEFAULT 0.0,
      lastAttemptOn TEXT
    );
    """);

    //create typing exercise table
    await db.execute("""
    CREATE TABLE typingWords(
      word TEXT PxRIMARY KEY NOT NULL,
      level TEXT NOT NULL,
      lastAccuracy REAL DEFAULT 0.0,
      lastAttemptOn TEXT
    );
    """);
  }

  //Create 2 of CRUD
  Future<void> insert(String table, Map<String, dynamic> data) async {
    _database = await instance.database;
    int res = await _database.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Read of CRUD
  Future<List<Map<String, dynamic>>> read(String table, String level) async {
    _database = await instance.database;
    return await _database.query(table, where: "level = ?", whereArgs: [level]);
  }

  //Update of CRUD
  Future<void> update(String table, Map<String, dynamic> data) async {
    _database = await instance.database;
    int res = await _database
        .update(table, data, where: "word = ?", whereArgs: [data["word"]]);
    print("db update  $res");
  }

  Future<void> delete(String table) async {
    _database = await instance.database;
    int count = await _database.delete(table);

    print("$count rows deleted");
  }
}