import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'movie_db.dart';

class DBService{
  Database? _database;

  Future<Database> get database async {
    if (_database != null){
      return _database!;
    } else {
      _database = await _initialize();
      return _database!;
    }
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<String> get fullPath async {
    const name = 'easppb.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<void> create(Database database, int version) async => await MovieDB().createTable(database);
}