import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../rootPage.dart';
import 'register_login/LoginRegisterChoicePage.dart'; // Importa la tua pagina con i bottoni

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // Questo stream "ascolta" in tempo reale se l'utente è loggato o meno
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.data?.session;

        // Se c'è una sessione, vai alla RootPage (che a sua volta sceglie MonthPage o NewLocale)
        if (session != null) {
          return const RootPage();
        } 
        
        // Se NON c'è sessione, mostriamo la pagina con i bottoni (la tua UI)
        return const LoginRegisterChoicePage();
      },
    );
  }
}