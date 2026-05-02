import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../service/preferences_service.dart';

class NewLocaleLogic {
  /// Genera un codice alfanumerico casuale di 6 caratteri
  static String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  /// 1. Crea un nuovo locale e assegna l'utente come amministratore
  static Future<String> salvaLocale({required String nome}) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser ?? (throw "Utente non loggato");

    final codice = _generateRandomCode();

    // Inseriamo il locale
    final locale = await supabase
        .from('locale')
        .insert({
          'nome': nome,
          'codice_invito': codice,
        })
        .select('id')
        .single();

    // Colleghiamo l'utente creatore come primo dipendente/amministratore
    await supabase.from('dipendenti').insert({
      'id_locale': locale['id'],
      'user_id': user.id,
      'nome': 'Admin' // O il nome dell'utente recuperato dal profilo
    });

    return codice; // Restituiamo il codice creato per mostrarlo all'utente
  }

  /// 2. Permette a un dipendente di accedere tramite codice invito
  static Future<void> accediLocale({required String codice}) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser ?? (throw "Utente non loggato");

    // 1. Trova il locale usando il codice (case-insensitive)
    final res = await supabase
        .from('locale') // Assicurati che nel DB si chiami 'locale'
        .select('id')
        .ilike('codice_invito', codice.trim())
        .maybeSingle();

    if (res == null) throw "Codice invito non valido.";
    final int idLocale = res['id'];

    // 2. Registra l'appartenenza nella tabella di giunzione
    // Usiamo upsert per evitare errori se l'utente è già membro
    await supabase.from('workspace_members').upsert({
      'user_id': user.id,
      'locale_id': idLocale,
    });

    // 3. Salva nelle preferenze per riaprire l'app correttamente
    await PreferencesService().setIdLocaleCorrente(idLocale);

    debugPrint("Accesso al locale $idLocale effettuato.");
  }

  static Future<int?> getLocaleAttivo() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    // Cerchiamo nella tabella di giunzione
    final res = await Supabase.instance.client
        .from('workspace_members')
        .select('locale_id')
        .eq('user_id', user.id)
        .maybeSingle();

    // Se trova una riga, restituisce l'id del locale, altrimenti null
    return res?['locale_id'];
  }
}
