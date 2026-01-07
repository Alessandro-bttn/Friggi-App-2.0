import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../DataBase/Turni/TurnoModel.dart';
import '../../../DataBase/Dipendente/DipendenteModel.dart';
import 'mini_shift_widget.dart';

class WeekDayCard extends StatelessWidget {
  final DateTime dayDate;
  final bool isNextWeek;
  final int divisions; // Non serve più per il numero di slot, ma possiamo usarlo per le linee guida di sfondo
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<TurnoModel> shiftsForThisDay;
  final List<DipendenteModel> dipendenti;
  final VoidCallback onTap;

  const WeekDayCard({
    super.key,
    required this.dayDate,
    required this.isNextWeek,
    required this.divisions,
    required this.startTime,
    required this.endTime,
    required this.shiftsForThisDay,
    required this.dipendenti,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;
    final String dayName = DateFormat('EEE d', 'it').format(dayDate).toUpperCase();

    // 1. Convertiamo orari vista in minuti
    final int viewStartMin = startTime.hour * 60 + startTime.minute;
    final int viewEndMin = endTime.hour * 60 + endTime.minute;
    final int totalViewMinutes = viewEndMin - viewStartMin;

    return Expanded(
      child: Opacity(
        opacity: isNextWeek ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: isNextWeek ? theme.cardColor.withValues(alpha: 0.6) : theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: borderColor.withValues(alpha: isNextWeek ? 0.3 : 0.6)
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER (Nome Giorno)
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    dayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // AREA DI DISEGNO TEMPORALE (STACK)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxHeight = constraints.maxHeight;
                      final double maxWidth = constraints.maxWidth;

                      return Stack(
                        children: [
                          // A. SFONDO: Linee orizzontali guida
                          _buildGridLines(maxHeight, divisions, borderColor),

                          // B. I TURNI (Linee Verticali)
                          if (shiftsForThisDay.isNotEmpty && totalViewMinutes > 0)
                            ...List.generate(shiftsForThisDay.length, (index) {
                              final turno = shiftsForThisDay[index];
                              
                              // Calcolo Geometria
                              final geometry = _calculateShiftGeometry(
                                turno, 
                                viewStartMin, 
                                totalViewMinutes, 
                                maxHeight
                              );

                              // Calcolo Larghezza per non sovrapporre
                              final double barWidth = (maxWidth - 4) / shiftsForThisDay.length;
                              final double leftPos = 2 + (barWidth * index);

                              if (geometry == null) return const SizedBox();

                              return Positioned(
                                top: geometry['top'],
                                height: geometry['height'],
                                left: leftPos,
                                width: barWidth - 1,
                                child: MiniShiftWidget(
                                  turno: turno,
                                  dipendente: _findDipendente(turno.idDipendente),
                                ),
                              );
                            }),
                            
                          // C. Messaggio se vuoto
                          if (shiftsForThisDay.isEmpty)
                            Center(
                              child: Text("-", style: TextStyle(color: Colors.grey[300])),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LOGICA MATEMATICA CORRETTA ---
  
  Map<String, double>? _calculateShiftGeometry(
      TurnoModel turno, int viewStartMin, int totalViewMinutes, double maxHeight) {
    
    // CORREZIONE: Usiamo direttamente TimeOfDay (hour * 60 + minute)
    int startMin = turno.inizio.hour * 60 + turno.inizio.minute;
    int endMin = turno.fine.hour * 60 + turno.fine.minute;

    // Gestione turno notturno (es. finisce dopo mezzanotte)
    if (endMin < startMin) endMin += 24 * 60; 

    // Se il turno è completamente fuori dalla vista, non disegnarlo
    if (endMin < viewStartMin || startMin > (viewStartMin + totalViewMinutes)) {
      return null;
    }

    // Clamping: Se il turno inizia prima della vista, taglialo visivamente all'inizio
    int effectiveStart = startMin < viewStartMin ? viewStartMin : startMin;
    // Se finisce dopo la vista, taglialo alla fine
    int effectiveEnd = endMin > (viewStartMin + totalViewMinutes) 
        ? (viewStartMin + totalViewMinutes) 
        : endMin;

    // Calcolo coordinate relative (0.0 - 1.0)
    double topRatio = (effectiveStart - viewStartMin) / totalViewMinutes;
    double durationRatio = (effectiveEnd - effectiveStart) / totalViewMinutes;

    return {
      'top': topRatio * maxHeight,
      'height': durationRatio * maxHeight,
    };
  }

  // _parseTime RIMOSSO perché non serve più

  Widget _buildGridLines(double height, int divisions, Color color) {
    return Column(
      children: List.generate(divisions, (index) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: color.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  DipendenteModel? _findDipendente(int id) {
    try {
      return dipendenti.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }
}