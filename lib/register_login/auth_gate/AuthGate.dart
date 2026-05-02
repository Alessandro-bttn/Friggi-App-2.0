import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../MonthPage/MonthPage.dart';
import '../../NewLocale/new_locale_page.dart';
import '../../main.dart';
import '../../NewLocale/new_locale_logic.dart';
import '../../service/preferences_service.dart';
import '../LoginRegisterChoicePage.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Stadio 1: Se non loggato, Login
        if (snapshot.data?.session == null) {
          return const LoginRegisterChoicePage();
        }
        // Stadio 2: Loggato, ma dobbiamo capire quale locale caricare
        return const LocaleGate();
      },
    );
  }
}

class LocaleGate extends StatefulWidget {
  const LocaleGate({super.key});

  @override
  State<LocaleGate> createState() => _LocaleGateState();
}

class _LocaleGateState extends State<LocaleGate> {
  bool _isLoading = true;
  int? _idLocale;

  @override
  void initState() {
    super.initState();
    _verificaStatoLocale();
  }

  Future<void> _verificaStatoLocale() async {
    try {
      // Interroghiamo il DB
      final id = await NewLocaleLogic.getLocaleAttivo();
      
      if (id != null) {
        // Se troviamo un locale, salviamo e inizializziamo i dati
        await PreferencesService().setIdLocaleCorrente(id);
        
        // Inizializzazione UNA SOLA VOLTA
        await turniController.inizializzaDati(id);
        turniController.ascoltaModificheTurni();
      }
      
      if (mounted) {
        setState(() {
          _idLocale = id;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Errore critico: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stadio 3: Caricamento in corso
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    // Decidiamo la pagina finale
    if (_idLocale != null) {
      return const MonthPage();
    } else {
      return const NewLocalePage();
    }
  }
}