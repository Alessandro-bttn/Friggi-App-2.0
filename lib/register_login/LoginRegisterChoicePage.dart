import 'package:flutter/material.dart';
import 'login.dart'; 
import 'RegisterPage.dart';

class LoginRegisterChoicePage extends StatelessWidget {
  const LoginRegisterChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.work_history, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text("Benvenuto!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            
            // Bottone Login
            ElevatedButton(
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              child: const Text("Accedi"),
            ),
            
            const SizedBox(height: 20),
            
            // Bottone Registrazione
            OutlinedButton(
              onPressed: () {
                // Navigazione verso la pagina di Registrazione
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const RegisterPage())
                );
              },
              child: const Text("Crea un nuovo account"),
            ),
          ],
        ),
      ),
    );
  }
}