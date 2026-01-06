import 'package:flutter/material.dart';

// Import Database e Modelli
import '../../DataBase/Turni/TurnoModel.dart';
import '../../DataBase/Turni/TurniDB.dart';
import '../../DataBase/Dipendente/DipendenteModel.dart';
import '../../DataBase/Dipendente/DipendenteDB.dart'; 
import '../../service/preferences_service.dart';

class AddTurnoDialog extends StatefulWidget {
  final DateTime date;
  final VoidCallback onSaved; 

  const AddTurnoDialog({super.key, required this.date, required this.onSaved});

  @override
  State<AddTurnoDialog> createState() => _AddTurnoDialogState();
}

class _AddTurnoDialogState extends State<AddTurnoDialog> {
  // Stato del widget
  List<DipendenteModel> _dipendenti = [];
  DipendenteModel? _selectedDipendente;
  bool _isLoading = true;
  
  // Orari di default (puoi cambiarli se vuoi che partano dall'orario corrente)
  TimeOfDay _inizio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _fine = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _caricaDipendenti();
  }

  // Carica la lista dei dipendenti associati al locale corrente
  Future<void> _caricaDipendenti() async {
    final int? idLocale = PreferencesService().idLocaleCorrente;
    
    // Se non c'è un locale selezionato, fermiamo tutto
    if (idLocale == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      // Chiama il metodo che devi aver creato in DipendenteDB
      final lista = await DipendenteDB().getDipendentiByLocale(idLocale);
      
      if (mounted) {
        setState(() {
          _dipendenti = lista;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Errore db dipendenti: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Picker per scegliere l'orario
  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _inizio : _fine,
      builder: (context, child) {
        // Opzionale: forza il tema 24 ore se necessario
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _inizio = picked;
        } else {
          _fine = picked;
        }
      });
    }
  }

  // Salvataggio nel DB
  void _salvaTurno() async {
    if (_selectedDipendente == null || _selectedDipendente!.id == null) return;

    final nuovoTurno = TurnoModel(
      idDipendente: _selectedDipendente!.id!, // Salviamo solo l'ID (relazione)
      data: widget.date,
      inizio: _inizio,
      fine: _fine,
    );

    await TurniDB().insertTurno(nuovoTurno);
    
    widget.onSaved(); // Callback per aggiornare la pagina chiamante
    if (mounted) Navigator.pop(context); // Chiude il dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const Text("Nuovo Turno"),
          const SizedBox(height: 4),
          // Mostriamo la data selezionata in piccolo
          Text(
            "${widget.date.day}/${widget.date.month}/${widget.date.year}",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      content: _isLoading
          ? const SizedBox(
              height: 100, 
              child: Center(child: CircularProgressIndicator())
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. SELEZIONE DIPENDENTE
                DropdownButtonFormField<DipendenteModel>(
                  decoration: const InputDecoration(
                    labelText: "Dipendente",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDipendente,
                  items: _dipendenti.map((dip) {
                    return DropdownMenuItem(
                      value: dip,
                      child: Row(
                        children: [
                          // Pallino colorato con il colore del dipendente
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Color(dip.colore),
                          ),
                          const SizedBox(width: 8),
                          Text("${dip.nome} ${dip.cognome ?? ''}"),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedDipendente = val),
                  // Messaggio se la lista è vuota
                  hint: _dipendenti.isEmpty 
                      ? const Text("Nessun dipendente trovato") 
                      : const Text("Seleziona..."),
                ),

                const SizedBox(height: 24),

                // 2. SELEZIONE ORARI
                Row(
                  children: [
                    // ORA INIZIO
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTime(true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Inizio",
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _inizio.format(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ORA FINE
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickTime(false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Fine",
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _fine.format(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annulla"),
        ),
        ElevatedButton(
          onPressed: (_selectedDipendente != null) ? _salvaTurno : null,
          child: const Text("Salva"),
        ),
      ],
    );
  }
}