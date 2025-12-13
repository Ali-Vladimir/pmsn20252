import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pmsn20252/database/movies_database.dart';
import 'package:pmsn20252/models/reservation_dao.dart';
import 'package:pmsn20252/screens/cosmic/add_reservation_screen.dart';

class ReservationsCalendarScreen extends StatefulWidget {
  const ReservationsCalendarScreen({super.key});

  @override
  State<ReservationsCalendarScreen> createState() =>
      _ReservationsCalendarScreenState();
}

class _ReservationsCalendarScreenState
    extends State<ReservationsCalendarScreen> {
  final MoviesDatabase _database = MoviesDatabase();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ReservationDao>> _reservationsByDate = {};
  List<ReservationDao> _selectedDayReservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    final reservations = await _database.getAllReservations();

    // Agrupar reservaciones por fecha
    Map<DateTime, List<ReservationDao>> groupedReservations = {};
    for (var reservation in reservations) {
      if (reservation.reservationDate != null) {
        DateTime date = DateTime.parse(reservation.reservationDate!);
        DateTime dateKey = DateTime(date.year, date.month, date.day);

        if (groupedReservations[dateKey] == null) {
          groupedReservations[dateKey] = [];
        }
        groupedReservations[dateKey]!.add(reservation);
      }
    }

    setState(() {
      _reservationsByDate = groupedReservations;
      _selectedDayReservations = _getReservationsForDay(_selectedDay!);
      _isLoading = false;
    });
  }

  List<ReservationDao> _getReservationsForDay(DateTime day) {
    DateTime dateKey = DateTime(day.year, day.month, day.day);
    return _reservationsByDate[dateKey] ?? [];
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _deleteReservation(int id) async {
    await _database.deleteReservation(id);
    _loadReservations();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reservation deleted'),
        backgroundColor: Colors.red[700],
      ),
    );
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
                        'Reservations Calendar',
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
              // Calendar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF091422).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: TableCalendar<ReservationDao>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarFormat: _calendarFormat,
                  eventLoader: _getReservationsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    markerDecoration: BoxDecoration(
                      color: Colors.cyan,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.cyan),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedDayReservations =
                            _getReservationsForDay(selectedDay);
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              SizedBox(height: 16),
              // Reservations List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyan,
                        ),
                      )
                    : _selectedDayReservations.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 80,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No reservations for this day',
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
                            itemCount: _selectedDayReservations.length,
                            itemBuilder: (context, index) {
                              final reservation =
                                  _selectedDayReservations[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF091422).withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    width: 1,
                                    color: _getStatusColor(reservation.status)
                                        .withOpacity(0.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          _getStatusColor(reservation.status)
                                              .withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    _getStatusIcon(reservation.status),
                                    color: _getStatusColor(reservation.status),
                                    size: 32,
                                  ),
                                  title: Text(
                                    reservation.visitorName ?? 'Unknown',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4),
                                      Text(
                                        'Time: ${reservation.visitTime ?? 'Not specified'}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (reservation.notes != null &&
                                          reservation.notes!.isNotEmpty)
                                        Text(
                                          reservation.notes!,
                                          style: TextStyle(
                                            color: Colors.white60,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                                  reservation.status)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          reservation.status?.toUpperCase() ??
                                              'N/A',
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                reservation.status),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: Color(0xFF091422),
                                              title: Text(
                                                'Delete Reservation',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete this reservation?',
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
                                                    _deleteReservation(
                                                        reservation
                                                            .idReservation!);
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
                                      ),
                                    ],
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
              builder: (context) => AddReservationScreen(),
            ),
          );
          if (result == true) {
            _loadReservations();
          }
        },
        backgroundColor: Colors.cyan,
        icon: Icon(Icons.add),
        label: Text('New Reservation'),
      ),
    );
  }
}
