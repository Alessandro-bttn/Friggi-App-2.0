import 'package:flutter/material.dart';

class TurnoModel {
  final int? id;
  final int idDipendente;      // <--- RIFERIMENTO ALLA TABELLA DIPENDENTI
  final DateTime data;         // Il giorno del turno
  final TimeOfDay inizio;      // Orario inizio
  final TimeOfDay fine;        // Orario fine

  TurnoModel({
    this.id,
    required this.idDipendente,
    required this.data,
    required this.inizio,
    required this.fine,
  });

  // --- CONVERSIONE DA MAPPA (Database -> Oggetto) ---
  factory TurnoModel.fromMap(Map<String, dynamic> map) {
    TimeOfDay stringToTime(String s) {
      final parts = s.split(":");
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return TurnoModel(
      id: map['id'],
      idDipendente: map['idDipendente'], // Leggiamo l'ID
      data: DateTime.parse(map['data']), 
      inizio: stringToTime(map['inizio']),
      fine: stringToTime(map['fine']),
    );
  }

  // --- CONVERSIONE IN MAPPA (Oggetto -> Database) ---
  Map<String, dynamic> toMap() {
    String timeToString(TimeOfDay t) => "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    return {
      'id': id,
      'idDipendente': idDipendente, // Salviamo l'ID
      'data': data.toIso8601String().split('T')[0], 
      'inizio': timeToString(inizio),
      'fine': timeToString(fine),
    };
  }
}