import 'package:flutter/material.dart';
import 'package:pmsn20252/screens/cosmic/inner_page_screen.dart';

class HomeScreenCosmic extends StatelessWidget {
  final List<Map<String, String>> planets = const [
    {'name': 'Mercury', 'image': 'assets/mercury.png'},
    {'name': 'Venus', 'image': 'assets/venus.png'},
    {'name': 'Earth', 'image': 'assets/earth.png'},
  ];

  const HomeScreenCosmic({super.key});

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
                          'Solar System',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 57,
                      child: Center(
                        child: Text(
                          'Milky Way',
                          style: TextStyle(
                            color: Color(0xFF8C8E99),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 128,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 64,
                        margin: EdgeInsets.only(left: 24, top: 20),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: planets.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final planet = planets[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InnerPageScreen(planet: planet['name']!),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xCC091422),
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
                                    Container(
                                      width: 24,
                                      height: 24,
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
                                          image: AssetImage(planet['image']!),
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
                                    SizedBox(width: 8),
                                    Text(
                                      planet['name']!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
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
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Planet of the Day',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
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
                                          image: AssetImage('assets/mars.png'),
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
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mars',
                                            style: TextStyle(
                                              color: Color(0xFF11DCE8),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System, only being larger than Mercury. In the English language, Mars is named for the Roman god of war.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InnerPageScreen(
                                                      planet: 'Mars',
                                                    ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Details',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
                        child: Container(
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
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Solar System',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'The Solar System is the gravitationally bound system of the Sun and the objects that orbit it. It formed 4.6 billion years ago from the gravitational collapse of a giant interstellar molecular cloud. The vast majority (99.86%) of the system\'s mass is in the Sun, with most of the remaining mass contained in the planet Jupiter. The four inner system planets—Mercury, Venus, Earth, and Mars—are terrestrial planets, being composed primarily of rock and metal. The four giant planets of the outer system are substantially larger and more massive than the terrestrials.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Roboto',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
