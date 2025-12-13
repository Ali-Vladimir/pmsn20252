import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/models/planet_dao.dart';

class PlanetsSeeder {
  static Future<void> seedPlanets(MoviesDatabase database) async {
    // Verificar si ya existen planetas
    final existingPlanets = await database.getAllPlanets();
    if (existingPlanets.isNotEmpty) {
      print('Planets already seeded');
      return;
    }

    final planets = [
      PlanetDao(
        namePlanet: 'Mercury',
        description:
            'Mercury is the smallest planet in the Solar System and the closest to the Sun.',
        imagePath: 'assets/mercury.png',
        mass: '0.33',
        gravity: '3.7',
        dayLength: '1408',
        escapeVelocity: '4.25',
        meanTemp: '167',
        distanceFromSun: '57.9',
        isFavorite: 0,
      ),
      PlanetDao(
        namePlanet: 'Venus',
        description:
            'Venus is the second planet from the Sun and is Earth\'s closest planetary neighbor.',
        imagePath: 'assets/venus.png',
        mass: '4.87',
        gravity: '8.9',
        dayLength: '2802',
        escapeVelocity: '10.36',
        meanTemp: '464',
        distanceFromSun: '108.2',
        isFavorite: 0,
      ),
      PlanetDao(
        namePlanet: 'Earth',
        description:
            'Earth is an ellipsoid with a circumference of about 40,000 km. It is the densest planet in the Solar System.',
        imagePath: 'assets/earth.png',
        mass: '5.97',
        gravity: '9.8',
        dayLength: '24',
        escapeVelocity: '11.19',
        meanTemp: '15',
        distanceFromSun: '149.6',
        isFavorite: 1,
      ),
      PlanetDao(
        namePlanet: 'Mars',
        description:
            'Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System, only being larger than Mercury.',
        imagePath: 'assets/mars.png',
        mass: '0.642',
        gravity: '3.7',
        dayLength: '25',
        escapeVelocity: '5.03',
        meanTemp: '-65',
        distanceFromSun: '228.0',
        isFavorite: 1,
      ),
      PlanetDao(
        namePlanet: 'Jupiter',
        description:
            'Jupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass more than two and a half times that of all the other planets in the Solar System combined.',
        imagePath: 'assets/jupiter.png',
        mass: '1898',
        gravity: '23.1',
        dayLength: '10',
        escapeVelocity: '59.5',
        meanTemp: '-110',
        distanceFromSun: '778.5',
        isFavorite: 0,
      ),
      PlanetDao(
        namePlanet: 'Saturn',
        description:
            'Saturn is the sixth planet from the Sun and the second-largest in the Solar System, after Jupiter. It is a gas giant with an average radius of about nine times that of Earth.',
        imagePath: 'assets/saturn.png',
        mass: '568',
        gravity: '9.0',
        dayLength: '11',
        escapeVelocity: '35.5',
        meanTemp: '-140',
        distanceFromSun: '1432.0',
        isFavorite: 0,
      ),
      PlanetDao(
        namePlanet: 'Uranus',
        description:
            'Uranus is the seventh planet from the Sun. It has the third-largest planetary radius and fourth-largest planetary mass in the Solar System.',
        imagePath: 'assets/uranus.png',
        mass: '86.8',
        gravity: '8.7',
        dayLength: '17',
        escapeVelocity: '21.3',
        meanTemp: '-195',
        distanceFromSun: '2867.0',
        isFavorite: 0,
      ),
      PlanetDao(
        namePlanet: 'Neptune',
        description:
            'Neptune is the eighth and farthest known planet from the Sun. In the Solar System, it is the fourth-largest planet by diameter and the third-most-massive planet.',
        imagePath: 'assets/neptune.png',
        mass: '102',
        gravity: '11.0',
        dayLength: '16',
        escapeVelocity: '23.5',
        meanTemp: '-200',
        distanceFromSun: '4515.0',
        isFavorite: 0,
      ),
    ];

    for (var planet in planets) {
      await database.insertPlanet(planet);
    }

    print('${planets.length} planets seeded successfully!');
  }
}
