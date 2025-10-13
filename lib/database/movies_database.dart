import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pmsn20252/models/movie_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MoviesDatabase {
  // Database initialization and setup code goes here

  static final nameDB = 'movies.db';
  static final versionDB =
      1; //Si el esquema de la basde de datos va a cambiar entonces si es necesario cambiar la version
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB); //'${folder.path}/$nameDB';
    return openDatabase(pathDB, version: versionDB, onCreate: createTables);
  }

  FutureOr<void> createTables(Database db, int version) {
    String query = '''
  CREATE TABLE tblmovies(
    idMovie INTEGER PRIMARY KEY,
    nameMovie VARCHAR(50),
    timeMovie CHAR(3),
    dateRelease CHAR(13)
    )
   ''';
    db.execute(query);
  }

  Future<int> INSERT(String table, Map<String, dynamic> data) async {
    var con = await database;
    return con!.insert(table, data);
  }

  Future<int> UPDATE(String table, Map<String, dynamic> data) async {
    var con = await database;
    return con!.update(
      table,
      data,
      where: 'idMovie = ?',
      whereArgs: [data['idMovie']],
    );
  }

  Future<int> DELETE(String table, int id) async {
    var con = await database;
    return con!.delete(table, where: 'idMovie = ?', whereArgs: [id]);
  }

  Future<List<MovieDao>> SELECT() async {
    var con = await database;
    final res = await con!.query('tblmovies');
    return res.map((movie) => MovieDao.fromMap(movie)).toList();
  }
}
