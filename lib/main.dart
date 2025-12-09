// File: lib/main.dart
import 'package:flutter/material.dart';
import 'rootPage.dart'; // Importiamo il file appena creato

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestione Spese',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Il main non sa nulla del DB, delega tutto alla RootPage
      home: const RootPage(), 
    );
  }
}