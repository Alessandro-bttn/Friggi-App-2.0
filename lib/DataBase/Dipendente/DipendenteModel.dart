// File: lib/DataBase/Dipendente/DipendenteModel.dart

class DipendenteModel {
  final int? id;
  final int idLocale;           // <--- NUOVO CAMPO (Collegamento al Locale)
  final String nome;
  final String? cognome;
  final int colore;
  final double oreLavoro;

  const DipendenteModel({
    this.id,
    required this.idLocale,     // <--- Aggiunto al costruttore
    required this.nome,
    this.cognome,
    required this.colore,
    required this.oreLavoro,
  });

  factory DipendenteModel.fromMap(Map<String, dynamic> map) {
    return DipendenteModel(
      id: map['id'],
      idLocale: map['idLocale'], // <--- Leggi dalla mappa
      nome: map['nome'],
      cognome: map['cognome'],
      colore: map['colore'],
      oreLavoro: map['oreLavoro'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idLocale': idLocale,      // <--- Scrivi nella mappa
      'nome': nome,
      'cognome': cognome,
      'colore': colore,
      'oreLavoro': oreLavoro,
    };
  }
}