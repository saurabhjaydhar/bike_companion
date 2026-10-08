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
      'Deine Garage ist in deinem Google-Konto gesichert. Beim Abmelden wird sie von diesem Telefon entfernt – melde dich wieder an, um sie zurückzuholen.';

  @override
  String get settingsSignOutGuestBody =>
      'Du nutzt Garajo als Gast, deine Garage ist also nur auf diesem Telefon gespeichert. Beim Abmelden wird sie endgültig gelöscht. Sichere sie vorher bei Google, um sie zu behalten.';

  @override
  String get settingsSignOutErase => 'Löschen und abmelden';

  @override
  String get settingsSignOutUnsyncedTitle => 'Änderungen nicht gesichert';

  @override
  String get settingsSignOutUnsyncedBody =>
      'Einige neue Änderungen sind noch nicht in deiner Sicherung angekommen. Verbinde dich mit dem Internet und versuche es erneut, oder melde dich jetzt ab und verliere sie.';

  @override
  String get settingsSignOutAnyway => 'Trotzdem abmelden';

  @override
  String get settingsData => 'Daten';

  @override
  String get settingsClearAllData => 'Alle Daten löschen';

  @override
  String get settingsClearTitle => 'Alle Daten löschen?';

  @override
  String get settingsClearBody =>
      'Dadurch werden alle Fahrzeuge, Tankstopps, Wartungen, Ausgaben und Dokumente dauerhaft gelöscht – auf diesem Telefon und in deiner Sicherung. Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDataCleared => 'Alle Daten gelöscht';

  @override
  String get settingsClearError =>
      'Deine Daten konnten nicht gelöscht werden. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get settingsDeleteAccount => 'Konto löschen';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Entfernt dein Konto dauerhaft (DSGVO)';

  @override
  String get settingsDeleteAccountTitle => 'Konto löschen?';

  @override
  String get settingsDeleteAccountBody =>
      'Dadurch werden dein Konto und alles darin dauerhaft gelöscht – Fahrzeuge, Einträge und Dokumentfotos, auf diesem Telefon und in der Cloud. Das kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDeleteAccountError =>
      'Konto konnte nicht gelöscht werden. Bitte melde dich erneut an und versuche es noch einmal.';

  @override
  String get appTitle => 'Garajo';

  @override
  String get commonContinue => 'Weiter';

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
      'Kraftstoff, Wartung & Ausgaben\nfür Motorrad, Roller oder Auto';

  @override
  String get authContinueWithGoogle => 'Weiter mit Google';

  @override
  String get authContinueWithoutAccount => 'Ohne Konto fortfahren';

  @override
  String get authTerms =>
      'Mit dem Fortfahren stimmst du unseren AGB & der Datenschutzerklärung zu.';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Garajo';

  @override
  String get onboardingAddMyVehicle => 'Mein Fahrzeug hinzufügen';

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
  String get addVehicleInvalidFormat =>
      'Ungültiges Format. Nutze ein Format wie MH12DE1234 oder DL01AA1234.';

  @override
  String get addVehicleNotFound => 'Fahrzeug nicht im Register gefunden.';

  @override
  String get addVehicleApiLimit =>
      'API-Limit erreicht. Bitte versuche es später erneut.';

  @override
  String get addVehicleNoInternet =>
      'Keine Internetverbindung. Bitte prüfe dein Netzwerk.';

  @override
  String get addVehicleFetchFailed =>
      'Fahrzeugdaten konnten nicht abgerufen werden.';

  @override
  String get addVehicleTitle => 'Fahrzeug hinzufügen';

  @override
  String get addVehicleSubtitle =>
      'Gib dein Kennzeichen ein und wir laden deine Fahrzeugdaten automatisch.';

  @override
  String get addVehicleExamples => 'z. B. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'Weiter →';

  @override
  String get addVehicleFetching => 'Fahrzeugdaten werden abgerufen…';

  @override
  String get vehicleBrandRequired => 'Marke ist erforderlich';

  @override
  String get vehicleModelRequired => 'Modell ist erforderlich';

  @override
  String get vehicleSaveFailed =>
      'Fahrzeug konnte nicht gespeichert werden. Bitte erneut versuchen.';

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
  String get vehicleSaveVehicle => 'Fahrzeug speichern';

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
  String get garageEmptyTitle => 'Noch keine Fahrzeuge';

  @override
  String get garageEmptyBody =>
      'Füge dein erstes Motorrad, deinen Roller oder dein Auto hinzu, um Kraftstoff, Wartung und Ausgaben zu erfassen.';

  @override
  String get garageYourVehicles => 'Deine Fahrzeuge';

  @override
  String get garageAddAnother => 'Weiteres Fahrzeug hinzufügen';

  @override
  String get garageStatVehicles => 'Fahrzeuge';

  @override
  String get garageStatAlerts => 'Hinweise';

  @override
  String garageDeleteVehicle(String name) {
    return '$name löschen';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get garageDeleteVehicleBody =>
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
  String get navDocs => 'Doku';

  @override
  String get noVehicleSelected =>
      'Wähle zuerst auf dem Start-Tab ein Fahrzeug.';

  @override
  String get offlineBanner => 'Kein Internet – Offline-Modus';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'Wartung überfällig – $vehicle';
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

  @override
  String get addVehicleHubSubtitle =>
      'Scanne deine RC-Karte oder trag die Daten selbst ein.';

  @override
  String get addVehicleScanTitle => 'RC-Karte scannen';

  @override
  String get addVehicleScanBody =>
      'Fotografiere deine RC – wir füllen die Daten aus.';

  @override
  String get addVehicleManualTitle => 'Manuell eingeben';

  @override
  String get addVehicleManualBody => 'Gib die Fahrzeugdaten selbst ein.';

  @override
  String get addVehicleLookupTitle => 'Per Kennzeichen suchen';

  @override
  String get scanTakePhoto => 'Foto aufnehmen';

  @override
  String get scanChooseGallery => 'Aus Galerie wählen';

  @override
  String get scanUseGemini => 'Mit Gemini AI lesen';

  @override
  String get scanUseGeminiBody =>
      'Genauer. Dein RC-Foto wird an Google gesendet, um die Fahrzeugdaten zu lesen. Wenn aus, wird das Foto nur auf deinem Handy gelesen.';

  @override
  String get scanReading => 'RC wird gelesen…';

  @override
  String get scanTitle => 'RC scannen';

  @override
  String get scanSubtitle =>
      'Füge Fotos beider Seiten deiner RC-Karte hinzu – jede Seite enthält andere Angaben. Für ein RC-Heft oder eine digitale RC genügt ein Foto.';

  @override
  String get scanFront => 'Vorderseite';

  @override
  String get scanFrontHint => 'Kennzeichen, Fahrgestell- und Motornummer';

  @override
  String get scanBack => 'Rückseite';

  @override
  String get scanBackHint => 'Hersteller, Modell und Fahrzeugklasse';

  @override
  String get scanAddPhoto => 'Tippen, um ein Foto hinzuzufügen';

  @override
  String get scanRemovePhoto => 'Foto entfernen';

  @override
  String get scanReadDetails => 'Angaben lesen';

  @override
  String get scanPickerError =>
      'Kamera oder Galerie konnte nicht geöffnet werden. Prüfe die App-Berechtigungen in den Einstellungen.';

  @override
  String get vehicleScanSuccess =>
      'Daten aus deiner RC gelesen. Prüfe alles vor dem Speichern.';

  @override
  String get vehicleScanFailure =>
      'Deine RC konnte nicht klar gelesen werden. Bitte trag die Daten unten ein.';

  @override
  String get vehicleSectionYourVehicle => 'DEIN FAHRZEUG';

  @override
  String get vahanSmsButton => 'Per SMS bei VAHAN prüfen';

  @override
  String get vahanSmsHint =>
      'Sendet dein Kennzeichen an den offiziellen VAHAN-SMS-Dienst. Die Antwort kommt per SMS – übertrag die Daten in dieses Formular.';

  @override
  String get vahanSmsError => 'SMS-App konnte nicht geöffnet werden.';

  @override
  String get vehicleRegValidity => 'Zulassung gültig bis';

  @override
  String get dueRegistration => 'Zulassung';

  @override
  String notifExpiryTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item läuft in $days Tagen ab',
      one: '$item läuft morgen ab',
    );
    return '$_temp0';
  }

  @override
  String notifServiceDueTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item in $days Tagen fällig',
      one: '$item morgen fällig',
    );
    return '$_temp0';
  }

  @override
  String notifDueBody(String vehicle, String date) {
    return '$vehicle · $date. Tippen zum Aktualisieren.';
  }

  @override
  String get comingUpTitle => 'Demnächst';

  @override
  String get comingUpEmpty => 'Alles erledigt – bald ist nichts fällig.';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days Tagen',
      one: 'morgen',
      zero: 'heute',
    );
    return '$_temp0';
  }

  @override
  String dueOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage überfällig',
      one: '1 Tag überfällig',
    );
    return '$_temp0';
  }

  @override
  String get dueAddDate => 'Datum hinzufügen';

  @override
  String get dueServiceSoon => 'Bald fällig';

  @override
  String get dueServiceOverdue => 'Überfällig';

  @override
  String dueValidUntil(String item) {
    return '$item gültig bis';
  }

  @override
  String get dueUpdated => 'Datum gespeichert – Erinnerungen aktualisiert';

  @override
  String get remindersTurnOn => 'Aktivieren';

  @override
  String get remindersOffBody =>
      'Erinnerungen sind aus. Schalte sie ein, um vor Ablauf von Versicherung, PUC und Wartung informiert zu werden.';

  @override
  String get remindersMutedNote => 'Erinnerungen sind für dieses Fahrzeug aus.';

  @override
  String get remindersPermissionTitle => 'Erinnerungen erhalten?';

  @override
  String get remindersPermissionBody =>
      'Wir erinnern dich 30, 7 und 1 Tag bevor Versicherung, PUC und Dokumente ablaufen – um 9 Uhr, nie nachts.';

  @override
  String get remindersNotNow => 'Nicht jetzt';

  @override
  String get remindersEnableInSettings =>
      'Benachrichtigungen sind blockiert. Aktiviere sie für diese App in den Einstellungen deines Telefons.';

  @override
  String get settingsReminders => 'Erinnerungen';

  @override
  String settingsRemindersNext(String item, String date) {
    return 'Nächste: $item · $date';
  }

  @override
  String get settingsRemindersNone => 'Bald ist nichts fällig';

  @override
  String get expensesModeMonth => 'Monat';

  @override
  String get expensesModeYear => 'Jahr';

  @override
  String expensesVsLastYear(String percent) {
    return '$percent % ggü. Vorjahr';
  }

  @override
  String get expensesAvgMonthly => 'Ø / Monat';

  @override
  String get expensesCostPerKm => 'Kosten / km';

  @override
  String get expensesFuelPerKm => 'Kraftstoff / km';

  @override
  String get expensesNeedOdometer =>
      'Erfasse Tankstopps oder Wartungen mit Kilometerstand, um die Kosten pro km zu sehen.';

  @override
  String get expensesFromFuelLog => 'Tankstopp';

  @override
  String get expensesFromService => 'Wartung';

  @override
  String get expensesDeleted => 'Ausgabe gelöscht';

  @override
  String get commonUndo => 'Rückgängig';

  @override
  String get budgetTitle => 'Budget';

  @override
  String budgetOf(String spent, String budget) {
    return '$spent von $budget';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount übrig';
  }

  @override
  String budgetLeftOf(String left, String budget) {
    return '$left von $budget übrig';
  }

  @override
  String budgetOver(String amount) {
    return '$amount über Budget';
  }

  @override
  String get budgetSet => 'Budget festlegen';

  @override
  String get budgetSetPrompt =>
      'Lege ein Budget fest, um die Ausgaben im Griff zu behalten.';

  @override
  String get budgetSheetTitle => 'Ausgabenbudget';

  @override
  String get budgetMonthly => 'Monatsbudget';

  @override
  String get budgetYearly => 'Jahresbudget';

  @override
  String budgetSuggested(String amount) {
    return 'Vorschlag aus den letzten Monaten: $amount';
  }

  @override
  String get budgetSave => 'Budget speichern';

  @override
  String get budgetRemove => 'Budget entfernen';

  @override
  String budgetAlertTitle(String vehicle) {
    return 'Budget-Warnung — $vehicle';
  }

  @override
  String budgetAlertMonth(int percent) {
    return 'Du hast $percent % des Monatsbudgets verbraucht.';
  }

  @override
  String budgetAlertYear(int percent) {
    return 'Du hast $percent % des Jahresbudgets verbraucht.';
  }

  @override
  String get garageSpending => 'Ausgaben';

  @override
  String get garageThisYear => 'Dieses Jahr';

  @override
  String get vehicleTypeTitle => 'FAHRZEUGTYP';

  @override
  String get vehicleTypeDetected =>
      'Aus deiner RC erkannt – ändere ihn, falls er falsch ist.';

  @override
  String get vehicleTypeBike => 'Motorrad';

  @override
  String get vehicleTypeScooter => 'Roller';

  @override
  String get vehicleTypeCar => 'Auto';

  @override
  String get serviceWheelAlignment => 'Achsvermessung';

  @override
  String get serviceAcService => 'Klimaservice';

  @override
  String get serviceWipers => 'Scheibenwischer';

  @override
  String get onboardingSlideTrackTitle => 'Jede Rupie im Blick';

  @override
  String get onboardingSlideTrackBody =>
      'Kraftstoff, Wartung und Ausgaben an einem Ort – mit Budgets und Kosten pro km für jedes Fahrzeug.';

  @override
  String get onboardingSlideRemindTitle => 'Kein Termin geht verloren';

  @override
  String get onboardingSlideRemindBody =>
      'Erinnerungen vor Ablauf von Versicherung, PUC und Wartung – um 9 Uhr, nie nachts.';

  @override
  String get onboardingSlideScanTitle => 'Scannen statt tippen';

  @override
  String get onboardingSlideScanBody =>
      'Fotografiere deine RC und wir füllen die Fahrzeugdaten aus.';

  @override
  String fuelLitresFromPrice(String litres, String price) {
    return '≈ $litres L zu ₹$price/L (dein letzter Tankstopp)';
  }

  @override
  String get logButton => 'Eintragen';

  @override
  String get logSheetTitle => 'Was möchtest du eintragen?';

  @override
  String get logFuelSub => 'Liter, Kosten und Verbrauch';

  @override
  String get logExpenseSub => 'Teile, Versicherung, Parken, Maut';

  @override
  String get logServiceSub => 'Ölwechsel, Kette, Reifen';

  @override
  String get logOdometerTitle => 'Kilometerstand aktualisieren';

  @override
  String get logOdometerSub => 'Halte deine km aktuell';

  @override
  String get logDocumentSub => 'Fahrzeugschein, Versicherung, Abgas';

  @override
  String get odometerSave => 'Stand speichern';

  @override
  String get odometerUpdated => 'Kilometerstand aktualisiert';

  @override
  String get odometerInvalid => 'Gib einen Stand in km ein';

  @override
  String fuelOdometerEstimated(int km) {
    return 'Geschätzt aus deinen üblichen $km km zwischen zwei Tankstopps. Bei Bedarf anpassen.';
  }

  @override
  String fuelTripMileage(int km, String litres, String mileage) {
    return '$km km · $litres L · $mileage km/L';
  }

  @override
  String get vehicleEditTitle => 'Fahrzeug bearbeiten';

  @override
  String get vehicleUpdated => 'Fahrzeug aktualisiert';

  @override
  String get vehicleMoreDetails => 'Weitere Details';

  @override
  String get vehicleSectionDueDates => 'VERLÄNGERUNGSTERMINE';

  @override
  String get healthFuelEconomy => 'Verbrauch';

  @override
  String get healthBreakdownTitle => 'Zustandswert';

  @override
  String get healthBreakdownBody =>
      'Woraus sich der Wert zusammensetzt. Erledige die oberen Punkte, um ihn zu steigern.';

  @override
  String get healthFixLog => 'Eintragen';

  @override
  String get healthFixUpdate => 'Datum ändern';

  @override
  String get onboardingHaveAccount => 'Ich habe schon ein Konto';

  @override
  String get backupTitle => 'Sichere deine Garage';

  @override
  String get backupBody =>
      'Nur auf diesem Handy gespeichert. Melde dich mit Google an, um es zu sichern und zu synchronisieren.';

  @override
  String get backupLater => 'Später';

  @override
  String get backupAction => 'Sichern';

  @override
  String get backupDone => 'Garage in deinem Google-Konto gesichert';

  @override
  String get settingsGuest => 'Gast';

  @override
  String get tipNext => 'Weiter';

  @override
  String get tipSkip => 'Überspringen';

  @override
  String get tipGotIt => 'Verstanden';

  @override
  String get tourScoreTitle => 'Zustandswert';

  @override
  String get tourScoreBody =>
      'Wie es deinem Fahrzeug geht – aus Wartung, Versicherung und Verbrauch. Tippe darauf, um zu sehen, was zu tun ist.';

  @override
  String get tourLogTitle => 'Alles eintragen';

  @override
  String get tourLogBody =>
      'Tanken, Ausgaben, Wartung, Kilometerstand oder Dokumente – alles über diesen einen Knopf.';

  @override
  String get tourSwitchTitle => 'Deine Fahrzeuge';

  @override
  String get tourSwitchBody =>
      'Tippe auf den Namen, um das Fahrzeug zu wechseln, eins hinzuzufügen oder Details zu ändern.';

  @override
  String get tipExpenses =>
      'Wische nach links oder rechts, um den Monat zu wechseln. Lege ein Budget fest – wir warnen dich vorher.';

  @override
  String get tipService =>
      'Tippe auf einen Eintrag, um ihn zu erfassen. Wir berechnen, wann er wieder fällig ist, und erinnern dich.';

  @override
  String get tipDocuments =>
      'Füge Fahrzeugschein, Versicherung und Abgasnachweis mit Ablaufdatum hinzu. Wir erinnern dich rechtzeitig.';

  @override
  String get tipFuelLog =>
      'Nur Kilometerstand und Betrag. Liter und Verbrauch rechnen wir aus – und beim nächsten Mal tragen wir den Stand vor.';

  @override
  String get tipGarage =>
      'Tippe auf ein Fahrzeug, um es zu öffnen. Über ⋮ kannst du es bearbeiten oder löschen.';

  @override
  String get settingsShowTips => 'Tipps erneut anzeigen';

  @override
  String get settingsTipsReset =>
      'Tipps werden auf jedem Bildschirm wieder angezeigt';
}
