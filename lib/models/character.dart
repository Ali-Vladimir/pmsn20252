class Character {
  final String name;
  final String image;
  final String description;
  final double speed;
  final double health;
  final double attack;

  Character({
    required this.name,
    required this.image,
    required this.description,
    required this.speed,
    required this.health,
    required this.attack,
  });
}

final List<Character> characters = [
  Character(
    name: 'Ryu',
    image: 'assets/ryu.png',
    description: 'Un artista marcial errante que recorre el mundo en busca de oponentes fuertes. Su único objetivo es perfeccionar sus habilidades y superar sus propios límites a través de la batalla.',
    speed: 75.0,
    health: 85.0,
    attack: 80.0,
  ),
  Character(
    name: 'Chun-Li',
    image: 'assets/chunli.png',
    description: 'Una ágil y valiente agente de la Interpol que busca vengar la muerte de su padre a manos de Shadaloo. Con sus poderosas patadas y su sentido de la justicia, no se detendrá ante nada para derribar al imperio criminal de M. Bison.',
    speed: 90.0,
    health: 70.0,
    attack: 75.0,
  ),
  Character(
    name: 'Akuma',
    image: 'assets/akuma.png',
    description: 'Un demonio de la lucha, un ser consumido por el ansatsuken oscuro y la sed de poder. Ha renunciado a su humanidad y solo vive para un único propósito: alcanzar la perfección de la muerte y aniquilar a cualquier oponente que se cruce en su camino, sin importar el costo.',
    speed: 85.0,
    health: 80.0,
    attack: 85.0,
  ),
  Character(
    name: 'Zangief',
    image: 'assets/zangief.png',
    description: 'El "Ciclón Rojo" de Rusia. Este musculoso y gigantesco luchador profesional está dispuesto a todo para demostrar la fuerza y el espíritu de su patria. Su imponente físico y su amor por la lucha libre lo convierten en una fuerza imparable en el ring, ¡capaz de destruir incluso al más poderoso de los oponentes!',
    speed: 50.0,
    health: 95.0,
    attack: 90.0,
  ),
];