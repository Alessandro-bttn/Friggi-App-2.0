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
}
