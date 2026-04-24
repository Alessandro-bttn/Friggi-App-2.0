import 'package:flutter/material.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../../../l10n/app_localizations.dart'; // Assicurati che l'import sia corretto

class EmployeeDropdown extends StatelessWidget {
  final List<DipendenteModel> dipendenti;
  final DipendenteModel? selectedDipendente;
  final ValueChanged<DipendenteModel?> onChanged;

  const EmployeeDropdown({
    super.key,
    required this.dipendenti,
    required this.selectedDipendente,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DropdownButtonFormField<DipendenteModel>(
      decoration: InputDecoration(
        labelText: l10n.turni_label_dipendente, // L10N
        prefixIcon: const Icon(Icons.person_outline),
        border: const OutlineInputBorder(),
      ),
      value: selectedDipendente,
      items: dipendenti.map((dip) {
        return DropdownMenuItem(
          value: dip,
          child: Row(
            children: [
              CircleAvatar(radius: 6, backgroundColor: Color(dip.colore)),
              const SizedBox(width: 8),
              Text("${dip.nome} ${dip.cognome ?? ''}"),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text(dipendenti.isEmpty ? l10n.dipendenti_nessuno : l10n.dipendenti_seleziona), // L10N
    );
  }
}

class TimeRangeSelector extends StatelessWidget {
  final TimeOfDay inizio;
  final TimeOfDay fine;
  final Function(bool isStart) onPickTime;

  const TimeRangeSelector({
    super.key,
    required this.inizio,
    required this.fine,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(
            l10n.turni_orario_titolo, // L10N
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.1),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTimeField(context, l10n.turni_label_inizio, inizio, () => onPickTime(true)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              _buildTimeField(context, l10n.turni_label_fine, fine, () => onPickTime(false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(BuildContext context, String label, TimeOfDay time, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  time.format(context),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}