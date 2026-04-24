import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart'; 

class ViewSelector extends StatelessWidget {
  final String currentView;
  final Function(String) onViewChanged;
  
  const ViewSelector({
    super.key,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Inizializza l10n qui dentro, dove context è disponibile
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(l10n.calendar_day),
          const SizedBox(width: 24),
          _buildButton(l10n.calendar_week),
          const SizedBox(width: 24),
          _buildButton(l10n.calendar_month),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    bool isSelected = currentView == label;
    return GestureDetector(
      onTap: () => onViewChanged(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isSelected ? 20 : 0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}