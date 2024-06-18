import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class MovieRepository {
  static final MovieRepository _instance = MovieRepository._internal();
  static Database? _database;

  MovieRepository._internal();

  factory MovieRepository() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE movies(id INTEGER PRIMARY KEY, title TEXT, created_at TEXT, picture TEXT, description TEXT)',
        );
      },
    );
  }

  Future<void> insertMovie(Movie movie) async {
    final db = await database;
    await db.insert('movies', movie.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');

    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

  Future<void> updateMovie(Movie movie) async {
    final db = await database;
    await db.update('movies', movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}