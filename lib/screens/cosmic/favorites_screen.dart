import 'package:flutter/material.dart';
import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/database/planets_seeder.dart';
import 'package:pmsn20252/models/planet_dao.dart';
import 'package:pmsn20252/screens/cosmic/inner_page_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MoviesDatabase _database = MoviesDatabase();
  List<PlanetDao> _favoritePlanets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await PlanetsSeeder.seedPlanets(_database);
    await _loadFavoritePlanets();
  }

  Future<void> _loadFavoritePlanets() async {
    final planets = await _database.getFavoritePlanets();
    setState(() {
      _favoritePlanets = planets;
      _isLoading = false;
    });
  }

  ImageProvider _buildImageProvider(String imagePath) {
    final isAsset = imagePath.startsWith('assets/');
    
    if (isAsset) {
      return AssetImage(imagePath);
    } else if (kIsWeb) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage('assets/earth.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF091422),
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: AssetImage('assets/stars.png'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 128,
                decoration: BoxDecoration(
                  color: Color(0xFF091422).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 76,
                      child: Center(
                        child: Text(
                          'Favourites',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 152,
                left: 0,
                right: 0,
                bottom: 0,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.cyan),
                      )
                    : _favoritePlanets.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No favorite planets yet',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: ListView.separated(
                              itemCount: _favoritePlanets.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 24),
                              itemBuilder: (context, index) {
                                final planet = _favoritePlanets[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InnerPageScreen(planetDao: planet),
                                    ),
                                  ).then((_) => _loadFavoritePlanets()),
                                  child: Container(
                                    height: 142,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF091422).withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 16,
                                          offset: Offset(0, -4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment(0.91, 0.09),
                                                end: Alignment(0.10, 0.93),
                                                colors: [
                                                  Color(0xFF00E5E5),
                                                  Color(0xFF72A4F1),
                                                  Color(0xFFE860FF),
                                                ],
                                              ),
                                              image: DecorationImage(
                                                image: _buildImageProvider(
                                                    planet.imagePath ??
                                                        'assets/earth.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x9909141E),
                                                  blurRadius: 16,
                                                  offset: Offset(0, 4),
                                                ),
                                                BoxShadow(
                                                  color: Color(0x26000000),
                                                  blurRadius: 1,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 16,
                                              top: 16,
                                              bottom: 16,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  planet.namePlanet ??
                                                      'Unknown',
                                                  style: TextStyle(
                                                    color: Color(0xFF11DCE8),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  planet.description ??
                                                      'No description',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Details',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
