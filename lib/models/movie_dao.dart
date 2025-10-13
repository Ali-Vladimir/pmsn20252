class MovieDao {
  int? idMovie;
  String? nameMovie;
  String? timeMovie;
  String? dateRelease;

  MovieDao({this.idMovie, this.nameMovie, this.timeMovie, this.dateRelease});

  factory MovieDao.fromMap(Map<String, dynamic> mapa) {
    return MovieDao(
      idMovie: mapa['idMovie'],
      nameMovie: mapa['nameMovie'],
      timeMovie: mapa['timeMovie'],
      dateRelease: mapa['dateRelease'],
    );
  }
}
