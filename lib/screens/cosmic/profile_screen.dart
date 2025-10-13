import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            image: AssetImage(
              'assets/stars.png',
            ), // Reemplaza con tu imagen de fondo
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Header
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
                    // Title
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 76,
                      child: Center(
                        child: Text(
                          'My Profile',
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
              // Content
              Positioned(
                top: 152,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Card
                        Container(
                          height: 100,
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
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.white,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage('assets/profile.png'),
                                      fit: BoxFit.fill,
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
                                SizedBox(width: 8),
                                Container(
                                  width: 50,
                                  height: 50,
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
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Arthur Dent',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Space adventurer',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Progress Section
                        Container(
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
                                GestureDetector(
                                  onTap: () {}, // Añade lógica si necesitas
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF11DCE8),
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF091422),
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x66484D52),
                                              blurRadius: 8,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Show planetary progress',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),
                                Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        // Background Circle
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Opacity(
                                            opacity: 0.1,
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Progress Circle
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: CustomPaint(
                                            size: Size(200, 200),
                                            painter: ProgressCirclePainter(
                                              progress: 0.871,
                                            ),
                                          ),
                                        ),
                                        // Progress Text
                                        Positioned(
                                          left: 15,
                                          top: 65,
                                          child: SizedBox(
                                            width: 170,
                                            height: 70,
                                            child: Text(
                                              '87.1%',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xFF859AF4),
                                                fontSize: 48,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                                letterSpacing: -1.44,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Title
                                        Positioned(
                                          left: 50,
                                          top: 30,
                                          child: SizedBox(
                                            width: 100,
                                            height: 15,
                                            child: Text(
                                              'Personal progress',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                GestureDetector(
                                  onTap: () {}, // Añade lógica si necesitas
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFF2F2F2F),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Show me in Planet Rating',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),
                                GestureDetector(
                                  onTap: () {}, // Añade lógica si necesitas
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFF2F2F2F),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Notifications',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
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

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = Color(0xFF00E5E5);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * 3.14159 / 180,
      2 * 3.14159 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
