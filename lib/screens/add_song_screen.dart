import 'package:flutter/material.dart';
import 'package:pmsn20252/firebase/songs_firebase.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  SongsFirebase? songsFirebase;
  bool isLoading = false;

  // Text controllers para los campos de Firebase
  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conCover = TextEditingController();
  final TextEditingController conDuration = TextEditingController();
  final TextEditingController conLyrics = TextEditingController();

  @override
  void initState() {
    super.initState();
    songsFirebase = SongsFirebase();
  }

  @override
  void dispose() {
    conTitle.dispose();
    conCover.dispose();
    conDuration.dispose();
    conLyrics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Canción'),
        backgroundColor: const Color.fromARGB(255, 237, 207, 217),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 237, 207, 217).withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 50,
                        color: Colors.purple[400],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nueva Canción',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'Completa todos los campos para agregar una nueva canción',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Title field
                _buildTextField(
                  controller: conTitle,
                  label: 'Título de la canción',
                  hint: 'Ingresa el nombre de la canción',
                  icon: Icons.music_note,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el título de la canción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Cover URL field
                _buildTextField(
                  controller: conCover,
                  label: 'URL de la carátula',
                  hint: 'https://ejemplo.com/imagen.jpg',
                  icon: Icons.image,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la URL de la carátula';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Duration field
                _buildTextField(
                  controller: conDuration,
                  label: 'Duración (en segundos)',
                  hint: 'Ej: 360 para 6 minutos',
                  icon: Icons.access_time,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la duración';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor ingresa un número válido';
                    }
                    final duration = int.parse(value);
                    if (duration <= 0) {
                      return 'La duración debe ser mayor a 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Lyrics field
                _buildTextField(
                  controller: conLyrics,
                  label: 'Letra de la canción',
                  hint: 'Ingresa la letra completa de la canción...',
                  icon: Icons.lyrics,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la letra de la canción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Save button
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Colors.purple[400]!, Colors.purple[600]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveSong,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Guardar Canción',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Cancel button
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.purple[400]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.purple[400]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
          ),
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Future<void> _saveSong() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Formatear los datos según la estructura de Firebase
      final songData = {
        'title': conTitle.text.trim(),
        'cover': conCover.text.trim(),
        'duration': int.parse(conDuration.text.trim()), // Como número
        'lyrics': conLyrics.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      await songsFirebase!.insertSong(songData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Canción guardada exitosamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}