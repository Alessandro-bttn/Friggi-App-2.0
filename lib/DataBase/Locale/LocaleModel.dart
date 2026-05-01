class LocaleModel {
  final int? id;
  final String nome;
  final String? userId; // Tieni questo se ti serve per la RLS
  
  // Rimuovi 'final String indirizzo;' 

  LocaleModel({
    this.id,
    required this.nome,
    this.userId,
    // Rimuovi 'this.indirizzo' dal costruttore
  });

  factory LocaleModel.fromJson(Map<String, dynamic> json) {
    return LocaleModel(
      id: json['id'],
      nome: json['nome'],
      userId: json['user_id'],
      // Rimuovi la riga 'indirizzo: json['indirizzo']'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'user_id': userId,
      // Rimuovi 'indirizzo': indirizzo,
    };
  }
}