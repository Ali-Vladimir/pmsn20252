import 'package:flutter/material.dart';
import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/models/reservation_dao.dart';
import 'package:pmsn20252/models/planet_dao.dart';
import 'package:intl/intl.dart';

class AddReservationScreen extends StatefulWidget {
  final ReservationDao? reservation;
  final int? planetId;

  const AddReservationScreen({super.key, this.reservation, this.planetId});

  @override
  State<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends State<AddReservationScreen> {
  final MoviesDatabase _database = MoviesDatabase();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<PlanetDao> _planets = [];
  PlanetDao? _selectedPlanet;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _status = 'pending';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlanets();
    if (widget.reservation != null) {
      _visitorNameController.text = widget.reservation!.visitorName ?? '';
      _notesController.text = widget.reservation!.notes ?? '';
      _status = widget.reservation!.status ?? 'pending';
      if (widget.reservation!.reservationDate != null) {
        _selectedDate = DateTime.parse(widget.reservation!.reservationDate!);
      }
      if (widget.reservation!.visitTime != null) {
        final timeParts = widget.reservation!.visitTime!.split(':');
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }
  }

  Future<void> _loadPlanets() async {
    final planets = await _database.getAllPlanets();
    setState(() {
      _planets = planets;
      if (widget.reservation != null) {
        _selectedPlanet = planets.firstWhere(
          (p) => p.idPlanet == widget.reservation!.idPlanet,
          orElse: () => planets.first,
        );
      } else if (widget.planetId != null && planets.isNotEmpty) {
        // Si se proporciona un planetId, seleccionarlo automáticamente
        try {
          _selectedPlanet = planets.firstWhere(
            (p) => p.idPlanet == widget.planetId,
          );
        } catch (e) {
          _selectedPlanet = planets.first;
        }
      } else if (planets.isNotEmpty) {
        _selectedPlanet = planets.first;
      }
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.cyan,
              onPrimary: Colors.white,
              surface: Color(0xFF091422),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.cyan,
              onPrimary: Colors.white,
              surface: Color(0xFF091422),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveReservation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPlanet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a planet'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final reservation = ReservationDao(
        idReservation: widget.reservation?.idReservation,
        idPlanet: _selectedPlanet!.idPlanet,
        visitorName: _visitorNameController.text,
        reservationDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        visitTime:
            '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
        status: _status,
        notes: _notesController.text,
        createdAt: widget.reservation?.createdAt ??
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      );

      try {
        if (widget.reservation == null) {
          await _database.insertReservation(reservation);
        } else {
          await _database.updateReservation(reservation);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving reservation: $e'),
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reservation != null;

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
                        isEditing ? 'Edit Reservation' : 'New Reservation',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Planet selector
                        Text(
                          'Select Planet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF091422).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: DropdownButtonFormField<PlanetDao>(
                            value: _selectedPlanet,
                            dropdownColor: Color(0xFF091422),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.public, color: Colors.cyan),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            style: TextStyle(color: Colors.white),
                            items: _planets.map((planet) {
                              return DropdownMenuItem<PlanetDao>(
                                value: planet,
                                child: Text(planet.namePlanet ?? 'Unknown'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPlanet = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                        // Visitor name
                        TextFormField(
                          controller: _visitorNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Visitor Name',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.person, color: Colors.cyan),
                            filled: true,
                            fillColor: Color(0xFF091422).withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter visitor name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        // Date picker
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF091422).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.cyan),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reservation Date',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('EEEE, MMMM dd, yyyy')
                                          .format(_selectedDate),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Time picker
                        InkWell(
                          onTap: _selectTime,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF091422).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.cyan),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Visit Time',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      _selectedTime.format(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Status selector
                        Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF091422).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _status,
                            dropdownColor: Color(0xFF091422),
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.info_outline, color: Colors.cyan),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            style: TextStyle(color: Colors.white),
                            items: [
                              DropdownMenuItem(
                                  value: 'pending', child: Text('Pending')),
                              DropdownMenuItem(
                                  value: 'confirmed', child: Text('Confirmed')),
                              DropdownMenuItem(
                                  value: 'cancelled', child: Text('Cancelled')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _status = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        // Notes
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Notes (Optional)',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.note, color: Colors.cyan),
                            filled: true,
                            fillColor: Color(0xFF091422).withOpacity(0.7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        // Save button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveReservation,
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
                                            ? 'Update Reservation'
                                            : 'Create Reservation',
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

  @override
  void dispose() {
    _visitorNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
