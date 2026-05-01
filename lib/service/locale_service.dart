import 'package:supabase_flutter/supabase_flutter.dart';
import '../DataBase/Locale/LocaleModel.dart';

class LocaleService {
  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;
  LocaleService._internal();

  final _supabase = Supabase.instance.client;

  /// Recupera un locale specifico tramite ID
  /// (L'RLS di Supabase bloccherà l'accesso se il locale non appartiene all'utente)
  Future<LocaleModel?> getLocaleById(int id) async {
    try {
      final data =
          await _supabase.from('locale').select().eq('id', id).single();

      return LocaleModel.fromJson(data);
    } catch (e) {
      print("Errore nel recupero locale: $e");
      return null;
    }
  }

  /// Recupera tutti i locali dell'utente
  /// (L'RLS filtrerà automaticamente i risultati mostrando solo i record con il giusto user_id)
  Future<List<LocaleModel>> getAllLocali() async {
    try {
      final List<dynamic> response = await _supabase
          .from('locale')
          .select(); // Non serve aggiungere .eq('user_id', ...), l'RLS lo fa per te!

      return response.map((json) => LocaleModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Errore nel caricamento dei locali: $e');
    }
  }

  Future<LocaleModel> addLocale(LocaleModel locale) async {
    try {
      // Forza il refresh della sessione per essere sicuri
      final session = await _supabase.auth.refreshSession();
      final user =
          session.user; // Usa l'utente dalla sessione appena rinfrescata

      if (user == null) {
        throw Exception("Non c'è una sessione attiva. L'utente non è loggato.");
      }

      final client = Supabase.instance.client;
      print("--- DEBUG IDENTITÀ ---");
      print("Auth sessione presente: ${client.auth.currentSession != null}");
      print("User ID: ${client.auth.currentUser?.id}");
      print("Access Token: ${client.auth.currentSession?.accessToken != null}");
      print("----------------------");

      final json = {
        'nome': locale.nome,
        'user_id': user.id, // Questo è il pezzo mancante più probabile
      };
      json['user_id'] = user.id;

      // Aggiungi un print per debuggare il token (vedrai se è vuoto)
      print("DEBUG: Sto inviando l'inserimento con UserID: ${user.id}");

      final data =
          await _supabase.from('locale').insert(json).select().single();

      return LocaleModel.fromJson(data);
    } catch (e) {
      print(
          "DEBUG: Errore reale: $e"); // Questo ti dirà se è un errore di rete o di permessi
      throw e;
    }
  }

  /// Aggiorna le informazioni di un locale (con controllo proprietario)
  Future<void> updateLocale(LocaleModel locale) async {
    try {
      if (locale.id == null) throw Exception("ID locale mancante");

      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception("Utente non autenticato");

      await _supabase
          .from('locale')
          .update(locale.toJson())
          .eq('id', locale.id!)
          .eq('user_id', user.id); // <--- Sicurezza extra: verifica proprietà
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento del locale: $e');
    }
  }
}
