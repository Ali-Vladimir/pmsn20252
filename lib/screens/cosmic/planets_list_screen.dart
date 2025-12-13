import 'package:flutter/material.dart';
import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/models/planet_dao.dart';
import 'package:pmsn20252/screens/cosmic/inner_page_screen.dart';
import 'package:pmsn20252/screens/cosmic/add_planet_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlanetsListScreen extends StatefulWidget {
  const PlanetsListScreen({super.key});

  @override
  State<PlanetsListScreen> createState() => _PlanetsListScreenState();
}

class _PlanetsListScreenState extends State<PlanetsListScreen> {
  final MoviesDatabase _database = MoviesDatabase();
  List<PlanetDao> _planets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlanets();
  }

  Future<void> _loadPlanets() async {
    setState(() {
      _isLoading = true;
    });
    final planets = await _database.getAllPlanets();
    setState(() {
      _planets = planets;
      _isLoading = false;
    });
  }

  Future<void> _deletePlanet(int id) async {
    await _database.deletePlanet(id);
    _loadPlanets();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Planet deleted successfully'),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  Widget _buildPlanetImage(String imagePath) {
    final isAsset = imagePath.startsWith('assets/');
    
    if (isAsset) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.public,
            size: 40,
            color: Colors.white,
          );
        },
      );
    } else if (kIsWeb) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.public,
            size: 40,
            color: Colors.white,
          );
        },
      );
    } else {
      return Image.asset(
        'assets/earth.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.public,
            size: 40,
            color: Colors.white,
          );
        },
      );
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
          image: DecorationImage(
            image: AssetImage('assets/stars.png'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF091422).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 32,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Center(
                      child: Text(
                        'All Planets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Planets List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.cyan),
                      )
                    : _planets.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.public_off,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No planets yet',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _planets.length,
                            itemBuilder: (context, index) {
                              final planet = _planets[index];
                              return Slidable(
                                key: ValueKey(planet.idPlanet),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddPlanetScreen(planet: planet),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadPlanets();
                                        }
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: Color(0xFF091422),
                                            title: Text(
                                              'Delete Planet',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete ${planet.namePlanet}? This will also delete all related reservations.',
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _deletePlanet(
                                                      planet.idPlanet!);
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InnerPageScreen(planetDao: planet),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF091422).withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyan.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          // Planet Image
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.cyan,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.cyan
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: ClipOval(
                                              child: _buildPlanetImage(
                                                planet.imagePath ??
                                                    'assets/earth.png',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          // Planet Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        planet.namePlanet ??
                                                            'Unknown',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    if (planet.isFavorite == 1)
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  planet.description ??
                                                      'No description',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.straighten,
                                                      size: 14,
                                                      color: Colors.cyan,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${planet.distanceFromSun ?? 'N/A'} M km',
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    SizedBox(width: 16),
                                                    Icon(
                                                      Icons.thermostat,
                                                      size: 14,
                                                      color: Colors.orange,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${planet.meanTemp ?? 'N/A'}°C',
                                                      style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white54,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPlanetScreen(),
            ),
          );
          if (result == true) {
            _loadPlanets();
          }
        },
        backgroundColor: Colors.cyan,
        icon: Icon(Icons.add),
        label: Text('Add Planet'),
      ),
    );
  }
}
