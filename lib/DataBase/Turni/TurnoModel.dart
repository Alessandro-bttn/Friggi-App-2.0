import 'package:flutter/material.dart';

class TurnoModel {
  final int? id;
  final int idDipendente;
  final int idLocale;
  final String? userId;
  final DateTime data;     // <-- DateTime
  final TimeOfDay inizio;  // <-- TimeOfDay
  final TimeOfDay fine;    // <-- TimeOfDay

  TurnoModel({
    this.id,
    required this.idDipendente,
    required this.idLocale,
    this.userId,
    required this.data,
    required this.inizio,
    required this.fine,
  });

  factory TurnoModel.fromJson(Map<String, dynamic> json) {
    // Helper per trasformare una stringa "17:30:00" in TimeOfDay
    TimeOfDay stringToTime(String s) {
      final parts = s.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return TurnoModel(
      id: json['id'],
      idDipendente: json['id_dipendente'],
      idLocale: json['id_locale'],
      userId: json['user_id'],
      // Trasforma la stringa del DB (YYYY-MM-DD) in DateTime
      data: DateTime.parse(json['data']), 
      // Trasforma la stringa del DB (HH:mm:ss) in TimeOfDay
      inizio: stringToTime(json['inizio']),
      fine: stringToTime(json['fine']),
    );
  }

  Map<String, dynamic> toJson() {
    // Helper per trasformare TimeOfDay in stringa "HH:mm:00"
    String timeToString(TimeOfDay t) =>
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";

    return {
      'id_dipendente': idDipendente,
      'id_locale': idLocale,
      'user_id': userId,
      // Trasforma DateTime in stringa YYYY-MM-DD
      'data': data.toIso8601String().split('T')[0], 
      // Trasforma TimeOfDay in stringa HH:mm:00
      'inizio': timeToString(inizio), 
      'fine': timeToString(fine),      
    };
  }

  TurnoModel copyWith({
    int? id,
    int? idDipendente,
    int? idLocale,
    String? userId,
    DateTime? data,
    TimeOfDay? inizio,
    TimeOfDay? fine,
  }) {
    return TurnoModel(
      id: id ?? this.id,
      idDipendente: idDipendente ?? this.idDipendente,
      idLocale: idLocale ?? this.idLocale,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      inizio: inizio ?? this.inizio,
      fine: fine ?? this.fine,
    );
  }
}
