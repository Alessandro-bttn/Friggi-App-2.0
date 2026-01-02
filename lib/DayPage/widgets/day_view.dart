import 'package:flutter/material.dart';

// 1. WIDGET PER LA LISTA DEGLI ORARI (TIMELINE FISSA)
class DayTimeline extends StatelessWidget {
  final DateTime currentDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const DayTimeline({
    super.key,
    required this.currentDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    // CALCOLI PRELIMINARI
    final int startHour = startTime.hour;
    final int endHour = endTime.hour;
    final int totalHours = (endHour - startHour) + (endTime.minute > 0 ? 1 : 0);
    final int rowCount = totalHours + 1;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalAvailableHeight = constraints.maxHeight;
          final double hourHeight = totalAvailableHeight / rowCount;

          return Column(
            children: List.generate(rowCount, (index) {
              final int currentHour = startHour + index;
              final String hourLabel = "${currentHour.toString().padLeft(2, '0')}:00";

              return SizedBox(
                height: hourHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Colonna Orario
                    SizedBox(
                      width: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0), 
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            hourLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // B. Linea verticale
                    Container(
                      width: 1,
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),
                    // C. Spazio Vuoto
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 1,
                              color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// --- STOP! NON INSERIRE LA CLASSE DayPageFab QUI! È STATA SPOSTATA ---