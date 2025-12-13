import 'package:flutter/material.dart';
import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/models/planet_dao.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;

class AddPlanetScreen extends StatefulWidget {
  final PlanetDao? planet;

  const AddPlanetScreen({super.key, this.planet});

  @override
  State<AddPlanetScreen> createState() => _AddPlanetScreenState();
}

class _AddPlanetScreenState extends State<AddPlanetScreen> {
  final MoviesDatabase _database = MoviesDatabase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _massController = TextEditingController();
  final TextEditingController _gravityController = TextEditingController();
  final TextEditingController _dayLengthController = TextEditingController();
  final TextEditingController _escapeVelocityController =
      TextEditingController();
  final TextEditingController _meanTempController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  String? _imagePath;
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      _nameController.text = widget.planet!.namePlanet ?? '';
      _descriptionController.text = widget.planet!.description ?? '';
      _massController.text = widget.planet!.mass ?? '';
      _gravityController.text = widget.planet!.gravity ?? '';
      _dayLengthController.text = widget.planet!.dayLength ?? '';
      _escapeVelocityController.text = widget.planet!.escapeVelocity ?? '';
      _meanTempController.text = widget.planet!.meanTemp ?? '';
      _distanceController.text = widget.planet!.distanceFromSun ?? '';
      _imagePath = widget.planet!.imagePath;
      _isFavorite = widget.planet!.isFavorite == 1;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _savePlanet() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final planet = PlanetDao(
        idPlanet: widget.planet?.idPlanet,
        namePlanet: _nameController.text,
        description: _descriptionController.text,
        imagePath: _imagePath ?? 'assets/earth.png',
        mass: _massController.text,
        gravity: _gravityController.text,
        dayLength: _dayLengthController.text,
        escapeVelocity: _escapeVelocityController.text,
        meanTemp: _meanTempController.text,
        distanceFromSun: _distanceController.text,
        isFavorite: _isFavorite ? 1 : 0,
      );

      try {
        if (widget.planet == null) {
          await _database.insertPlanet(planet);
        } else {
          await _database.updatePlanet(planet);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving planet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.broken_image,
            size: 60,
            color: Colors.white70,
          );
        },
      );
    } else if (kIsWeb) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.broken_image,
            size: 60,
            color: Colors.white70,
          );
        },
      );
    } else {
      // En móvil, usar FileImage con File
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.broken_image,
            size: 60,
            color: Colors.white70,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.planet != null;

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
                        isEditing ? 'Edit Planet' : 'Add New Planet',
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
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Image picker
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.cyan,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _imagePath != null
                                  ? _buildImage(_imagePath!)
                                  : Icon(
                                      Icons.add_photo_alternate,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to change image',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 24),
                        // Name field
                        _buildTextField(
                          controller: _nameController,
                          label: 'Planet Name',
                          icon: Icons.public,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a planet name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Description field
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Mass and Gravity
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _massController,
                                label: 'Mass (×10²⁴kg)',
                                icon: Icons.science,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _gravityController,
                                label: 'Gravity (m/s²)',
                                icon: Icons.trending_down,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Day Length and Escape Velocity
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _dayLengthController,
                                label: 'Day Length (hrs)',
                                icon: Icons.access_time,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _escapeVelocityController,
                                label: 'Escape Velocity',
                                icon: Icons.rocket_launch,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Temperature and Distance
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _meanTempController,
                                label: 'Mean Temp (°C)',
                                icon: Icons.thermostat,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _distanceController,
                                label: 'Distance (M km)',
                                icon: Icons.social_distance,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Favorite toggle
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF091422).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: SwitchListTile(
                            title: Text(
                              'Add to Favorites',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: _isFavorite,
                            onChanged: (value) {
                              setState(() {
                                _isFavorite = value;
                              });
                            },
                            activeColor: Colors.cyan,
                            secondary: Icon(
                              Icons.favorite,
                              color: _isFavorite ? Colors.cyan : Colors.white54,
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _savePlanet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save, size: 24),
                                      SizedBox(width: 8),
                                      Text(
                                        isEditing
                                            ? 'Update Planet'
                                            : 'Add Planet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.cyan),
        filled: true,
        fillColor: Color(0xFF091422).withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.cyan, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _massController.dispose();
    _gravityController.dispose();
    _dayLengthController.dispose();
    _escapeVelocityController.dispose();
    _meanTempController.dispose();
    _distanceController.dispose();
    super.dispose();
  }
}
