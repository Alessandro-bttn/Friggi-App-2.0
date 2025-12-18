// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Administrador de Gastos';

  @override
  String get btnSalva => 'GUARDAR Y CONTINUAR';

  @override
  String get lingua_seleziona => 'Seleccionar Idioma';

  @override
  String get lingua_nome => 'Español';

  @override
  String get newLocale_titolo => 'Nuevo Lugar';

  @override
  String get newLocale_nomeLabel => 'Nombre del Lugar';

  @override
  String get newLocale_fotoHint => 'Toca para elegir foto';

  @override
  String get newLocale_successo => '¡Lugar creado con éxito!';

  @override
  String get ruolo_label => 'Responsable/Empleado';

  @override
  String get ruolo_dipendente => 'Empleado';

  @override
  String get ruolo_responsabile => 'Responsable';

  @override
  String get error_campiMancanti => 'Ingrese Nombre si Responsable/Empleado';

  @override
  String get error_erroreSalvataggio => 'Error al guardar el lugar';

  @override
  String get calendar_mon => 'Lun';

  @override
  String get calendar_tue => 'Mar';

  @override
  String get calendar_wed => 'Mié';

  @override
  String get calendar_thu => 'Jue';

  @override
  String get calendar_fri => 'Vie';

  @override
  String get calendar_sat => 'Sáb';

  @override
  String get calendar_sun => 'Dom';

  @override
  String get menu_titolo => 'Menú';

  @override
  String get menu_gestioneDipendenti => 'Gestión de Empleados';

  @override
  String get menu_statistiche => 'Estadísticas';

  @override
  String get menu_impostazioni => 'Ajustes';

  @override
  String get dipendenti_titolo => 'Empleados';

  @override
  String get dipendenti_nessuno => 'No se encontraron empleados';

  @override
  String get dipendenti_nuovo => 'Nuevo Empleado';

  @override
  String get dipendenti_modifica => 'Editar Empleado';

  @override
  String get label_nome => 'Nombre';

  @override
  String get label_cognome => 'Apellido';

  @override
  String get label_ore => 'Horas Previstas';

  @override
  String get label_colore => 'Color Identificativo';

  @override
  String get msg_elimina_conferma => '¿Desea eliminar este empleado?';

  @override
  String get btn_annulla => 'Cancelar';

  @override
  String get btn_conferma => 'Confirmar';

  @override
  String get settings_titolo => 'Ajustes';

  @override
  String get settings_sez_aspetto => 'Apariencia';

  @override
  String get settings_temaScuro => 'Tema Oscuro';

  @override
  String get settings_temaScuro_sub => 'Reduce la fatiga visual';

  @override
  String get settings_sez_generale => 'General';

  @override
  String get settings_notifiche => 'Notificaciones Push';

  @override
  String get settings_notifiche_sub =>
      'Recibe actualizaciones sobre los turnos';

  @override
  String get settings_lingua => 'Idioma';

  @override
  String get settings_lingua_dialog => 'Elige el idioma';

  @override
  String get settings_lingua_it => 'Italiano';

  @override
  String get settings_lingua_en => 'Inglés';

  @override
  String get settings_lingua_es => 'Español';

  @override
  String get settings_sez_info => 'Información';

  @override
  String get settings_versione => 'Versión de la App';

  @override
  String get settings_privacy => 'Política de Privacidad';

  @override
  String get settings_logout => 'Cerrar sesión';

  @override
  String get settings_turni_label => 'Número de Turnos';

  @override
  String get settings_turni_sub => 'Selecciona el número de turnos por día';

  @override
  String get settings_turni_valore_1 => 'Único (1)';

  @override
  String get settings_turni_valore_2 => 'Dos Turnos (2)';

  @override
  String get settings_turni_valore_3 => 'Tres Turnos (3)';

  @override
  String get settings_orari_label => 'Horarios de Trabajo';

  @override
  String get settings_orario_inizio => 'Inicio';

  @override
  String get settings_orario_fine => 'Fin';
}
