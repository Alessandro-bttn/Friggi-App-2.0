// File: lib/Services/notification_service.dart
import 'package:flutter/material.dart';
import '../main.dart'; // Importa per accedere a 'navigatorKey'
import 'top_notification_card.dart';

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  OverlayEntry? _overlayEntry;

  // Mostra messaggio di SUCCESSO (Verde)
  void showSuccess(String message) {
    _show(message, Colors.green, Icons.check_circle);
  }

  // Mostra messaggio di ERRORE (Rosso)
  void showError(String message) {
    _show(message, Colors.redAccent, Icons.error_outline);
  }

  // Mostra messaggio di INFO (Blu)
  void showInfo(String message) {
    _show(message, Colors.blueAccent, Icons.info_outline);
  }

  // Logica interna
  void _show(String message, Color color, IconData icon) {
    // Se c'è già una notifica, la rimuoviamo prima di mostrarne una nuova
    removeNotification();

    // Otteniamo il contesto globale grazie alla chiave nel main
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    // Creiamo l'elemento da sovrapporre allo schermo
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: _AnimatedNotification(
          message: message,
          color: color,
          icon: icon,
          onDismiss: removeNotification,
        ),
      ),
    );

    // Inseriamo l'overlay
    navigatorKey.currentState?.overlay?.insert(_overlayEntry!);
  }

  // Funzione per chiudere la notifica
  void removeNotification() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

// PICCOLO WIDGET INTERNO PER GESTIRE L'ANIMAZIONE DI ENTRATA
class _AnimatedNotification extends StatefulWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;

  const _AnimatedNotification({
    required this.message,
    required this.color,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_AnimatedNotification> createState() => _AnimatedNotificationState();
}

class _AnimatedNotificationState extends State<_AnimatedNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    // Configura l'animazione (dura 0.5 secondi)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // L'animazione parte dall'alto fuori schermo (-1.0) e arriva in posizione (0.0)
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Effetto rimbalzo leggero
    ));

    // Avvia entrata
    _controller.forward();

    // Chiudi automaticamente dopo 3 secondi
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Avvia uscita (reverse) e poi distruggi
        _controller.reverse().then((value) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: TopNotificationCard(
        message: widget.message,
        color: widget.color,
        icon: widget.icon,
      ),
    );
  }
}