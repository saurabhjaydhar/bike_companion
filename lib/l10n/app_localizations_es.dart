// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonOther => 'Otro';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsLight => 'Claro';

  @override
  String get settingsDark => 'Oscuro';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsBuiltWithFlutter => 'Hecho con Flutter';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsSignedIn => 'Sesión iniciada';

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get settingsSignOutTitle => '¿Cerrar sesión?';

  @override
  String get settingsSignOutBody =>
      'Tus datos locales se quedan en este dispositivo. Vuelve a iniciar sesión cuando quieras.';

  @override
  String get settingsData => 'Datos';

  @override
  String get settingsClearAllData => 'Borrar todos los datos';

  @override
  String get settingsClearTitle => '¿Borrar todos los datos?';

  @override
  String get settingsClearBody =>
      'Se eliminarán de forma permanente todas las motos, registros de combustible, servicios, gastos y documentos. Esta acción no se puede deshacer.';

  @override
  String get settingsDataCleared => 'Todos los datos se han borrado';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Elimina tu cuenta de forma permanente (GDPR)';

  @override
  String get settingsDeleteAccountTitle => '¿Eliminar cuenta?';

  @override
  String get settingsDeleteAccountBody =>
      'Esto elimina de forma permanente tu cuenta de Firebase. Tus datos locales se quedan en este dispositivo. Esta acción no se puede deshacer.';

  @override
  String get settingsDeleteAccountError =>
      'No se pudo eliminar la cuenta. Vuelve a iniciar sesión e inténtalo de nuevo.';

  @override
  String get appTitle => 'Bike Companion';

  @override
  String get commonContinue => 'Continuar';

  @override
  String authSignInFailed(String error) {
    return 'Error al iniciar sesión: $error';
  }

  @override
  String get authOfflineTitle => '¿Continuar sin cuenta?';

  @override
  String get authOfflineBody =>
      'Tus datos se guardarán solo en este dispositivo. No se harán copias de seguridad ni se sincronizarán con otros dispositivos.\n\nPuedes iniciar sesión cuando quieras desde Ajustes.';

  @override
  String get authOfflineError =>
      'No se pudo iniciar la sesión sin conexión. Inténtalo de nuevo.';

  @override
  String get authTagline =>
      'Controla combustible, servicios y gastos\nde tu moto';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authContinueWithoutAccount => 'Continuar sin cuenta';

  @override
  String get authTerms =>
      'Al continuar, aceptas nuestros Términos y la Política de privacidad.';

  @override
  String get onboardingWelcomeTitle => 'Tu moto,\nsiempre en forma';

  @override
  String get onboardingWelcomeBody =>
      'Controla combustible, servicios, gastos y documentos, todo en un solo lugar. Sabrás exactamente cuándo tu moto necesita atención.';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get onboardingAddMyVehicle => 'Añadir mi moto';

  @override
  String get fieldBrand => 'Marca';

  @override
  String get fieldModel => 'Modelo';

  @override
  String get fieldModelHint => 'p. ej. Classic 350, Activa';

  @override
  String get fieldNickname => 'Apodo';

  @override
  String get fieldNicknameHint => '¿Cómo la llamas?';

  @override
  String get fieldColour => 'Color';

  @override
  String get fieldSelectDate => 'Seleccionar fecha';

  @override
  String get fieldCurrentOdometer => 'Odómetro actual (km)';

  @override
  String get fieldInsuranceExpiry => 'Vencimiento del seguro';

  @override
  String get fieldPucExpiry => 'Vencimiento del PUC';

  @override
  String get validationRequired => 'Obligatorio';

  @override
  String get validationEnterNumber => 'Introduce un número';

  @override
  String get addVehicleInvalidFormat =>
      'Formato no válido. Usa un formato como MH12DE1234 o DL01AA1234.';

  @override
  String get addVehicleNotFound => 'Vehículo no encontrado en el registro.';

  @override
  String get addVehicleApiLimit =>
      'Se alcanzó el límite de la API. Inténtalo más tarde.';

  @override
  String get addVehicleNoInternet => 'Sin conexión a internet. Revisa tu red.';

  @override
  String get addVehicleFetchFailed =>
      'No se pudieron obtener los datos del vehículo.';

  @override
  String get addVehicleTitle => 'Añade tu moto';

  @override
  String get addVehicleSubtitle =>
      'Introduce tu matrícula y obtendremos los datos de tu vehículo automáticamente.';

  @override
  String get addVehicleExamples =>
      'p. ej. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'Continuar →';

  @override
  String get addVehicleFetching => 'Obteniendo datos del vehículo…';

  @override
  String get vehicleBrandRequired => 'La marca es obligatoria';

  @override
  String get vehicleModelRequired => 'El modelo es obligatorio';

  @override
  String get vehicleSaveFailed =>
      'No se pudo guardar la moto. Inténtalo de nuevo.';

  @override
  String get vehicleDetailsTitle => 'Datos del vehículo';

  @override
  String get vehicleSectionRegistration => 'MATRÍCULA';

  @override
  String get vehicleRcNumber => 'Número de RC';

  @override
  String get vehicleSectionInfo => 'INFORMACIÓN DEL VEHÍCULO';

  @override
  String get vehicleManufacturer => 'Fabricante';

  @override
  String get vehicleFuelType => 'Tipo de combustible';

  @override
  String get vehicleClass => 'Clase de vehículo';

  @override
  String get vehicleSectionRegistrationDetails => 'DATOS DE REGISTRO';

  @override
  String get vehicleRegistrationDate => 'Fecha de registro';

  @override
  String get vehicleSectionIdentifiers => 'IDENTIFICADORES';

  @override
  String get vehicleEngineNumber => 'Número de motor';

  @override
  String get vehicleChassisNumber => 'Número de chasis';

  @override
  String get vehicleSaveVehicle => 'Guardar moto';

  @override
  String get vehicleFetchSuccess =>
      'Datos del vehículo obtenidos. Revísalos y confirma.';

  @override
  String get vehicleFetchFailure =>
      'No se pudieron obtener los datos del vehículo. Introdúcelos manualmente abajo.';

  @override
  String commonError(String error) {
    return 'Error: $error';
  }

  @override
  String get commonThisMonth => 'este mes';

  @override
  String get garageTitle => 'Mi garaje';

  @override
  String get garageEmptyTitle => 'Aún no hay motos';

  @override
  String get garageEmptyBody =>
      'Añade tu primera moto para empezar a controlar combustible, servicios y gastos.';

  @override
  String get garageYourVehicles => 'Tus motos';

  @override
  String get garageAddAnother => 'Añadir otra moto';

  @override
  String get garageStatVehicles => 'motos';

  @override
  String get garageStatAlerts => 'alertas';

  @override
  String garageDeleteVehicle(String name) {
    return 'Eliminar $name';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String get garageDeleteVehicleBody =>
      'Se eliminarán todos los registros de combustible, servicios y gastos.';

  @override
  String get commonToday => 'Hoy';

  @override
  String get commonYesterday => 'Ayer';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'Sin definir';

  @override
  String get fieldOdometer => 'Odómetro';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get dashboardLogFuel => 'Registrar repostaje';

  @override
  String get dashboardRecentActivity => 'Actividad reciente';

  @override
  String get dashboardSeeAll => 'Ver todo';

  @override
  String get dashboardThisMonth => 'Este mes';

  @override
  String get dashboardLastFuel => 'Último repostaje';

  @override
  String get dashboardNotLogged => 'Sin registros';

  @override
  String dashboardAvgMileage(String mileage) {
    return '$mileage km/L de media';
  }

  @override
  String get dashboardNextService => 'Próximo servicio';

  @override
  String get dashboardUpToDate => 'Al día';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count días',
      one: 'Queda 1 día',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'Repostaje';

  @override
  String fuelOdometerTooLow(int km) {
    return 'El odómetro debe ser mayor que el último registro ($km km)';
  }

  @override
  String get fuelLogged => '¡Repostaje registrado!';

  @override
  String get fuelCurrentOdometer => 'Odómetro actual';

  @override
  String fuelLastEntry(int km) {
    return 'Último registro: $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return '$km km desde el último repostaje · ~$litres L estimados';
  }

  @override
  String fuelKmSinceLast(int km) {
    return '$km km desde el último repostaje';
  }

  @override
  String get fuelAddMoreDetails => 'Añadir más detalles';

  @override
  String get fuelLitresFilled => 'Litros cargados';

  @override
  String get fuelAmountPaid => 'Importe pagado';

  @override
  String get fuelStationOptional => 'Gasolinera (opcional)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelReceiptSoon => '¡El escaneo de recibos llegará pronto!';

  @override
  String get fuelScanReceipt => 'Escanear recibo';

  @override
  String get fuelSave => 'Guardar repostaje';

  @override
  String get fuelHistoryTitle => 'Historial de combustible';

  @override
  String get fuelHistoryEmptyTitle => 'Aún no hay registros de combustible';

  @override
  String get fuelHistoryEmptyBody =>
      'Registra tu primer repostaje desde el panel.';

  @override
  String get fuelAvgMileageAllTime => 'Rendimiento medio (total)';

  @override
  String get fieldNotesOptional => 'Notas (opcional)';

  @override
  String get serviceStatusGood => 'Bien';

  @override
  String get serviceDueSoon => 'Próximos';

  @override
  String get serviceStatusOverdue => 'Atrasado';

  @override
  String get serviceHistory => 'Historial';

  @override
  String serviceLast(String date) {
    return 'Último: $date';
  }

  @override
  String get serviceEmptyTitle => 'No hay servicios registrados';

  @override
  String get serviceEmptyBody =>
      'Toca cualquier elemento en \"Próximos\" para registrar un servicio.';

  @override
  String get serviceLogTitle => 'Registrar servicio';

  @override
  String get serviceType => 'Tipo de servicio';

  @override
  String get serviceOdometerKm => 'Odómetro (km)';

  @override
  String get serviceCost => 'Coste (₹)';

  @override
  String get serviceNotesHint => 'Nombre del taller, piezas cambiadas...';

  @override
  String get serviceSave => 'Guardar servicio';

  @override
  String get serviceOilChange => 'Cambio de aceite';

  @override
  String get serviceOilFilter => 'Filtro de aceite';

  @override
  String get serviceAirFilter => 'Filtro de aire';

  @override
  String get serviceChainClean => 'Limpieza de cadena';

  @override
  String get serviceChainLube => 'Engrase de cadena';

  @override
  String get serviceBrakePads => 'Pastillas de freno';

  @override
  String get serviceTyres => 'Neumáticos';

  @override
  String get serviceBattery => 'Batería';

  @override
  String get serviceCoolant => 'Refrigerante';

  @override
  String get expenseFuel => 'Combustible';

  @override
  String get expenseService => 'Servicio';

  @override
  String get expenseParts => 'Piezas';

  @override
  String get expenseInsurance => 'Seguro';

  @override
  String get expenseParking => 'Aparcamiento';

  @override
  String get expenseAccessories => 'Accesorios';

  @override
  String get expenseFine => 'Multa';

  @override
  String get docRc => 'Libreta RC';

  @override
  String get docInsurance => 'Seguro';

  @override
  String get docDrivingLicence => 'Permiso de conducir';

  @override
  String get docPuc => 'Certificado PUC';

  @override
  String get docInvoice => 'Factura de compra';

  @override
  String get docWarranty => 'Tarjeta de garantía';

  @override
  String get gradeExcellent => 'Estado excelente';

  @override
  String get gradeGood => 'Buen estado';

  @override
  String get gradeFair => 'Estado aceptable';

  @override
  String get gradePoor => 'Necesita atención';

  @override
  String get gradeCritical => 'Crítico: revísala ya';

  @override
  String get expensesTitle => 'Gastos';

  @override
  String get expensesExportCsv => 'Exportar CSV';

  @override
  String get expensesByCategory => 'Por categoría';

  @override
  String get expensesTransactions => 'Movimientos';

  @override
  String get expensesEmptyTitle => 'Sin gastos';

  @override
  String get expensesEmptyBody =>
      'Toca + para añadir tu primer gasto de este mes.';

  @override
  String get expensesCsvHeader => 'Fecha,Categoría,Importe (₹),Nota';

  @override
  String expensesCsvSubject(String month) {
    return 'Gastos — $month';
  }

  @override
  String get expensesTotalSpent => 'Total gastado';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent% frente al mes pasado';
  }

  @override
  String get expensesAddTitle => 'Añadir gasto';

  @override
  String get expensesCategory => 'Categoría';

  @override
  String get expensesAmount => 'Importe (₹)';

  @override
  String get expensesNoteOptional => 'Nota (opcional)';

  @override
  String get expensesNoteHint => 'Comercio, descripción...';

  @override
  String get expensesSave => 'Guardar gasto';

  @override
  String get documentsTitle => 'Documentos';

  @override
  String get documentsEmptyTitle => 'Sin documentos';

  @override
  String get documentsEmptyBody =>
      'Guarda tu RC, seguro, PUC y más en un solo lugar.';

  @override
  String get documentsExpiringSoon => 'Vence pronto';

  @override
  String get documentsValid => 'Vigente';

  @override
  String get documentsExpired => 'Vencido';

  @override
  String get documentsNoExpiry => 'Sin vencimiento';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vence en $count días',
      one: 'Vence en 1 día',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'Eliminar documento';

  @override
  String get documentsExpiry => 'Vencimiento';

  @override
  String get documentsAddTitle => 'Añadir documento';

  @override
  String get documentsType => 'Tipo de documento';

  @override
  String get documentsTitleField => 'Título';

  @override
  String get documentsTitleHint => 'p. ej. Libreta RC, póliza n.º...';

  @override
  String get documentsExpiryOptional => 'Fecha de vencimiento (opcional)';

  @override
  String get documentsPhotoSelected => 'Foto seleccionada';

  @override
  String get documentsAttachPhoto => 'Adjuntar foto';

  @override
  String get documentsSave => 'Guardar documento';

  @override
  String get navHome => 'Inicio';

  @override
  String get navRides => 'Rutas';

  @override
  String get navDocs => 'Docs';

  @override
  String get ridesComingSoon => 'Seguimiento de rutas por GPS\nmuy pronto';

  @override
  String get noVehicleSelected =>
      'Primero selecciona una moto en la pestaña Inicio.';

  @override
  String get offlineBanner => 'Sin internet: trabajando sin conexión';

  @override
  String notifDocBody(String title, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$title vence en $days días',
      one: '$title vence mañana',
    );
    return '$_temp0';
  }

  @override
  String notifDocTitle(int days) {
    return 'Documento que vence en $days días';
  }

  @override
  String get notifDocTomorrowTitle => '¡Un documento vence mañana!';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'Servicio atrasado — $vehicle';
  }

  @override
  String notifServiceOverdueBody(String service) {
    return '$service necesita atención';
  }

  @override
  String get healthOilNone =>
      'No hay cambios de aceite registrados: registra tu primer servicio';

  @override
  String healthOilGood(int km) {
    return 'Aceite cambiado hace $km km: todo bien';
  }

  @override
  String get healthOilOverdue => '¡Cambio de aceite atrasado!';

  @override
  String healthOilDue(int km) {
    return 'Cambio de aceite en ~$km km';
  }

  @override
  String get healthChainNone => 'No hay servicios de cadena registrados';

  @override
  String healthChainGood(int km) {
    return 'Cadena revisada hace $km km';
  }

  @override
  String healthChainDue(int km) {
    return 'Servicio de cadena en ~$km km';
  }

  @override
  String get healthAirNone => 'No hay servicios de filtro de aire registrados';

  @override
  String healthAirGood(String km) {
    return 'Filtro de aire cambiado hace ${km}k km';
  }

  @override
  String get healthAirDue => 'Cambio de filtro de aire próximo';

  @override
  String get healthBrakesNone => 'No hay servicios de frenos registrados';

  @override
  String healthBrakesGood(String km) {
    return 'Frenos revisados hace ${km}k km';
  }

  @override
  String get healthBrakesDue => 'Se recomienda revisar los frenos';

  @override
  String get healthTyresNone => 'No hay servicios de neumáticos registrados';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Neumáticos cambiados hace $months meses',
      one: 'Neumáticos cambiados hace 1 mes',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'Se recomienda revisar los neumáticos';

  @override
  String get healthBatteryNone => 'No hay servicios de batería registrados';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Batería cambiada hace $months meses',
      one: 'Batería cambiada hace 1 mes',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'Se recomienda revisar la batería';

  @override
  String get healthInsuranceNotSet =>
      'Fecha de vencimiento del seguro sin definir';

  @override
  String get healthInsuranceExpired => 'Seguro VENCIDO: renuévalo de inmediato';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'El seguro vence en $days días: renuévalo ya',
      one: 'El seguro vence en 1 día: renuévalo ya',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'Seguro vigente durante $days días más';
  }

  @override
  String get healthEconomyNeedMore =>
      'Registra más repostajes para seguir el consumo';

  @override
  String healthEconomyAverage(String mileage) {
    return 'Media: $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'Consumo estable en $mileage km/L';
  }

  @override
  String get healthEconomyDropping =>
      'El rendimiento está bajando: puede que necesite un servicio';

  @override
  String get healthEconomyDeclining =>
      'El rendimiento baja ligeramente: vigílalo';

  @override
  String get addVehicleHubSubtitle =>
      'Escanea tu tarjeta RC o rellena los datos tú mismo.';

  @override
  String get addVehicleScanTitle => 'Escanear tarjeta RC';

  @override
  String get addVehicleScanBody =>
      'Haz una foto de tu RC y rellenaremos los datos.';

  @override
  String get addVehicleManualTitle => 'Introducir manualmente';

  @override
  String get addVehicleManualBody => 'Escribe tú mismo los datos de tu moto.';

  @override
  String get addVehicleLookupTitle => 'Buscar por matrícula';

  @override
  String get scanTakePhoto => 'Hacer foto';

  @override
  String get scanChooseGallery => 'Elegir de la galería';

  @override
  String get scanUseGemini => 'Leer con Gemini AI';

  @override
  String get scanUseGeminiBody =>
      'Más preciso. La foto de tu RC se envía a Google para leer los datos del vehículo. Si está desactivado, la foto solo se lee en tu móvil.';

  @override
  String get scanReading => 'Leyendo tu RC…';

  @override
  String get scanTitle => 'Escanea tu RC';

  @override
  String get scanSubtitle =>
      'Añade fotos de ambos lados de tu tarjeta RC: cada lado tiene datos distintos. Para un libro RC o un RC digital, basta con una foto.';

  @override
  String get scanFront => 'Anverso';

  @override
  String get scanFrontHint => 'Matrícula, número de chasis y de motor';

  @override
  String get scanBack => 'Reverso';

  @override
  String get scanBackHint => 'Fabricante, modelo y clase de vehículo';

  @override
  String get scanAddPhoto => 'Toca para añadir una foto';

  @override
  String get scanRemovePhoto => 'Quitar foto';

  @override
  String get scanReadDetails => 'Leer datos';

  @override
  String get scanPickerError =>
      'No se pudo abrir la cámara o la galería. Revisa los permisos de la app en Ajustes.';

  @override
  String get vehicleScanSuccess =>
      'Datos leídos de tu RC. Revísalo todo antes de guardar.';

  @override
  String get vehicleScanFailure =>
      'No se pudo leer bien tu RC. Rellena los datos a continuación.';

  @override
  String get vehicleSectionYourVehicle => 'TU MOTO';

  @override
  String get vahanSmsButton => 'Consultar en VAHAN por SMS';

  @override
  String get vahanSmsHint =>
      'Envía tu matrícula al servicio oficial de SMS de VAHAN. La respuesta llega a tus SMS: copia los datos en este formulario.';

  @override
  String get vahanSmsError => 'No se pudo abrir la app de mensajes.';
}
