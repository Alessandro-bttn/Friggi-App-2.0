class LocaleModel {
  final int? id;
  final String nome;
  final String? userId;
  final String? codiceInvito; // Campo aggiunto per la logica di invito

  LocaleModel({
    this.id,
    required this.nome,
    this.userId,
    this.codiceInvito, // Aggiunto al costruttore
  });

  factory LocaleModel.fromJson(Map<String, dynamic> json) {
    return LocaleModel(
      id: json['id'],
      nome: json['nome'],
      userId: json['user_id'],
      codiceInvito: json['codice_invito'], // Aggiunto lettura da JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'user_id': userId,
      'codice_invito': codiceInvito, // Aggiunto invio al DB
    };
  }
}