import 'dart:async';
import 'package:pmsn20252/models/movie_dao.dart';
import 'package:pmsn20252/models/planet_dao.dart';
import 'package:pmsn20252/models/reservation_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MoviesDatabase {
  // Database initialization and setup code goes here

  static final nameDB = 'movies.db';
  static final versionDB =
      3; // Incrementamos la versión para incluir la tabla de perfil
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    if (kIsWeb) {
      // En web, sqflite usa el storage del navegador automáticamente
      String pathDB = nameDB;
      return openDatabase(
        pathDB,
        version: versionDB,
        onCreate: createTables,
        onConfigure: (db) async {
          // Habilitar claves foráneas
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } else {
      // En móvil/escritorio, guardar en el directorio de documentos
      String databasesPath = await getDatabasesPath();
      String pathDB = join(databasesPath, nameDB);
      return openDatabase(
        pathDB,
        version: versionDB,
        onCreate: createTables,
        onConfigure: (db) async {
          // Habilitar claves foráneas
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    }
  }

  FutureOr<void> createTables(Database db, int version) async {
    // Tabla de películas
    String query = '''
  CREATE TABLE tblmovies(
    idMovie INTEGER PRIMARY KEY,
    nameMovie VARCHAR(50),
    timeMovie CHAR(3),
    dateRelease CHAR(13)
    )
   ''';
    await db.execute(query);

    // Tabla de planetas
    String queryPlanets = '''
    CREATE TABLE tblplanets(
      idPlanet INTEGER PRIMARY KEY AUTOINCREMENT,
      namePlanet VARCHAR(50) NOT NULL,
      description TEXT,
      imagePath VARCHAR(100),
      mass VARCHAR(20),
      gravity VARCHAR(20),
      dayLength VARCHAR(20),
      escapeVelocity VARCHAR(20),
      meanTemp VARCHAR(20),
      distanceFromSun VARCHAR(20),
      isFavorite INTEGER DEFAULT 0
    )
    ''';
    await db.execute(queryPlanets);

    // Tabla de reservaciones con integridad referencial
    String queryReservations = '''
    CREATE TABLE tblreservations(
      idReservation INTEGER PRIMARY KEY AUTOINCREMENT,
      idPlanet INTEGER NOT NULL,
      visitorName VARCHAR(100) NOT NULL,
      reservationDate TEXT NOT NULL,
      visitTime VARCHAR(10),
      status VARCHAR(20) DEFAULT 'pending',
      notes TEXT,
      createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (idPlanet) REFERENCES tblplanets(idPlanet)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    )
    ''';
    await db.execute(queryReservations);

    // Tabla de perfil de usuario
    String queryProfile = '''
    CREATE TABLE tblprofile(
      idProfile INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(100) NOT NULL,
      bio TEXT,
      imagePath VARCHAR(200)
    )
    ''';
    await db.execute(queryProfile);

    // Insertar perfil por defecto
    await db.insert('tblprofile', {
      'name': 'Arthur Dent',
      'bio': 'Space adventurer',
      'imagePath': 'assets/profile.png'
    });
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

  // ============ CRUD PARA PLANETAS ============
  
  Future<int> insertPlanet(PlanetDao planet) async {
    var con = await database;
    return con!.insert('tblplanets', planet.toMap());
  }

  Future<int> updatePlanet(PlanetDao planet) async {
    var con = await database;
    return con!.update(
      'tblplanets',
      planet.toMap(),
      where: 'idPlanet = ?',
      whereArgs: [planet.idPlanet],
    );
  }

  Future<int> deletePlanet(int id) async {
    var con = await database;
    return con!.delete('tblplanets', where: 'idPlanet = ?', whereArgs: [id]);
  }

  Future<List<PlanetDao>> getAllPlanets() async {
    var con = await database;
    final res = await con!.query('tblplanets', orderBy: 'idPlanet ASC');
    return res.map((planet) => PlanetDao.fromMap(planet)).toList();
  }

  Future<List<PlanetDao>> getFavoritePlanets() async {
    var con = await database;
    final res = await con!.query(
      'tblplanets',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'namePlanet ASC',
    );
    return res.map((planet) => PlanetDao.fromMap(planet)).toList();
  }

  Future<PlanetDao?> getPlanetById(int id) async {
    var con = await database;
    final res = await con!.query(
      'tblplanets',
      where: 'idPlanet = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return PlanetDao.fromMap(res.first);
    }
    return null;
  }

  // ============ CRUD PARA RESERVACIONES ============

  Future<int> insertReservation(ReservationDao reservation) async {
    var con = await database;
    // Verificar que el planeta exista antes de insertar
    final planet = await getPlanetById(reservation.idPlanet!);
    if (planet == null) {
      throw Exception('Planet not found');
    }
    return con!.insert('tblreservations', reservation.toMap());
  }

  Future<int> updateReservation(ReservationDao reservation) async {
    var con = await database;
    // Verificar que el planeta exista si se está actualizando
    if (reservation.idPlanet != null) {
      final planet = await getPlanetById(reservation.idPlanet!);
      if (planet == null) {
        throw Exception('Planet not found');
      }
    }
    return con!.update(
      'tblreservations',
      reservation.toMap(),
      where: 'idReservation = ?',
      whereArgs: [reservation.idReservation],
    );
  }

  Future<int> deleteReservation(int id) async {
    var con = await database;
    return con!.delete(
      'tblreservations',
      where: 'idReservation = ?',
      whereArgs: [id],
    );
  }

  Future<List<ReservationDao>> getAllReservations() async {
    var con = await database;
    final res = await con!.query(
      'tblreservations',
      orderBy: 'reservationDate DESC, visitTime DESC',
    );
    return res.map((reservation) => ReservationDao.fromMap(reservation)).toList();
  }

  Future<List<ReservationDao>> getReservationsByDate(String date) async {
    var con = await database;
    final res = await con!.query(
      'tblreservations',
      where: 'reservationDate = ?',
      whereArgs: [date],
      orderBy: 'visitTime ASC',
    );
    return res.map((reservation) => ReservationDao.fromMap(reservation)).toList();
  }

  Future<List<ReservationDao>> getReservationsByPlanet(int planetId) async {
    var con = await database;
    final res = await con!.query(
      'tblreservations',
      where: 'idPlanet = ?',
      whereArgs: [planetId],
      orderBy: 'reservationDate DESC',
    );
    return res.map((reservation) => ReservationDao.fromMap(reservation)).toList();
  }

  Future<Map<String, dynamic>> getReservationWithPlanet(int reservationId) async {
    var con = await database;
    final res = await con!.rawQuery('''
      SELECT r.*, p.namePlanet, p.imagePath 
      FROM tblreservations r
      INNER JOIN tblplanets p ON r.idPlanet = p.idPlanet
      WHERE r.idReservation = ?
    ''', [reservationId]);
    
    if (res.isNotEmpty) {
      return res.first;
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> getAllReservationsWithPlanets() async {
    var con = await database;
    final res = await con!.rawQuery('''
      SELECT r.*, p.namePlanet, p.imagePath 
      FROM tblreservations r
      INNER JOIN tblplanets p ON r.idPlanet = p.idPlanet
      ORDER BY r.reservationDate DESC, r.visitTime DESC
    ''');
    return res;
  }

  // Métodos para manejar el perfil
  Future<Map<String, dynamic>?> getProfile() async {
    var con = await database;
    final res = await con!.query('tblprofile', limit: 1);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<int> updateProfile(String name, String bio, String imagePath) async {
    var con = await database;
    return await con!.update(
      'tblprofile',
      {
        'name': name,
        'bio': bio,
        'imagePath': imagePath,
      },
      where: 'idProfile = 1',
    );
  }
}
