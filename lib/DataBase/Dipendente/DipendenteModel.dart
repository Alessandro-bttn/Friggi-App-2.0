class DipendenteModel {
  final int? id;
  final int idLocale;
  final String nome;
  final String? cognome;
  final int colore;
  final String? userId; // <--- AGGIUNTO

  const DipendenteModel({
    this.id,
    required this.idLocale,
    required this.nome,
    this.cognome,
    required this.colore,
    this.userId, // <--- AGGIUNTO
  });

  // Converti da JSON (Supabase -> Dart)
  factory DipendenteModel.fromJson(Map<String, dynamic> json) {
  return DipendenteModel(
    id: json['id'],
    // Se è int lo prende diretto, se è stringa la converte, altrimenti default 0
    idLocale: (json['id_locale'] is int) 
        ? json['id_locale'] 
        : int.tryParse(json['id_locale'].toString()) ?? 0,
    
    nome: json['nome'] ?? '',
    cognome: json['cognome'],
    
    // Fai la stessa cosa per il colore, che potrebbe arrivare come stringa
    colore: (json['colore'] is int) 
        ? json['colore'] 
        : int.tryParse(json['colore'].toString()) ?? 0xFF000000, // Colore di default
    
    userId: json['user_id'],
  );
}

  // Converti in JSON (Dart -> Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id_locale': idLocale,
      'nome': nome,
      'cognome': cognome,
      'colore': colore,
      'user_id': userId, // <--- AGGIUNTO
    };
  }
}