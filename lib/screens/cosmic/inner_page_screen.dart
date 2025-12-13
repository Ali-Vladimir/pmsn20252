import 'package:flutter/material.dart';
import 'package:pmsn20252/models/planet_dao.dart';
import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/widgets/flip_card.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pmsn20252/screens/cosmic/add_reservation_screen.dart';
import 'package:pmsn20252/screens/cosmic/add_planet_screen.dart';

class InnerPageScreen extends StatefulWidget {
  final PlanetDao planetDao;

  const InnerPageScreen({super.key, required this.planetDao});

  @override
  State<InnerPageScreen> createState() => _InnerPageScreenState();
}

class _InnerPageScreenState extends State<InnerPageScreen> with SingleTickerProviderStateMixin {
  final MoviesDatabase _database = MoviesDatabase();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    widget.planetDao.isFavorite = widget.planetDao.isFavorite == 1 ? 0 : 1;
    await _database.updatePlanet(widget.planetDao);
    setState(() {});
  }

  Future<void> _deletePlanet() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF091422),
        title: Text(
          'Delete Planet',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${widget.planetDao.namePlanet}? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.cyan)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _database.deletePlanet(widget.planetDao.idPlanet!);
      Navigator.pop(context, true); // Volver a la pantalla anterior
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Planet deleted successfully'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  Future<void> _editPlanet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlanetScreen(planet: widget.planetDao),
      ),
    );
    if (result == true) {
      // Recargar datos del planeta
      final updatedPlanets = await _database.getAllPlanets();
      final updatedPlanet = updatedPlanets.firstWhere(
        (p) => p.idPlanet == widget.planetDao.idPlanet,
        orElse: () => widget.planetDao,
      );
      setState(() {
        widget.planetDao.namePlanet = updatedPlanet.namePlanet;
        widget.planetDao.imagePath = updatedPlanet.imagePath;
        widget.planetDao.description = updatedPlanet.description;
        widget.planetDao.mass = updatedPlanet.mass;
        widget.planetDao.gravity = updatedPlanet.gravity;
        widget.planetDao.dayLength = updatedPlanet.dayLength;
        widget.planetDao.escapeVelocity = updatedPlanet.escapeVelocity;
        widget.planetDao.meanTemp = updatedPlanet.meanTemp;
        widget.planetDao.distanceFromSun = updatedPlanet.distanceFromSun;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.planetDao.imagePath ?? 'assets/earth.png';
    final isAsset = imagePath.startsWith('assets/');

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
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.91, 0.09),
                  end: Alignment(0.10, 0.93),
                  colors: [
                    Color(0xFF00E5E5),
                    Color(0xFF72A4F1),
                    Color(0xFFE860FF),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 200,
              child: Opacity(
                opacity: 0.7,
                child: Container(
                  width: 375,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Color(0xFF091422),
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
                ),
              ),
            ),
            Positioned(
              left: 127,
              top: 150,
              child: Container(
                width: 100,
                height: 100,
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
                    image: isAsset 
                        ? AssetImage(imagePath) as ImageProvider
                        : (kIsWeb 
                            ? NetworkImage(imagePath) 
                            : AssetImage(imagePath)) as ImageProvider,
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
            Positioned(
              left: 0,
              right: 0,
              top: 270,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.planetDao.namePlanet ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        widget.planetDao.isFavorite == 1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 320,
              child: SizedBox(
                width: 327,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          Icons.scale,
                          'Mass\n(10²⁴ kg)',
                          widget.planetDao.mass ?? '0',
                        ),
                        _buildStatItem(
                          Icons.public,
                          'Gravity\n(m/s²)',
                          widget.planetDao.gravity ?? '0',
                        ),
                        _buildStatItem(
                          Icons.access_time,
                          'Day\n(hours)',
                          widget.planetDao.dayLength ?? '0',
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem(
                          Icons.speed,
                          'Esc. Velocity\n(km/s)',
                          widget.planetDao.escapeVelocity ?? '0',
                        ),
                        _buildStatItem(
                          Icons.thermostat,
                          'Mean Temp\n(C)',
                          widget.planetDao.meanTemp ?? '0',
                        ),
                        _buildStatItem(
                          Icons.wb_sunny,
                          'Distance from\nSun (10⁶ km)',
                          widget.planetDao.distanceFromSun ?? '0',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: 530,
              child: FlipCard(
                front: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.91, 0.09),
                      end: Alignment(0.10, 0.93),
                      colors: [
                        Color(0xFF00E5E5),
                        Color(0xFF72A4F1),
                        Color(0xFFE860FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Tap to see more info',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                back: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0xFF091422).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Colors.cyan,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About ${widget.planetDao.namePlanet}',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.planetDao.description ?? 'No description available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 670,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón Editar
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ElevatedButton.icon(
                        onPressed: _editPlanet,
                        icon: Icon(Icons.edit, size: 18),
                        label: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF091422),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.cyan, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Botón Visit
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddReservationScreen(
                                planetId: widget.planetDao.idPlanet!,
                              ),
                            ),
                          );
                          if (result == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reservation created successfully!'),
                                backgroundColor: Colors.cyan,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.91, 0.09),
                              end: Alignment(0.10, 0.93),
                              colors: [
                                Color(0xFF00E5E5),
                                Color(0xFF72A4F1),
                                Color(0xFFE860FF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Visit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Botón Eliminar
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: ElevatedButton.icon(
                        onPressed: _deletePlanet,
                        icon: Icon(Icons.delete, size: 18),
                        label: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF091422),
                          foregroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SafeArea(
                child: SizedBox(
                  width: 375,
                  height: 44,
                  child: Stack(
                    children: [
                      // Back Button
                      Positioned(
                        left: 16,
                        top: 8,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0xFF091422).withOpacity(0.7),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
