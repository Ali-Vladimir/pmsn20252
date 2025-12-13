class ReservationDao {
  int? idReservation;
  int? idPlanet;
  String? visitorName;
  String? reservationDate;
  String? visitTime;
  String? status;
  String? notes;
  String? createdAt;

  ReservationDao({
    this.idReservation,
    this.idPlanet,
    this.visitorName,
    this.reservationDate,
    this.visitTime,
    this.status = 'pending',
    this.notes,
    this.createdAt,
  });

  factory ReservationDao.fromMap(Map<String, dynamic> map) {
    return ReservationDao(
      idReservation: map['idReservation'],
      idPlanet: map['idPlanet'],
      visitorName: map['visitorName'],
      reservationDate: map['reservationDate'],
      visitTime: map['visitTime'],
      status: map['status'] ?? 'pending',
      notes: map['notes'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idReservation': idReservation,
      'idPlanet': idPlanet,
      'visitorName': visitorName,
      'reservationDate': reservationDate,
      'visitTime': visitTime,
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
    };
  }
}
