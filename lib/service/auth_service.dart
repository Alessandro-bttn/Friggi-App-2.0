import 'package:supabase_flutter/supabase_flutter.dart';
import 'preferences_service.dart';

class AuthService {
  // Pattern Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _supabase = Supabase.instance.client;

  // Stream che ti avvisa se l'utente si logga o fa logout
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Recupera l'utente attualmente loggato
  User? get currentUser => _supabase.auth.currentUser;

  /// Registrazione di un nuovo utente
  Future<AuthResponse> signUp(
      {required String email, required String password}) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Errore durante la registrazione: $e');
    }
  }

  /// Login con email e password
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Errore durante il login: $e');
    }
  }

  /// Logout
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Errore durante il logout: $e');
    }
  }

  /// Recupera l'ID dell'utente (utile per le query RLS)
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Nel tuo lib/services/auth_service.dart

  Future<void> registraNuovoUtente({
    required String email,
    required String password,
    required String nomeLocale,
  }) async {
    try {
      // 1. Registrazione
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = res.user;

      // Se l'utente è null, fermiamoci subito
      if (user == null) {
        throw Exception("Registrazione fallita: utente non creato.");
      }

      // 2. Creazione Locale (solo se la registrazione ha avuto successo)
      await _supabase.from('locale').insert({
        'nome': nomeLocale,
        'user_id': user.id,
      });
    } on AuthException catch (e) {
      // Questo cattura errori specifici come "Email already registered"
      if (e.code == 'email_taken' || e.message.contains('already registered')) {
        throw Exception(
            "Questa email è già in uso. Prova ad effettuare il login.");
      }
      throw Exception("Errore autenticazione: ${e.message}");
    } on PostgrestException catch (e) {
      // Questo cattura errori di Database (es. permessi)
      throw Exception("Errore Database: ${e.message}");
    } catch (e) {
      throw Exception('Errore imprevisto: $e');
    }
  }

  Future<void> logout() async {
    try {
      // 1. Logout da Supabase
      await _supabase.auth.signOut();

      // 2. Pulisci le preferenze locali (ID locale, turni, ecc.)
      await PreferencesService().clearUserSession();

      // Nota: Non serve Navigator!
      // AuthGate vedrà che la sessione è nulla e ti riporterà
      // automaticamente alla LoginRegisterChoicePage.
    } catch (e) {
      throw Exception('Errore durante il logout: $e');
    }
  }
}
