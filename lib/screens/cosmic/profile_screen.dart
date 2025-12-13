import 'package:flutter/material.dart';
import 'package:pmsn20252/widgets/parallax_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import 'package:pmsn20252/database/movies_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MoviesDatabase _database = MoviesDatabase();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _profileImagePath = 'assets/profile.png';
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _database.getProfile();
    if (profile != null) {
      setState(() {
        _nameController.text = profile['name'] ?? 'Arthur Dent';
        _bioController.text = profile['bio'] ?? 'Space adventurer';
        _profileImagePath = profile['imagePath'] ?? 'assets/profile.png';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  Widget _buildProfileImage() {
    if (_profileImagePath.startsWith('assets/')) {
      return Image.asset(
        _profileImagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 30, color: Colors.white);
        },
      );
    } else if (kIsWeb) {
      return Image.network(
        _profileImagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 30, color: Colors.white);
        },
      );
    } else {
      return Image.file(
        File(_profileImagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 30, color: Colors.white);
        },
      );
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    try {
      await _database.updateProfile(
        _nameController.text,
        _bioController.text,
        _profileImagePath,
      );
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.cyan,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          color: Color(0xFF091422),
          child: Center(
            child: CircularProgressIndicator(color: Colors.cyan),
          ),
        ),
      );
    }

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
                    // Edit Button
                    Positioned(
                      right: 16,
                      top: 70,
                      child: IconButton(
                        icon: Icon(
                          _isEditing ? Icons.close : Icons.edit,
                          color: Colors.cyan,
                          size: 28,
                        ),
                        onPressed: _isEditing ? _toggleEdit : _toggleEdit,
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
                        // Parallax Hero Banner
                        AnimatedParallax(
                          imagePath: 'assets/stars.png',
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF091422).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.explore,
                                    size: 60,
                                    color: Colors.cyan,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Space Explorer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Profile Card
                        Container(
                          padding: EdgeInsets.all(16),
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: _isEditing ? _pickImage : null,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 2,
                                              color: _isEditing ? Colors.cyan : Colors.white,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 16,
                                                offset: Offset(0, -4),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: _buildProfileImage(),
                                          ),
                                        ),
                                        if (_isEditing)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.cyan,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (_isEditing)
                                          TextField(
                                            controller: _nameController,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Your name',
                                              hintStyle: TextStyle(color: Colors.white54),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.cyan),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.cyan, width: 2),
                                              ),
                                            ),
                                          )
                                        else
                                          Text(
                                            _nameController.text,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        SizedBox(height: 8),
                                        if (_isEditing)
                                          TextField(
                                            controller: _bioController,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Your bio',
                                              hintStyle: TextStyle(color: Colors.white54),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.cyan),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.cyan, width: 2),
                                              ),
                                            ),
                                          )
                                        else
                                          Text(
                                            _bioController.text,
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
                                ],
                              ),
                              if (_isEditing) ...[
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.save),
                                      SizedBox(width: 8),
                                      Text('Save Profile'),
                                    ],
                                  ),
                                ),
                              ],
                            ],
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
