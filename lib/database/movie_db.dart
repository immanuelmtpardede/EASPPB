import 'package:sqflite/sqflite.dart';
import '../database/db_service.dart';
import '../model/movie_model.dart';

class MovieDB {
  final tableName = 'movies';

  Future<void> createTable(Database database) async{
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER NOT NULL,
      "title" TEXT NOT NULL,
      "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
      "description" TEXT NOT NULL,
      "image" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    """);
  }

  Future<int> create({required String title, required String description, required String image}) async {
    final database = await DBService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (title, created_at, description, image) VALUES (?,?,?,?)''',
      [title, DateTime.now().millisecondsSinceEpoch, description, image],
    );
  }

  Future<List<Movie>> fetchAll() async {
    final database = await DBService().database;
    final movies = await database.rawQuery(
        '''SELECT * from $tableName ORDER BY COALESCE(updated_at, created_at)'''
    );
    return movies.map((todo) => Movie.fromSqfliteDatabase(todo)).toList();
  }

  Future<Movie> fetchById(int id) async {
    final database = await DBService().database;
    final movie = await database.rawQuery(
        '''SELECT * from $tableName WHERE id = ?''', [id]
    );
    return Movie.fromSqfliteDatabase(movie.first);
  }

  Future<int> update({required int id, String? title, String? description, String? image}) async {
    final database = await DBService().database;
    return await database.update(
      tableName,
      {
        if (title != null) 'title': title,
        if (description != null) 'title': description,
        if (image != null) 'title': image,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DBService().database;
    await database.rawDelete(
        '''DELETE FROM $tableName WHERE id = ?''', [id]
    );
  }
}