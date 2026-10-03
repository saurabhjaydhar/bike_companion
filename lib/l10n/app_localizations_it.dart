// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonOther => 'Altro';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsSystemDefault => 'Predefinito di sistema';

  @override
  String get settingsLight => 'Chiaro';

  @override
  String get settingsDark => 'Scuro';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsBuiltWithFlutter => 'Realizzata con Flutter';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSignedIn => 'Accesso effettuato';

  @override
  String get settingsSignOut => 'Esci';

  @override
  String get settingsSignOutTitle => 'Vuoi uscire?';

  @override
  String get settingsSignOutBody =>
      'I tuoi dati locali restano su questo dispositivo. Puoi accedere di nuovo quando vuoi.';

  @override
  String get settingsData => 'Dati';

  @override
  String get settingsClearAllData => 'Cancella tutti i dati';

  @override
  String get settingsClearTitle => 'Cancellare tutti i dati?';

  @override
  String get settingsClearBody =>
      'Verranno eliminati definitivamente tutte le moto, i rifornimenti, gli interventi, le spese e i documenti. L’operazione non può essere annullata.';

  @override
  String get settingsDataCleared => 'Tutti i dati sono stati cancellati';

  @override
  String get settingsDeleteAccount => 'Elimina account';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Rimuove definitivamente il tuo account (GDPR)';

  @override
  String get settingsDeleteAccountTitle => 'Eliminare l’account?';

  @override
  String get settingsDeleteAccountBody =>
      'Il tuo account Firebase verrà eliminato definitivamente. I tuoi dati locali restano su questo dispositivo. L’operazione non può essere annullata.';

  @override
  String get settingsDeleteAccountError =>
      'Impossibile eliminare l’account. Accedi di nuovo e riprova.';

  @override
  String get appTitle => 'Bike Companion';

  @override
  String get commonContinue => 'Continua';

  @override
  String authSignInFailed(String error) {
    return 'Accesso non riuscito: $error';
  }

  @override
  String get authOfflineTitle => 'Continuare senza account?';

  @override
  String get authOfflineBody =>
      'I tuoi dati verranno salvati solo su questo dispositivo. Non verranno sottoposti a backup né sincronizzati con altri dispositivi.\n\nPuoi accedere in qualsiasi momento dalle Impostazioni.';

  @override
  String get authOfflineError =>
      'Impossibile avviare la sessione offline. Riprova.';

  @override
  String get authTagline =>
      'Tieni traccia di carburante, tagliandi e spese\ndella tua moto';

  @override
  String get authContinueWithGoogle => 'Continua con Google';

  @override
  String get authContinueWithoutAccount => 'Continua senza account';

  @override
  String get authTerms =>
      'Continuando accetti i nostri Termini e l’Informativa sulla privacy.';

  @override
  String get onboardingWelcomeTitle => 'La tua moto,\nsempre in forma';

  @override
  String get onboardingWelcomeBody =>
      'Tieni traccia di carburante, tagliandi, spese e documenti, tutto in un unico posto. Sappi sempre quando la tua moto ha bisogno di attenzione.';

  @override
  String get onboardingGetStarted => 'Inizia';

  @override
  String get onboardingAddMyVehicle => 'Aggiungi la mia moto';

  @override
  String get fieldBrand => 'Marca';

  @override
  String get fieldModel => 'Modello';

  @override
  String get fieldModelHint => 'es. Classic 350, Activa';

  @override
  String get fieldNickname => 'Soprannome';

  @override
  String get fieldNicknameHint => 'Come la chiami?';

  @override
  String get fieldColour => 'Colore';

  @override
  String get fieldSelectDate => 'Seleziona data';

  @override
  String get fieldCurrentOdometer => 'Contachilometri attuale (km)';

  @override
  String get fieldInsuranceExpiry => 'Scadenza assicurazione';

  @override
  String get fieldPucExpiry => 'Scadenza PUC';

  @override
  String get validationRequired => 'Obbligatorio';

  @override
  String get validationEnterNumber => 'Inserisci un numero';

  @override
  String get addVehicleInvalidFormat =>
      'Formato non valido. Usa un formato come MH12DE1234 o DL01AA1234.';

  @override
  String get addVehicleNotFound => 'Veicolo non trovato nel registro.';

  @override
  String get addVehicleApiLimit => 'Limite API raggiunto. Riprova più tardi.';

  @override
  String get addVehicleNoInternet =>
      'Nessuna connessione a Internet. Controlla la tua rete.';

  @override
  String get addVehicleFetchFailed =>
      'Impossibile recuperare i dati del veicolo.';

  @override
  String get addVehicleTitle => 'Aggiungi la tua moto';

  @override
  String get addVehicleSubtitle =>
      'Inserisci la targa e recupereremo automaticamente i dati del tuo veicolo.';

  @override
  String get addVehicleExamples => 'es. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'Continua →';

  @override
  String get addVehicleFetching => 'Recupero dati del veicolo…';

  @override
  String get vehicleBrandRequired => 'La marca è obbligatoria';

  @override
  String get vehicleModelRequired => 'Il modello è obbligatorio';

  @override
  String get vehicleSaveFailed => 'Impossibile salvare la moto. Riprova.';

  @override
  String get vehicleDetailsTitle => 'Dati del veicolo';

  @override
  String get vehicleSectionRegistration => 'IMMATRICOLAZIONE';

  @override
  String get vehicleRcNumber => 'Numero RC';

  @override
  String get vehicleSectionInfo => 'INFO VEICOLO';

  @override
  String get vehicleManufacturer => 'Costruttore';

  @override
  String get vehicleFuelType => 'Alimentazione';

  @override
  String get vehicleClass => 'Categoria veicolo';

  @override
  String get vehicleSectionRegistrationDetails => 'DATI DI IMMATRICOLAZIONE';

  @override
  String get vehicleRegistrationDate => 'Data di immatricolazione';

  @override
  String get vehicleSectionIdentifiers => 'IDENTIFICATIVI';

  @override
  String get vehicleEngineNumber => 'Numero motore';

  @override
  String get vehicleChassisNumber => 'Numero di telaio';

  @override
  String get vehicleSaveVehicle => 'Salva moto';

  @override
  String get vehicleFetchSuccess =>
      'Dati del veicolo recuperati. Controlla e conferma.';

  @override
  String get vehicleFetchFailure =>
      'Impossibile recuperare i dati del veicolo. Inseriscili manualmente qui sotto.';

  @override
  String commonError(String error) {
    return 'Errore: $error';
  }

  @override
  String get commonThisMonth => 'questo mese';

  @override
  String get garageTitle => 'Il mio garage';

  @override
  String get garageEmptyTitle => 'Ancora nessuna moto';

  @override
  String get garageEmptyBody =>
      'Aggiungi la tua prima moto per tenere traccia di carburante, tagliandi e spese.';

  @override
  String get garageYourVehicles => 'Le tue moto';

  @override
  String get garageAddAnother => 'Aggiungi un’altra moto';

  @override
  String get garageStatVehicles => 'moto';

  @override
  String get garageStatAlerts => 'avvisi';

  @override
  String garageDeleteVehicle(String name) {
    return 'Elimina $name';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return 'Eliminare $name?';
  }

  @override
  String get garageDeleteVehicleBody =>
      'Verranno eliminati tutti i rifornimenti, gli interventi e le spese.';

  @override
  String get commonToday => 'Oggi';

  @override
  String get commonYesterday => 'Ieri';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni fa',
      one: '1 giorno fa',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'Non impostato';

  @override
  String get fieldOdometer => 'Contachilometri';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardLogFuel => 'Registra rifornimento';

  @override
  String get dashboardRecentActivity => 'Attività recenti';

  @override
  String get dashboardSeeAll => 'Vedi tutto';

  @override
  String get dashboardThisMonth => 'Questo mese';

  @override
  String get dashboardLastFuel => 'Ultimo pieno';

  @override
  String get dashboardNotLogged => 'Non registrato';

  @override
  String dashboardAvgMileage(String mileage) {
    return '$mileage km/L medi';
  }

  @override
  String get dashboardNextService => 'Prossimo tagliando';

  @override
  String get dashboardUpToDate => 'In regola';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mancano $count giorni',
      one: 'Manca 1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'Rifornimento';

  @override
  String fuelOdometerTooLow(int km) {
    return 'Il contachilometri deve essere maggiore dell’ultimo valore ($km km)';
  }

  @override
  String get fuelLogged => 'Rifornimento registrato!';

  @override
  String get fuelCurrentOdometer => 'Contachilometri attuale';

  @override
  String fuelLastEntry(int km) {
    return 'Ultimo valore: $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return '$km km dall’ultimo pieno · ~$litres L stimati';
  }

  @override
  String fuelKmSinceLast(int km) {
    return '$km km dall’ultimo pieno';
  }

  @override
  String get fuelAddMoreDetails => 'Aggiungi altri dettagli';

  @override
  String get fuelLitresFilled => 'Litri riforniti';

  @override
  String get fuelAmountPaid => 'Importo pagato';

  @override
  String get fuelStationOptional => 'Distributore (facoltativo)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelReceiptSoon => 'Scansione scontrini in arrivo!';

  @override
  String get fuelScanReceipt => 'Scansiona scontrino';

  @override
  String get fuelSave => 'Salva rifornimento';

  @override
  String get fuelHistoryTitle => 'Storico rifornimenti';

  @override
  String get fuelHistoryEmptyTitle => 'Ancora nessun rifornimento';

  @override
  String get fuelHistoryEmptyBody =>
      'Registra il tuo primo rifornimento dalla dashboard.';

  @override
  String get fuelAvgMileageAllTime => 'Consumo medio (totale)';

  @override
  String get fieldNotesOptional => 'Note (facoltative)';

  @override
  String get serviceStatusGood => 'Ok';

  @override
  String get serviceDueSoon => 'In scadenza';

  @override
  String get serviceStatusOverdue => 'Scaduto';

  @override
  String get serviceHistory => 'Storico';

  @override
  String serviceLast(String date) {
    return 'Ultimo: $date';
  }

  @override
  String get serviceEmptyTitle => 'Nessun intervento registrato';

  @override
  String get serviceEmptyBody =>
      'Tocca una voce in \"In scadenza\" per registrare un intervento.';

  @override
  String get serviceLogTitle => 'Registra intervento';

  @override
  String get serviceType => 'Tipo di intervento';

  @override
  String get serviceOdometerKm => 'Contachilometri (km)';

  @override
  String get serviceCost => 'Costo (₹)';

  @override
  String get serviceNotesHint => 'Officina, ricambi sostituiti...';

  @override
  String get serviceSave => 'Salva intervento';

  @override
  String get serviceOilChange => 'Cambio olio';

  @override
  String get serviceOilFilter => 'Filtro olio';

  @override
  String get serviceAirFilter => 'Filtro aria';

  @override
  String get serviceChainClean => 'Pulizia catena';

  @override
  String get serviceChainLube => 'Lubrificazione catena';

  @override
  String get serviceBrakePads => 'Pastiglie freni';

  @override
  String get serviceTyres => 'Pneumatici';

  @override
  String get serviceBattery => 'Batteria';

  @override
  String get serviceCoolant => 'Liquido refrigerante';

  @override
  String get expenseFuel => 'Carburante';

  @override
  String get expenseService => 'Tagliando';

  @override
  String get expenseParts => 'Ricambi';

  @override
  String get expenseInsurance => 'Assicurazione';

  @override
  String get expenseParking => 'Parcheggio';

  @override
  String get expenseAccessories => 'Accessori';

  @override
  String get expenseFine => 'Multa';

  @override
  String get docRc => 'Libretto (RC)';

  @override
  String get docInsurance => 'Assicurazione';

  @override
  String get docDrivingLicence => 'Patente di guida';

  @override
  String get docPuc => 'Certificato PUC';

  @override
  String get docInvoice => 'Fattura d’acquisto';

  @override
  String get docWarranty => 'Certificato di garanzia';

  @override
  String get gradeExcellent => 'Condizioni eccellenti';

  @override
  String get gradeGood => 'Buone condizioni';

  @override
  String get gradeFair => 'Condizioni discrete';

  @override
  String get gradePoor => 'Richiede attenzione';

  @override
  String get gradeCritical => 'Critico — intervieni subito';

  @override
  String get expensesTitle => 'Spese';

  @override
  String get expensesExportCsv => 'Esporta CSV';

  @override
  String get expensesByCategory => 'Per categoria';

  @override
  String get expensesTransactions => 'Movimenti';

  @override
  String get expensesEmptyTitle => 'Nessuna spesa';

  @override
  String get expensesEmptyBody =>
      'Tocca + per aggiungere la tua prima spesa del mese.';

  @override
  String get expensesCsvHeader => 'Data,Categoria,Importo (₹),Nota';

  @override
  String expensesCsvSubject(String month) {
    return 'Spese — $month';
  }

  @override
  String get expensesTotalSpent => 'Totale speso';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent% rispetto al mese scorso';
  }

  @override
  String get expensesAddTitle => 'Aggiungi spesa';

  @override
  String get expensesCategory => 'Categoria';

  @override
  String get expensesAmount => 'Importo (₹)';

  @override
  String get expensesNoteOptional => 'Nota (facoltativa)';

  @override
  String get expensesNoteHint => 'Esercente, descrizione...';

  @override
  String get expensesSave => 'Salva spesa';

  @override
  String get documentsTitle => 'Documenti';

  @override
  String get documentsEmptyTitle => 'Nessun documento';

  @override
  String get documentsEmptyBody =>
      'Conserva RC, assicurazione, PUC e altro in un unico posto.';

  @override
  String get documentsExpiringSoon => 'In scadenza';

  @override
  String get documentsValid => 'Valido';

  @override
  String get documentsExpired => 'Scaduto';

  @override
  String get documentsNoExpiry => 'Nessuna scadenza';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scade tra $count giorni',
      one: 'Scade tra 1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'Elimina documento';

  @override
  String get documentsExpiry => 'Scadenza';

  @override
  String get documentsAddTitle => 'Aggiungi documento';

  @override
  String get documentsType => 'Tipo di documento';

  @override
  String get documentsTitleField => 'Titolo';

  @override
  String get documentsTitleHint => 'es. Libretto (RC), Polizza n. ...';

  @override
  String get documentsExpiryOptional => 'Data di scadenza (facoltativa)';

  @override
  String get documentsPhotoSelected => 'Foto selezionata';

  @override
  String get documentsAttachPhoto => 'Allega foto';

  @override
  String get documentsSave => 'Salva documento';

  @override
  String get navHome => 'Home';

  @override
  String get navRides => 'Giri';

  @override
  String get navDocs => 'Documenti';

  @override
  String get ridesComingSoon => 'Tracciamento GPS dei giri\nin arrivo';

  @override
  String get noVehicleSelected => 'Seleziona prima una moto dalla scheda Home.';

  @override
  String get offlineBanner => 'Nessuna connessione — modalità offline';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'Tagliando scaduto — $vehicle';
  }

  @override
  String get healthOilNone =>
      'Nessun cambio olio registrato — registra il tuo primo intervento';

  @override
  String healthOilGood(int km) {
    return 'Olio cambiato $km km fa — tutto ok';
  }

  @override
  String get healthOilOverdue => 'Cambio olio scaduto!';

  @override
  String healthOilDue(int km) {
    return 'Cambio olio tra ~$km km';
  }

  @override
  String get healthChainNone => 'Nessuna manutenzione catena registrata';

  @override
  String healthChainGood(int km) {
    return 'Catena revisionata $km km fa';
  }

  @override
  String healthChainDue(int km) {
    return 'Manutenzione catena tra ~$km km';
  }

  @override
  String get healthAirNone => 'Nessun intervento sul filtro aria registrato';

  @override
  String healthAirGood(String km) {
    return 'Filtro aria cambiato ${km}k km fa';
  }

  @override
  String get healthAirDue => 'Cambio filtro aria in arrivo';

  @override
  String get healthBrakesNone => 'Nessun intervento sui freni registrato';

  @override
  String healthBrakesGood(String km) {
    return 'Freni controllati ${km}k km fa';
  }

  @override
  String get healthBrakesDue => 'Controllo freni consigliato';

  @override
  String get healthTyresNone => 'Nessun intervento sugli pneumatici registrato';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Pneumatici sostituiti $months mesi fa',
      one: 'Pneumatici sostituiti 1 mese fa',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'Controllo pneumatici consigliato';

  @override
  String get healthBatteryNone => 'Nessun intervento sulla batteria registrato';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Batteria sostituita $months mesi fa',
      one: 'Batteria sostituita 1 mese fa',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'Controllo batteria consigliato';

  @override
  String get healthInsuranceNotSet =>
      'Data di scadenza dell’assicurazione non impostata';

  @override
  String get healthInsuranceExpired =>
      'Assicurazione SCADUTA — rinnovala subito';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'L’assicurazione scade tra $days giorni — rinnovala ora',
      one: 'L’assicurazione scade tra 1 giorno — rinnovala ora',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'Assicurazione valida per altri $days giorni';
  }

  @override
  String get healthEconomyNeedMore =>
      'Registra altri rifornimenti per monitorare i consumi';

  @override
  String healthEconomyAverage(String mileage) {
    return 'Media: $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'Consumi stabili a $mileage km/L';
  }

  @override
  String get healthEconomyDropping =>
      'Consumi in peggioramento — potrebbe servire un tagliando';

  @override
  String get healthEconomyDeclining =>
      'Consumi in leggero peggioramento — tienili d’occhio';

  @override
  String get addVehicleHubSubtitle =>
      'Scansiona la tua carta RC o inserisci i dati tu stesso.';

  @override
  String get addVehicleScanTitle => 'Scansiona carta RC';

  @override
  String get addVehicleScanBody =>
      'Fotografa la tua RC e compiliamo noi i dati.';

  @override
  String get addVehicleManualTitle => 'Inserisci manualmente';

  @override
  String get addVehicleManualBody => 'Scrivi tu i dati della tua moto.';

  @override
  String get addVehicleLookupTitle => 'Cerca per targa';

  @override
  String get scanTakePhoto => 'Scatta foto';

  @override
  String get scanChooseGallery => 'Scegli dalla galleria';

  @override
  String get scanUseGemini => 'Leggi con Gemini AI';

  @override
  String get scanUseGeminiBody =>
      'Più preciso. La foto della RC viene inviata a Google per leggere i dati del veicolo. Se disattivato, la foto viene letta solo sul tuo telefono.';

  @override
  String get scanReading => 'Lettura della RC…';

  @override
  String get scanTitle => 'Scansiona la tua RC';

  @override
  String get scanSubtitle =>
      'Aggiungi le foto di entrambi i lati della carta RC: ogni lato ha dati diversi. Per un libretto RC o una RC digitale basta una foto.';

  @override
  String get scanFront => 'Fronte';

  @override
  String get scanFrontHint => 'Targa, numero di telaio e di motore';

  @override
  String get scanBack => 'Retro';

  @override
  String get scanBackHint => 'Costruttore, modello e classe del veicolo';

  @override
  String get scanAddPhoto => 'Tocca per aggiungere una foto';

  @override
  String get scanRemovePhoto => 'Rimuovi foto';

  @override
  String get scanReadDetails => 'Leggi i dati';

  @override
  String get scanPickerError =>
      'Impossibile aprire la fotocamera o la galleria. Controlla i permessi dell\'app nelle Impostazioni.';

  @override
  String get vehicleScanSuccess =>
      'Dati letti dalla tua RC. Controlla tutto prima di salvare.';

  @override
  String get vehicleScanFailure =>
      'Non è stato possibile leggere bene la RC. Compila i dati qui sotto.';

  @override
  String get vehicleSectionYourVehicle => 'LA TUA MOTO';

  @override
  String get vahanSmsButton => 'Verifica su VAHAN via SMS';

  @override
  String get vahanSmsHint =>
      'Invia la targa al servizio SMS ufficiale VAHAN. La risposta arriva nei tuoi SMS: copia i dati in questo modulo.';

  @override
  String get vahanSmsError => 'Impossibile aprire l’app dei messaggi.';

  @override
  String get vehicleRegValidity => 'Immatricolazione valida fino al';

  @override
  String get dueRegistration => 'Immatricolazione';

  @override
  String notifExpiryTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item scade tra $days giorni',
      one: '$item scade domani',
    );
    return '$_temp0';
  }

  @override
  String notifServiceDueTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item previsto tra $days giorni',
      one: '$item previsto domani',
    );
    return '$_temp0';
  }

  @override
  String notifDueBody(String vehicle, String date) {
    return '$vehicle · $date. Tocca per aggiornare.';
  }

  @override
  String get comingUpTitle => 'In arrivo';

  @override
  String get comingUpEmpty => 'Tutto a posto: niente in scadenza a breve.';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'tra $days giorni',
      one: 'domani',
      zero: 'oggi',
    );
    return '$_temp0';
  }

  @override
  String dueOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni di ritardo',
      one: '1 giorno di ritardo',
    );
    return '$_temp0';
  }

  @override
  String get dueAddDate => 'Aggiungi data';

  @override
  String get dueServiceSoon => 'A breve';

  @override
  String get dueServiceOverdue => 'In ritardo';

  @override
  String dueValidUntil(String item) {
    return '$item valido fino al';
  }

  @override
  String get dueUpdated => 'Data salvata: promemoria aggiornati';

  @override
  String get remindersTurnOn => 'Attiva';

  @override
  String get remindersOffBody =>
      'I promemoria sono disattivati. Attivali per sapere in anticipo quando scadono assicurazione, PUC e tagliandi.';

  @override
  String get remindersMutedNote =>
      'I promemoria sono disattivati per questo veicolo.';

  @override
  String get remindersPermissionTitle => 'Ricevere promemoria?';

  @override
  String get remindersPermissionBody =>
      'Ti avviseremo 30, 7 e 1 giorno prima della scadenza di assicurazione, PUC e documenti, alle 9 del mattino, mai di notte.';

  @override
  String get remindersNotNow => 'Non ora';

  @override
  String get remindersEnableInSettings =>
      'Le notifiche sono bloccate. Attivale per questa app nelle Impostazioni del telefono.';

  @override
  String get settingsReminders => 'Promemoria';

  @override
  String settingsRemindersNext(String item, String date) {
    return 'Prossimo: $item · $date';
  }

  @override
  String get settingsRemindersNone => 'Niente in scadenza a breve';
}
