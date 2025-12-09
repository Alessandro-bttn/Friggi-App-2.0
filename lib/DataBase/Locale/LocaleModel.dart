class ItemModel {
  final int? id;          // L'ID è generato automaticamente dal DB
  final String nome;
  final String pd;        // Campo "P/D" richiesto
  final String? imagePath; // Qui salviamo solo il PERCORSO della foto

  ItemModel({
    this.id,
    required this.nome,
    required this.pd,
    this.imagePath,
  });

  // Serve per trasformare i dati dal DB (Mappa) alla nostra Classe
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      nome: map['nome'],
      pd: map['pd'],
      imagePath: map['imagePath'],
    );
  }

  // Serve per trasformare la nostra Classe in dati per il DB (Mappa)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'pd': pd,
      'imagePath': imagePath,
    };
  }
}