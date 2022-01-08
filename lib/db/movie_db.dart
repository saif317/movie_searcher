import 'dart:io';
import 'dart:async';

import 'package:movie_searcher/db/sql_statments.dart';
import 'package:movie_searcher/models/movie.model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MovieDB {
  static final MovieDB _instance = MovieDB._internal();

  factory MovieDB() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      return await initDB();
    }
  }

  MovieDB._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main.db');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  Future<void> deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main.db');
    return deleteDatabase(path); 
  }

  void _onCreate(Database db, int version) async {
    await db.execute(createMoviesTable);
  }

  Future<List<Movie>> getMovies() async {
    List<Map> res = await (await db)!.query('Movies');
    return res.map((movie) => Movie.fromDB(movie)).toList();
  }

  Future<int> addMovie(Movie movie) async {
    int res = await (await db)!.insert('Movies', movie.toMap());
    return res;
  }

  Future<Movie?> getMovie(String id) async {
    var res =
        await (await db)!.query('Movies', where: 'id = ?', whereArgs: [id]);

    return res.isEmpty ? null : Movie.fromDB(res[0]);
  }

  Future<int> removeMovie(String id) async {
    var res =
        await (await db)!.delete('Movies', where: 'id = ?', whereArgs: [id]);
    print('Movie Deleted $res');
    return res;
  }

  Future closeDB() async {
    (await db)!.close();
  }
}
