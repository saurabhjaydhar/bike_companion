// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonOther => 'Sonstiges';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsSystemDefault => 'Systemstandard';

  @override
  String get settingsLight => 'Hell';

  @override
  String get settingsDark => 'Dunkel';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsBuiltWithFlutter => 'Mit Flutter entwickelt';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsSignedIn => 'Angemeldet';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsSignOutTitle => 'Abmelden?';

  @override
  String get settingsSignOutBody =>
      'Deine lokalen Daten bleiben auf diesem Gerät. Du kannst dich jederzeit wieder anmelden.';

  @override
  String get settingsData => 'Daten';

  @override
  String get settingsClearAllData => 'Alle Daten löschen';

  @override
  String get settingsClearTitle => 'Alle Daten löschen?';

  @override
  String get settingsClearBody =>
      'Alle Bikes, Tankeinträge, Wartungen, Ausgaben und Dokumente werden dauerhaft gelöscht. Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDataCleared => 'Alle Daten gelöscht';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Entfernt dein Konto dauerhaft (DSGVO)';

  @override
  String get settingsDeleteAccountTitle => 'Konto löschen?';

  @override
  String get settingsDeleteAccountBody =>
      'Dein Firebase-Konto wird dauerhaft gelöscht. Deine lokalen Daten bleiben auf diesem Gerät. Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDeleteAccountError =>
      'Konto konnte nicht gelöscht werden. Bitte melde dich erneut an und versuche es noch einmal.';

  @override
  String get appTitle => 'Bike Companion';

  @override
  String get commonContinue => 'Weiter';

  @override
  String get commonNext => 'Weiter';

  @override
  String authSignInFailed(String error) {
    return 'Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get authOfflineTitle => 'Ohne Konto fortfahren?';

  @override
  String get authOfflineBody =>
      'Deine Daten werden nur auf diesem Gerät gespeichert. Sie werden nicht gesichert oder mit anderen Geräten synchronisiert.\n\nDu kannst dich jederzeit in den Einstellungen anmelden.';

  @override
  String get authOfflineError =>
      'Offline-Sitzung konnte nicht gestartet werden. Bitte versuche es erneut.';

  @override
  String get authTagline =>
      'Tanken, Wartung & Ausgaben\nfür dein Motorrad im Blick';

  @override
  String get authContinueWithGoogle => 'Weiter mit Google';

  @override
  String get authContinueWithoutAccount => 'Ohne Konto fortfahren';

  @override
  String get authTerms =>
      'Mit dem Fortfahren stimmst du unseren AGB & der Datenschutzerklärung zu.';

  @override
  String get onboardingWelcomeTitle => 'Dein Bike,\nimmer in Topform';

  @override
  String get onboardingWelcomeBody =>
      'Tanken, Wartung, Ausgaben und Dokumente – alles an einem Ort. Wisse genau, wann dein Bike Aufmerksamkeit braucht.';

  @override
  String get onboardingGetStarted => 'Los geht\'s';

  @override
  String get onboardingAboutBikeTitle => 'Erzähl uns von\ndeinem Bike';

  @override
  String get onboardingImportantDates => 'Wichtige Termine';

  @override
  String get onboardingRemindBody => 'Wir erinnern dich, bevor etwas abläuft.';

  @override
  String get onboardingAddMyBike => 'Bike hinzufügen';

  @override
  String get fieldBrand => 'Marke';

  @override
  String get fieldModel => 'Modell';

  @override
  String get fieldModelHint => 'z. B. Classic 350, Activa';

  @override
  String get fieldNickname => 'Spitzname';

  @override
  String get fieldNicknameHint => 'Wie nennst du es?';

  @override
  String get fieldColour => 'Farbe';

  @override
  String get fieldRegNumber => 'Kennzeichen';

  @override
  String get fieldPurchaseDateOptional => 'Kaufdatum (optional)';

  @override
  String get fieldSelectDate => 'Datum wählen';

  @override
  String get fieldCurrentOdometer => 'Aktueller km-Stand';

  @override
  String get fieldInsuranceExpiry => 'Versicherung läuft ab';

  @override
  String get fieldPucExpiry => 'PUC läuft ab';

  @override
  String get validationRequired => 'Pflichtfeld';

  @override
  String get validationEnterNumber => 'Zahl eingeben';

  @override
  String get addBikeInvalidFormat =>
      'Ungültiges Format. Nutze ein Format wie MH12DE1234 oder DL01AA1234.';

  @override
  String get addBikeNotFound => 'Fahrzeug nicht im Register gefunden.';

  @override
  String get addBikeApiLimit =>
      'API-Limit erreicht. Bitte versuche es später erneut.';

  @override
  String get addBikeNoInternet =>
      'Keine Internetverbindung. Bitte prüfe dein Netzwerk.';

  @override
  String get addBikeFetchFailed =>
      'Fahrzeugdaten konnten nicht abgerufen werden.';

  @override
  String get addBikeTitle => 'Bike hinzufügen';

  @override
  String get addBikeSubtitle =>
      'Gib dein Kennzeichen ein und wir laden deine Fahrzeugdaten automatisch.';

  @override
  String get addBikeExamples => 'z. B. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addBikeContinue => 'Weiter →';

  @override
  String get addBikeFetching => 'Fahrzeugdaten werden abgerufen…';

  @override
  String get vehicleBrandRequired => 'Marke ist erforderlich';

  @override
  String get vehicleModelRequired => 'Modell ist erforderlich';

  @override
  String get vehicleSaveFailed =>
      'Bike konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get vehicleDetailsTitle => 'Fahrzeugdaten';

  @override
  String get vehicleSectionRegistration => 'ZULASSUNG';

  @override
  String get vehicleRcNumber => 'RC-Nummer';

  @override
  String get vehicleSectionInfo => 'FAHRZEUGINFO';

  @override
  String get vehicleManufacturer => 'Hersteller';

  @override
  String get vehicleVariant => 'Variante';

  @override
  String get vehicleFuelType => 'Kraftstoff';

  @override
  String get vehicleClass => 'Fahrzeugklasse';

  @override
  String get vehicleSectionRegistrationDetails => 'ZULASSUNGSDATEN';

  @override
  String get vehicleRegistrationDate => 'Zulassungsdatum';

  @override
  String get vehicleSectionIdentifiers => 'KENNUNGEN';

  @override
  String get vehicleEngineNumber => 'Motornummer';

  @override
  String get vehicleChassisNumber => 'Fahrgestellnummer';

  @override
  String get vehicleSaveBike => 'Bike speichern';

  @override
  String get vehicleFetchSuccess =>
      'Fahrzeugdaten abgerufen. Bitte prüfen und bestätigen.';

  @override
  String get vehicleFetchFailure =>
      'Fahrzeugdaten konnten nicht abgerufen werden. Bitte gib sie unten manuell ein.';

  @override
  String commonError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get commonThisMonth => 'diesen Monat';

  @override
  String get garageTitle => 'Meine Garage';

  @override
  String get garageEmptyTitle => 'Noch keine Bikes';

  @override
  String get garageEmptyBody =>
      'Füge dein erstes Bike hinzu, um Tanken, Wartung und Ausgaben zu erfassen.';

  @override
  String get garageYourBikes => 'Deine Bikes';

  @override
  String get garageAddAnother => 'Weiteres Bike hinzufügen';

  @override
  String get garageStatBikes => 'Bikes';

  @override
  String get garageStatAlerts => 'Hinweise';

  @override
  String garageDeleteBike(String name) {
    return '$name löschen';
  }

  @override
  String garageDeleteBikeTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get garageDeleteBikeBody =>
      'Alle Tankeinträge, Wartungen und Ausgaben werden gelöscht.';

  @override
  String get commonToday => 'Heute';

  @override
  String get commonYesterday => 'Gestern';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'Nicht festgelegt';

  @override
  String get fieldOdometer => 'km-Stand';

  @override
  String get dashboardTitle => 'Übersicht';

  @override
  String get dashboardLogFuel => 'Tankstopp erfassen';

  @override
  String get dashboardRecentActivity => 'Letzte Aktivitäten';

  @override
  String get dashboardSeeAll => 'Alle ansehen';

  @override
  String get dashboardThisMonth => 'Diesen Monat';

  @override
  String get dashboardLastFuel => 'Zuletzt getankt';

  @override
  String get dashboardNotLogged => 'Nicht erfasst';

  @override
  String dashboardAvgMileage(String mileage) {
    return 'Ø $mileage km/L';
  }

  @override
  String get dashboardNextService => 'Nächste Wartung';

  @override
  String get dashboardUpToDate => 'Aktuell';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Tage',
      one: 'Noch 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'Tankstopp';

  @override
  String fuelOdometerTooLow(int km) {
    return 'km-Stand muss höher sein als beim letzten Eintrag ($km km)';
  }

  @override
  String get fuelLogged => 'Tankstopp erfasst!';

  @override
  String get fuelCurrentOdometer => 'Aktueller km-Stand';

  @override
  String fuelLastEntry(int km) {
    return 'Letzter Eintrag: $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return '$km km seit dem letzten Tanken · ca. $litres L geschätzt';
  }

  @override
  String fuelKmSinceLast(int km) {
    return '$km km seit dem letzten Tanken';
  }

  @override
  String get fuelAddMoreDetails => 'Weitere Details';

  @override
  String get fuelLitresFilled => 'Getankte Liter';

  @override
  String get fuelAmountPaid => 'Bezahlter Betrag';

  @override
  String get fuelStationOptional => 'Tankstelle (optional)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelReceiptSoon => 'Beleg-Scan kommt bald!';

  @override
  String get fuelScanReceipt => 'Beleg scannen';

  @override
  String get fuelSave => 'Tankstopp speichern';

  @override
  String get fuelHistoryTitle => 'Tankverlauf';

  @override
  String get fuelHistoryEmptyTitle => 'Noch keine Tankeinträge';

  @override
  String get fuelHistoryEmptyBody =>
      'Erfasse deinen ersten Tankstopp in der Übersicht.';

  @override
  String get fuelAvgMileageAllTime => 'Ø Verbrauch (gesamt)';

  @override
  String get fieldNotesOptional => 'Notizen (optional)';

  @override
  String get serviceStatusGood => 'Gut';

  @override
  String get serviceDueSoon => 'Bald fällig';

  @override
  String get serviceStatusOverdue => 'Überfällig';

  @override
  String get serviceHistory => 'Verlauf';

  @override
  String serviceLast(String date) {
    return 'Zuletzt: $date';
  }

  @override
  String get serviceEmptyTitle => 'Keine Wartungen erfasst';

  @override
  String get serviceEmptyBody =>
      'Tippe auf einen Eintrag unter „Bald fällig“, um eine Wartung zu erfassen.';

  @override
  String get serviceLogTitle => 'Wartung erfassen';

  @override
  String get serviceType => 'Wartungsart';

  @override
  String get serviceOdometerKm => 'km-Stand';

  @override
  String get serviceCost => 'Kosten (₹)';

  @override
  String get serviceNotesHint => 'Werkstatt, getauschte Teile...';

  @override
  String get serviceSave => 'Wartung speichern';

  @override
  String get serviceOilChange => 'Ölwechsel';

  @override
  String get serviceOilFilter => 'Ölfilter';

  @override
  String get serviceAirFilter => 'Luftfilter';

  @override
  String get serviceChainClean => 'Kette reinigen';

  @override
  String get serviceChainLube => 'Kette schmieren';

  @override
  String get serviceBrakePads => 'Bremsbeläge';

  @override
  String get serviceTyres => 'Reifen';

  @override
  String get serviceBattery => 'Batterie';

  @override
  String get serviceCoolant => 'Kühlmittel';

  @override
  String get expenseFuel => 'Kraftstoff';

  @override
  String get expenseService => 'Wartung';

  @override
  String get expenseParts => 'Teile';

  @override
  String get expenseInsurance => 'Versicherung';

  @override
  String get expenseParking => 'Parken';

  @override
  String get expenseAccessories => 'Zubehör';

  @override
  String get expenseFine => 'Bußgeld';

  @override
  String get docRc => 'Fahrzeugschein (RC)';

  @override
  String get docInsurance => 'Versicherung';

  @override
  String get docDrivingLicence => 'Führerschein';

  @override
  String get docPuc => 'PUC-Zertifikat';

  @override
  String get docInvoice => 'Kaufrechnung';

  @override
  String get docWarranty => 'Garantiekarte';

  @override
  String get gradeExcellent => 'Ausgezeichneter Zustand';

  @override
  String get gradeGood => 'Guter Zustand';

  @override
  String get gradeFair => 'Mittlerer Zustand';

  @override
  String get gradePoor => 'Braucht Aufmerksamkeit';

  @override
  String get gradeCritical => 'Kritisch – jetzt warten';

  @override
  String get expensesTitle => 'Ausgaben';

  @override
  String get expensesExportCsv => 'CSV exportieren';

  @override
  String get expensesByCategory => 'Nach Kategorie';

  @override
  String get expensesTransactions => 'Buchungen';

  @override
  String get expensesEmptyTitle => 'Keine Ausgaben';

  @override
  String get expensesEmptyBody =>
      'Tippe auf +, um deine erste Ausgabe diesen Monat hinzuzufügen.';

  @override
  String get expensesCsvHeader => 'Datum,Kategorie,Betrag (₹),Notiz';

  @override
  String expensesCsvSubject(String month) {
    return 'Ausgaben – $month';
  }

  @override
  String get expensesTotalSpent => 'Gesamtausgaben';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent % ggü. Vormonat';
  }

  @override
  String get expensesAddTitle => 'Ausgabe hinzufügen';

  @override
  String get expensesCategory => 'Kategorie';

  @override
  String get expensesAmount => 'Betrag (₹)';

  @override
  String get expensesNoteOptional => 'Notiz (optional)';

  @override
  String get expensesNoteHint => 'Händler, Beschreibung...';

  @override
  String get expensesSave => 'Ausgabe speichern';

  @override
  String get documentsTitle => 'Dokumente';

  @override
  String get documentsEmptyTitle => 'Keine Dokumente';

  @override
  String get documentsEmptyBody =>
      'Bewahre RC, Versicherung, PUC und mehr an einem Ort auf.';

  @override
  String get documentsExpiringSoon => 'Läuft bald ab';

  @override
  String get documentsValid => 'Gültig';

  @override
  String get documentsExpired => 'Abgelaufen';

  @override
  String get documentsNoExpiry => 'Kein Ablauf';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Läuft in $count Tagen ab',
      one: 'Läuft in 1 Tag ab',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'Dokument löschen';

  @override
  String get documentsExpiry => 'Ablaufdatum';

  @override
  String get documentsAddTitle => 'Dokument hinzufügen';

  @override
  String get documentsType => 'Dokumenttyp';

  @override
  String get documentsTitleField => 'Titel';

  @override
  String get documentsTitleHint => 'z. B. Fahrzeugschein, Police-Nr. ...';

  @override
  String get documentsExpiryOptional => 'Ablaufdatum (optional)';

  @override
  String get documentsPhotoSelected => 'Foto ausgewählt';

  @override
  String get documentsAttachPhoto => 'Foto anhängen';

  @override
  String get documentsSave => 'Dokument speichern';

  @override
  String get navHome => 'Start';

  @override
  String get navRides => 'Fahrten';

  @override
  String get navDocs => 'Doku';

  @override
  String get ridesComingSoon => 'GPS-Fahrtaufzeichnung\nkommt bald';

  @override
  String get noBikeSelected => 'Wähle zuerst ein Bike im Tab „Start“.';

  @override
  String get offlineBanner => 'Kein Internet – Offline-Modus';

  @override
  String notifDocBody(String title, int days) {
    return '$title läuft in $days Tagen ab';
  }

  @override
  String notifDocTitle(int days) {
    return 'Dokument läuft in $days Tagen ab';
  }

  @override
  String get notifDocTomorrowTitle => 'Dokument läuft morgen ab!';

  @override
  String notifServiceOverdueTitle(String bike) {
    return 'Wartung überfällig – $bike';
  }

  @override
  String notifServiceOverdueBody(String service) {
    return '$service braucht Aufmerksamkeit';
  }

  @override
  String get healthOilNone =>
      'Kein Ölwechsel erfasst – erfasse deine erste Wartung';

  @override
  String healthOilGood(int km) {
    return 'Ölwechsel vor $km km – alles gut';
  }

  @override
  String get healthOilOverdue => 'Ölwechsel überfällig!';

  @override
  String healthOilDue(int km) {
    return 'Ölwechsel fällig in ca. $km km';
  }

  @override
  String get healthChainNone => 'Keine Kettenwartung erfasst';

  @override
  String healthChainGood(int km) {
    return 'Kette vor $km km gewartet';
  }

  @override
  String healthChainDue(int km) {
    return 'Kettenwartung fällig in ca. $km km';
  }

  @override
  String get healthAirNone => 'Keine Luftfilterwartung erfasst';

  @override
  String healthAirGood(String km) {
    return 'Luftfilter vor ${km}k km gewechselt';
  }

  @override
  String get healthAirDue => 'Luftfilterwechsel bald fällig';

  @override
  String get healthBrakesNone => 'Keine Bremsenwartung erfasst';

  @override
  String healthBrakesGood(String km) {
    return 'Bremsen vor ${km}k km geprüft';
  }

  @override
  String get healthBrakesDue => 'Bremsenprüfung empfohlen';

  @override
  String get healthTyresNone => 'Kein Reifenservice erfasst';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Reifen vor $months Monaten gewechselt',
      one: 'Reifen vor 1 Monat gewechselt',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'Reifenprüfung empfohlen';

  @override
  String get healthBatteryNone => 'Keine Batteriewartung erfasst';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Batterie vor $months Monaten gewechselt',
      one: 'Batterie vor 1 Monat gewechselt',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'Batterieprüfung empfohlen';

  @override
  String get healthInsuranceNotSet =>
      'Ablaufdatum der Versicherung nicht festgelegt';

  @override
  String get healthInsuranceExpired =>
      'Versicherung ABGELAUFEN – sofort erneuern';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Versicherung läuft in $days Tagen ab – jetzt erneuern',
      one: 'Versicherung läuft in 1 Tag ab – jetzt erneuern',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'Versicherung noch $days Tage gültig';
  }

  @override
  String get healthEconomyNeedMore =>
      'Erfasse mehr Tankstopps, um den Verbrauch zu verfolgen';

  @override
  String healthEconomyAverage(String mileage) {
    return 'Durchschnitt: $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'Verbrauch stabil bei $mileage km/L';
  }

  @override
  String get healthEconomyDropping =>
      'Verbrauch verschlechtert sich – evtl. Wartung nötig';

  @override
  String get healthEconomyDeclining =>
      'Verbrauch verschlechtert sich leicht – im Auge behalten';
}
