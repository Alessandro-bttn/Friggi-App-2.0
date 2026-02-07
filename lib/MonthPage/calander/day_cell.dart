import 'package:flutter/material.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import '../widgets/employee_badge.dart';

class DayCell extends StatelessWidget {
  final int giorno;
  final VoidCallback onTap;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int divisions; // Mantenuto per compatibilità, ma non usato per il layout interno
  
  final List<TurnoModel> shifts; 
  final List<DipendenteModel> allDipendenti;

  const DayCell({
    super.key,
    required this.giorno,
    required this.onTap,
    required this.startTime,
    required this.endTime,
    required this.divisions,
    required this.shifts,        
    required this.allDipendenti, 
  });

  String _formatTime(BuildContext context, TimeOfDay time) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
  }

  DipendenteModel? _getDipendenteById(int id) {
    try {
      return allDipendenti.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: theme.cardColor,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // 1. INTESTAZIONE
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 4.0, 4.0, 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$giorno",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatTime(context, startTime),
                                style: TextStyle(fontSize: 9, color: theme.colorScheme.secondary, height: 1.0),
                              ),
                              Text(
                                _formatTime(context, endTime),
                                style: TextStyle(fontSize: 9, color: theme.colorScheme.secondary, height: 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. CORPO A GRIGLIA (2 COLONNE)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0), // Padding ridotto
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // --- PARAMETRI VISIVI ---
                        const double badgeSize = 18.0; 
                        const double rowSpacing = 2.0; // Spazio verticale tra le righe
                        const int columns = 2; // Numero di colonne fisso
                        
                        // Altezza disponibile
                        final double availableHeight = constraints.maxHeight;
                        
                        // Altezza di una singola riga (Badge + Spazio)
                        final double singleRowHeight = badgeSize + rowSpacing;

                        // Quante righe intere entrano in altezza?
                        final int maxRows = (availableHeight / singleRowHeight).floor();

                        // Totale slot disponibili (righe * colonne)
                        final int totalSlots = maxRows * columns;
                        final int totalShifts = shifts.length;

                        List<Widget> rows = [];

                        // --- LOGICA DI CALCOLO ---
                        if (totalShifts <= totalSlots) {
                          // CASO A: Entrano tutti
                          // Creiamo le righe necessarie
                          rows = _buildGridRows(
                            shifts, 
                            columns, 
                            badgeSize, 
                            rowSpacing
                          );
                        } else {
                          // CASO B: Overflow
                          // Riserviamo l'ULTIMA riga per l'indicatore "+N"
                          // Quindi abbiamo (maxRows - 1) righe per i badge
                          final int rowsForBadges = (maxRows > 0) ? maxRows - 1 : 0;
                          final int slotsForBadges = rowsForBadges * columns;

                          // Prendiamo i turni che entrano
                          final visibleShifts = shifts.take(slotsForBadges).toList();
                          
                          // Creiamo le righe dei badge
                          rows = _buildGridRows(
                            visibleShifts, 
                            columns, 
                            badgeSize, 
                            rowSpacing
                          );

                          // Calcoliamo i rimanenti
                          final int remaining = totalShifts - slotsForBadges;

                          // Aggiungiamo l'indicatore di overflow in fondo
                          rows.add(
                            _buildOverflowRow(remaining, badgeSize, rowSpacing, theme)
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: rows,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Costruisce le righe contenenti 2 badge ciascuna
  List<Widget> _buildGridRows(List<TurnoModel> shiftsList, int columns, double size, double spacing) {
    List<Widget> widgetRows = [];
    
    // Iteriamo con step di 2 (perché abbiamo 2 colonne)
    for (int i = 0; i < shiftsList.length; i += columns) {
      
      // Primo elemento della riga
      final t1 = shiftsList[i];
      final d1 = _getDipendenteById(t1.idDipendente);
      
      // Secondo elemento (se esiste)
      TurnoModel? t2;
      DipendenteModel? d2;
      if (i + 1 < shiftsList.length) {
        t2 = shiftsList[i + 1];
        d2 = _getDipendenteById(t2.idDipendente);
      }

      widgetRows.add(
        Container(
          margin: EdgeInsets.only(bottom: spacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // Allinea a sinistra
            children: [
              // Colonna 1
              if (d1 != null) 
                 Expanded(child: Align(alignment: Alignment.center, child: EmployeeBadge(dipendente: d1, size: size))),
              
              // Colonna 2
              if (d2 != null) 
                 Expanded(child: Align(alignment: Alignment.center, child: EmployeeBadge(dipendente: d2, size: size)))
              else 
                 const Spacer(), // Spazio vuoto se la riga è dispari
            ],
          ),
        )
      );
    }
    return widgetRows;
  }

  // Costruisce la riga finale con l'indicatore "+N"
  Widget _buildOverflowRow(int count, double size, double spacing, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing),
      // Occupa tutta la larghezza per centrare o allineare bene il testo
      width: double.infinity, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centrato nella cella
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
            ),
            alignment: Alignment.center,
            child: Text(
              "+$count",
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Testo "altri..." opzionale, se c'è spazio
          Flexible(
            child: Text(
              "altri...",
              style: TextStyle(
                fontSize: 9,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}