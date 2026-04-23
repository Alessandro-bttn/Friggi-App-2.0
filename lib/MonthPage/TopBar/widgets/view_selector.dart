import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton("Giorno"),
          const SizedBox(width: 24),
          _buildButton("Settimana"),
          const SizedBox(width: 24),
          _buildButton("Mese"),
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
          // Indicatore sotto il testo
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