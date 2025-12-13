class PlanetDao {
  int? idPlanet;
  String? namePlanet;
  String? description;
  String? imagePath;
  String? mass;
  String? gravity;
  String? dayLength;
  String? escapeVelocity;
  String? meanTemp;
  String? distanceFromSun;
  int? isFavorite;

  PlanetDao({
    this.idPlanet,
    this.namePlanet,
    this.description,
    this.imagePath,
    this.mass,
    this.gravity,
    this.dayLength,
    this.escapeVelocity,
    this.meanTemp,
    this.distanceFromSun,
    this.isFavorite = 0,
  });

  factory PlanetDao.fromMap(Map<String, dynamic> map) {
    return PlanetDao(
      idPlanet: map['idPlanet'],
      namePlanet: map['namePlanet'],
      description: map['description'],
      imagePath: map['imagePath'],
      mass: map['mass'],
      gravity: map['gravity'],
      dayLength: map['dayLength'],
      escapeVelocity: map['escapeVelocity'],
      meanTemp: map['meanTemp'],
      distanceFromSun: map['distanceFromSun'],
      isFavorite: map['isFavorite'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idPlanet': idPlanet,
      'namePlanet': namePlanet,
      'description': description,
      'imagePath': imagePath,
      'mass': mass,
      'gravity': gravity,
      'dayLength': dayLength,
      'escapeVelocity': escapeVelocity,
      'meanTemp': meanTemp,
      'distanceFromSun': distanceFromSun,
      'isFavorite': isFavorite,
    };
  }
}
