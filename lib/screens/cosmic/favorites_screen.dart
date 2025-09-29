import 'package:flutter/material.dart';
import 'package:pmsn20252/screens/cosmic/inner_page_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> planets = [
    {'name': 'Mercury', 'description': 'Mercury is the smallest planet in the Solar System and the closest to the Sun.', 'image': 'assets/mercury.png'},
    {'name': 'Venus', 'description': 'Venus is the second planet from the Sun and is Earth\'s closest planetary neighbor.', 'image': 'assets/venus.png'},
    {'name': 'Earth', 'description': 'Earth is an ellipsoid with a circumference of about 40,000 km. It is the densest.', 'image': 'assets/earth.png'},
    {'name': 'Mars', 'description': 'Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System.', 'image': 'assets/mars.png'},
  ];

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
                  border: Border.all(width: 2, color: Colors.white.withOpacity(0.2)),
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 16, offset: Offset(0, -4))],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 76,
                      child: Center(
                        child: Text('Favourites', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Roboto')),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                    itemCount: planets.length,
                    separatorBuilder: (context, index) => SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final planet = planets[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InnerPageScreen(planet: planet['name']))),
                        child: Container(
                          height: 142,
                          decoration: BoxDecoration(
                            color: Color(0xFF091422).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(width: 1, color: Colors.white.withOpacity(0.2)),
                            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 16, offset: Offset(0, -4))],
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
                                      colors: [Color(0xFF00E5E5), Color(0xFF72A4F1), Color(0xFFE860FF)],
                                    ),
                                    image: DecorationImage(image: AssetImage(planet['image']), fit: BoxFit.cover),
                                    boxShadow: [
                                      BoxShadow(color: Color(0x9909141E), blurRadius: 16, offset: Offset(0, 4)),
                                      BoxShadow(color: Color(0x26000000), blurRadius: 1, offset: Offset(0, 2)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16, top: 16, bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        planet['name'],
                                        style: TextStyle(color: Color(0xFF11DCE8), fontSize: 16, fontWeight: FontWeight.w800, fontFamily: 'Roboto'),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        planet['description'],
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text('Details', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Roboto')),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
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
