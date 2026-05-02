import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _localeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _eseguiRegistrazione() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService().registraNuovoUtente(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        nomeLocale: _localeController.text.trim(),
      );

      if (mounted) {
        // La navigazione non serve: AuthGate vedrà la sessione attiva
        // e ti porterà automaticamente alla RootPage
        Navigator.pop(context); // Chiude la pagina di registrazione
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrazione")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _localeController,
                decoration: const InputDecoration(labelText: "Nome del tuo Locale"),
                validator: (v) => v!.isEmpty ? "Campo obbligatorio" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _eseguiRegistrazione,
                    child: const Text("Registrati"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}