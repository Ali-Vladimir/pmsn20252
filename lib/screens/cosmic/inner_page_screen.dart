import 'package:flutter/material.dart';

class InnerPageScreen extends StatelessWidget {
  final String planet;

  InnerPageScreen({super.key, required this.planet});

  // Mapeo de planetas a sus assets
  final Map<String, String> planetAssets = {
    'mercury': 'assets/mercury.png',
    'Venus': 'assets/venus.png',
    'Earth': 'assets/earth.png',
    'Mars': 'assets/mars.png',
    'Jupiter': 'assets/jupiter.png',
    'Saturn': 'assets/saturn.png',
    'Uranus': 'assets/uranus.png',
    'Neptune': 'assets/neptune.png',
  };

  // Datos específicos de cada planeta
  Map<String, String> getPlanetData(String planetName) {
    final data = {
      'mercury': {
        'mass': '0.33',
        'gravity': '3.7',
        'day': '1408',
        'escVelocity': '4.25',
        'meanTemp': '167',
        'distance': '57.9',
      },
      'Venus': {
        'mass': '4.87',
        'gravity': '8.87',
        'day': '5832',
        'escVelocity': '10.36',
        'meanTemp': '464',
        'distance': '108.2',
      },
      'Earth': {
        'mass': '5.97',
        'gravity': '9.8',
        'day': '24',
        'escVelocity': '11.2',
        'meanTemp': '15',
        'distance': '149.6',
      },
      'Mars': {
        'mass': '0.642',
        'gravity': '3.71',
        'day': '25',
        'escVelocity': '5.03',
        'meanTemp': '-65',
        'distance': '227.9',
      },
    };

    return data[planetName] ?? data['Earth']!;
  }

  @override
  Widget build(BuildContext context) {
    final planetData = getPlanetData(planet);
    final assetPath = planetAssets[planet] ?? 'assets/earth.png';

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
                    image: AssetImage(assetPath),
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
                child: Text(
                  planet,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Roboto',
                  ),
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
                          planetData['mass']!,
                        ),
                        _buildStatItem(
                          Icons.public,
                          'Gravity\n(m/s²)',
                          planetData['gravity']!,
                        ),
                        _buildStatItem(
                          Icons.access_time,
                          'Day\n(hours)',
                          planetData['day']!,
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
                          planetData['escVelocity']!,
                        ),
                        _buildStatItem(
                          Icons.thermostat,
                          'Mean Temp\n(C)',
                          planetData['meanTemp']!,
                        ),
                        _buildStatItem(
                          Icons.wb_sunny,
                          'Distance from\nSun (10⁶ km)',
                          planetData['distance']!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 114,
              top: 550,
              child: Opacity(
                opacity: 0.8,
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        surfaceTintColor: Colors.transparent,
                        minimumSize: Size(130, 40),
                        overlayColor: Colors.white.withOpacity(0.2),
                        splashFactory: InkRipple.splashFactory,
                      ).copyWith(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) => Color(0xFF091422),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                  child: Container(
                    width: 130,
                    height: 40,
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
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Visit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
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
