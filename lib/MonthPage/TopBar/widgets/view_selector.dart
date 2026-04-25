import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart'; 

class ViewSelector extends StatelessWidget {
  final String currentView; // Deve essere l10n.calendar_day, ecc.
  final Function(String) onViewChanged;
  
  const ViewSelector({
    super.key,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Recuperiamo l'istanza l10n corrente
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      // Usiamo un Wrap o una Row con MainAxisAlignment.center
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(l10n.calendar_day, context),
          const SizedBox(width: 24), 
          _buildButton(l10n.calendar_week, context),
          const SizedBox(width: 24),
          _buildButton(l10n.calendar_month, context),
        ],
      ),
    );
  }

  Widget _buildButton(String label, BuildContext context) {
    // Il confronto ora è sicuro perché entrambi vengono da l10n
    final bool isSelected = currentView == label;
    
    return GestureDetector(
      onTap: () => onViewChanged(label),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 0.8,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey[400],
            ),
            child: Text(label.toUpperCase()),
          ),
          const SizedBox(height: 6),
          // L'indicatore si adatta alla lunghezza del testo tradotto
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            height: 3,
            // Pro-tip: usa una larghezza proporzionale se vuoi che segua il testo
            width: isSelected ? 28 : 0, 
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}