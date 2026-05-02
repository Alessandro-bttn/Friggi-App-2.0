import '../DataBase/Locale/LocaleModel.dart';
import '../service/locale_service.dart';
import '../service/preferences_service.dart';

class NewLocaleLogic {
  static Future<void> salvaLocale({required String nome}) async {
    // 1. Creazione modello (assicurati che in LocaleModel non sia richiesto 'indirizzo')
    final nuovoLocale = LocaleModel(nome: nome);

    // 2. Salvataggio su Supabase
    // Questo metodo ora passerà solo 'nome' e 'user_id' al DB
    final localeSalvato = await LocaleService().addLocale(nuovoLocale);

    // 3. Salvataggio preferenze
    if (localeSalvato.id != null) {
      PreferencesService().idLocaleCorrente = localeSalvato.id;
    }
  }
}