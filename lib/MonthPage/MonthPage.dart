import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Serve per scrivere "Dicembre"
import 'package:intl/date_symbol_data_local.dart'; // Per la lingua italiana della data

// IMPORTA I TUOI FILE
import '../DataBase/Locale/LocaleDB.dart';
import '../DataBase/Locale/LocaleModel.dart';
import '../service/preferences_service.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({super.key});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  ItemModel? localeCorrente;
  bool isLoading = true;
  DateTime dataOggi = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('it_IT', null).then((_) {
      _caricaDatiLocale();
    });
  }

  // Recupera il locale selezionato usando l'ID salvato nelle preferenze
  Future<void> _caricaDatiLocale() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;

    if (idLocale != null) {
      final locale = await DBHelper().getItemById(idLocale);
      setState(() {
        localeCorrente = locale;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formattiamo il mese: es. "Dicembre" (Prima lettera maiuscola)
    String nomeMese = DateFormat('MMMM', 'it_IT').format(dataOggi);
    nomeMese = toBeginningOfSentenceCase(nomeMese) ?? nomeMese;

    // Se stiamo ancora caricando, mostra clessidra
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Costruiamo il titolo "Nome Locale - Mese"
    String titoloAppBar = localeCorrente != null 
        ? "${localeCorrente!.nome} • $nomeMese" 
        : "Nessun Locale • $nomeMese";

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Sfondo scuro come foto
      
      // --- APP BAR PERSONALIZZATA ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Grigio scuro
        elevation: 0,
        centerTitle: true, // Importante: Centra il titolo
        
        // 1. SINISTRA: Le tre lineette (Menu)
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Qui aprirai il Drawer laterale in futuro
          },
        ),

        // 2. CENTRO: Nome Locale + Mese
        title: Text(
          titoloAppBar,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),

        // 3. DESTRA: Sfera Utente con Foto
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: 18,
              // Logica Foto:
              // Se c'è un percorso E il file esiste -> Mostra Foto
              // Altrimenti -> Mostra Iniziale
              backgroundImage: (localeCorrente?.imagePath != null && File(localeCorrente!.imagePath!).existsSync())
                  ? FileImage(File(localeCorrente!.imagePath!))
                  : null,
              child: (localeCorrente?.imagePath == null)
                  ? Text(
                      localeCorrente?.nome.isNotEmpty == true 
                        ? localeCorrente!.nome[0].toUpperCase() 
                        : "U",
                      style: const TextStyle(color: Colors.white),
                    )
                  : null, // Se c'è la foto, non mostrare testo
            ),
          )
        ],
      ),

      // --- CORPO (Calendario) ---
      body: Column(
        children: [
          // Header Giorni Settimana (Lun, Mar...)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ["lun", "mar", "mer", "gio", "ven", "sab", "dom"]
                  .map((giorno) => Text(
                        giorno,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
          ),
          
          // Griglia Giorni (Esempio statico per design)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 giorni
                childAspectRatio: 0.7, // Rettangoli verticali
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 31, // Giorni simulati
              itemBuilder: (context, index) {
                final int giorno = index + 1;
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E), // Box grigio scuro
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "$giorno",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      // Qui potrai aggiungere i pallini delle attività/spese
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottone "+" Fluttuante
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
           // Aggiungi spesa
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}