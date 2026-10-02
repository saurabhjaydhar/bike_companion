// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonOther => 'Autre';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsSystemDefault => 'Par défaut du système';

  @override
  String get settingsLight => 'Clair';

  @override
  String get settingsDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsBuiltWithFlutter => 'Développé avec Flutter';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsSignedIn => 'Connecté';

  @override
  String get settingsSignOut => 'Se déconnecter';

  @override
  String get settingsSignOutTitle => 'Se déconnecter ?';

  @override
  String get settingsSignOutBody =>
      'Vos données locales restent sur cet appareil. Reconnectez-vous à tout moment.';

  @override
  String get settingsData => 'Données';

  @override
  String get settingsClearAllData => 'Effacer toutes les données';

  @override
  String get settingsClearTitle => 'Effacer toutes les données ?';

  @override
  String get settingsClearBody =>
      'Toutes les motos, pleins, entretiens, dépenses et documents seront définitivement supprimés. Cette action est irréversible.';

  @override
  String get settingsDataCleared => 'Toutes les données ont été effacées';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Supprime définitivement votre compte (RGPD)';

  @override
  String get settingsDeleteAccountTitle => 'Supprimer le compte ?';

  @override
  String get settingsDeleteAccountBody =>
      'Votre compte Firebase sera définitivement supprimé. Vos données locales restent sur cet appareil. Cette action est irréversible.';

  @override
  String get settingsDeleteAccountError =>
      'Impossible de supprimer le compte. Veuillez vous reconnecter et réessayer.';

  @override
  String get appTitle => 'Bike Companion';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonNext => 'Suivant';

  @override
  String authSignInFailed(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get authOfflineTitle => 'Continuer sans compte ?';

  @override
  String get authOfflineBody =>
      'Vos données seront enregistrées uniquement sur cet appareil. Elles ne seront ni sauvegardées ni synchronisées avec d’autres appareils.\n\nVous pouvez vous connecter à tout moment depuis les Paramètres.';

  @override
  String get authOfflineError =>
      'Impossible de démarrer la session hors ligne. Veuillez réessayer.';

  @override
  String get authTagline =>
      'Suivez carburant, entretien et dépenses\nde votre moto';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authContinueWithoutAccount => 'Continuer sans compte';

  @override
  String get authTerms =>
      'En continuant, vous acceptez nos Conditions d’utilisation et notre Politique de confidentialité.';

  @override
  String get onboardingWelcomeTitle => 'Votre moto,\ntoujours en forme';

  @override
  String get onboardingWelcomeBody =>
      'Suivez carburant, entretien, dépenses et documents — tout au même endroit. Sachez exactement quand votre moto a besoin d’attention.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingAboutBikeTitle => 'Parlez-nous de\nvotre moto';

  @override
  String get onboardingImportantDates => 'Dates importantes';

  @override
  String get onboardingRemindBody =>
      'Nous vous préviendrons avant toute échéance.';

  @override
  String get onboardingAddMyBike => 'Ajouter ma moto';

  @override
  String get fieldBrand => 'Marque';

  @override
  String get fieldModel => 'Modèle';

  @override
  String get fieldModelHint => 'ex. Classic 350, Activa';

  @override
  String get fieldNickname => 'Surnom';

  @override
  String get fieldNicknameHint => 'Comment l’appelez-vous ?';

  @override
  String get fieldColour => 'Couleur';

  @override
  String get fieldRegNumber => 'Numéro d’immatriculation';

  @override
  String get fieldPurchaseDateOptional => 'Date d’achat (facultatif)';

  @override
  String get fieldSelectDate => 'Choisir une date';

  @override
  String get fieldCurrentOdometer => 'Kilométrage actuel (km)';

  @override
  String get fieldInsuranceExpiry => 'Expiration de l’assurance';

  @override
  String get fieldPucExpiry => 'Expiration du PUC';

  @override
  String get validationRequired => 'Obligatoire';

  @override
  String get validationEnterNumber => 'Saisissez un nombre';

  @override
  String get addBikeInvalidFormat =>
      'Format invalide. Utilisez un format comme MH12DE1234 ou DL01AA1234.';

  @override
  String get addBikeNotFound => 'Véhicule introuvable dans le registre.';

  @override
  String get addBikeApiLimit =>
      'Limite de l’API atteinte. Veuillez réessayer plus tard.';

  @override
  String get addBikeNoInternet =>
      'Pas de connexion Internet. Veuillez vérifier votre réseau.';

  @override
  String get addBikeFetchFailed =>
      'Impossible de récupérer les informations du véhicule.';

  @override
  String get addBikeTitle => 'Ajoutez votre moto';

  @override
  String get addBikeSubtitle =>
      'Saisissez votre numéro d’immatriculation et nous récupérerons automatiquement les informations de votre véhicule.';

  @override
  String get addBikeExamples => 'ex. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addBikeContinue => 'Continuer →';

  @override
  String get addBikeFetching => 'Récupération des informations du véhicule…';

  @override
  String get vehicleBrandRequired => 'La marque est obligatoire';

  @override
  String get vehicleModelRequired => 'Le modèle est obligatoire';

  @override
  String get vehicleSaveFailed =>
      'Échec de l’enregistrement de la moto. Veuillez réessayer.';

  @override
  String get vehicleDetailsTitle => 'Détails du véhicule';

  @override
  String get vehicleSectionRegistration => 'IMMATRICULATION';

  @override
  String get vehicleRcNumber => 'Numéro RC';

  @override
  String get vehicleSectionInfo => 'INFOS VÉHICULE';

  @override
  String get vehicleManufacturer => 'Constructeur';

  @override
  String get vehicleVariant => 'Version';

  @override
  String get vehicleFuelType => 'Carburant';

  @override
  String get vehicleClass => 'Catégorie de véhicule';

  @override
  String get vehicleSectionRegistrationDetails => 'DÉTAILS D’IMMATRICULATION';

  @override
  String get vehicleRegistrationDate => 'Date d’immatriculation';

  @override
  String get vehicleSectionIdentifiers => 'IDENTIFIANTS';

  @override
  String get vehicleEngineNumber => 'Numéro de moteur';

  @override
  String get vehicleChassisNumber => 'Numéro de châssis';

  @override
  String get vehicleSaveBike => 'Enregistrer la moto';

  @override
  String get vehicleFetchSuccess =>
      'Informations du véhicule récupérées. Vérifiez et confirmez.';

  @override
  String get vehicleFetchFailure =>
      'Impossible de récupérer les informations du véhicule. Veuillez les saisir manuellement ci-dessous.';

  @override
  String commonError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get commonThisMonth => 'ce mois-ci';

  @override
  String get garageTitle => 'Mon garage';

  @override
  String get garageEmptyTitle => 'Aucune moto';

  @override
  String get garageEmptyBody =>
      'Ajoutez votre première moto pour suivre carburant, entretien et dépenses.';

  @override
  String get garageYourBikes => 'Vos motos';

  @override
  String get garageAddAnother => 'Ajouter une moto';

  @override
  String get garageStatBikes => 'motos';

  @override
  String get garageStatAlerts => 'alertes';

  @override
  String garageDeleteBike(String name) {
    return 'Supprimer $name';
  }

  @override
  String garageDeleteBikeTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get garageDeleteBikeBody =>
      'Tous les pleins, entretiens et dépenses seront supprimés.';

  @override
  String get commonToday => 'Aujourd’hui';

  @override
  String get commonYesterday => 'Hier';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'Non défini';

  @override
  String get fieldOdometer => 'Kilométrage';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get dashboardLogFuel => 'Ajouter un plein';

  @override
  String get dashboardRecentActivity => 'Activité récente';

  @override
  String get dashboardSeeAll => 'Tout voir';

  @override
  String get dashboardThisMonth => 'Ce mois-ci';

  @override
  String get dashboardLastFuel => 'Dernier plein';

  @override
  String get dashboardNotLogged => 'Non renseigné';

  @override
  String dashboardAvgMileage(String mileage) {
    return '$mileage km/L moy.';
  }

  @override
  String get dashboardNextService => 'Prochain entretien';

  @override
  String get dashboardUpToDate => 'À jour';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'Plein';

  @override
  String fuelOdometerTooLow(int km) {
    return 'Le kilométrage doit être supérieur à la dernière saisie ($km km)';
  }

  @override
  String get fuelLogged => 'Plein enregistré !';

  @override
  String get fuelCurrentOdometer => 'Kilométrage actuel';

  @override
  String fuelLastEntry(int km) {
    return 'Dernière saisie : $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return '$km km depuis le dernier plein · ~$litres L estimés';
  }

  @override
  String fuelKmSinceLast(int km) {
    return '$km km depuis le dernier plein';
  }

  @override
  String get fuelAddMoreDetails => 'Ajouter des détails';

  @override
  String get fuelLitresFilled => 'Litres';

  @override
  String get fuelAmountPaid => 'Montant payé';

  @override
  String get fuelStationOptional => 'Station-service (facultatif)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelReceiptSoon => 'Scan des reçus bientôt disponible !';

  @override
  String get fuelScanReceipt => 'Scanner le reçu';

  @override
  String get fuelSave => 'Enregistrer le plein';

  @override
  String get fuelHistoryTitle => 'Historique des pleins';

  @override
  String get fuelHistoryEmptyTitle => 'Aucun plein';

  @override
  String get fuelHistoryEmptyBody =>
      'Enregistrez votre premier plein depuis le tableau de bord.';

  @override
  String get fuelAvgMileageAllTime => 'Consommation moyenne (depuis le début)';

  @override
  String get fieldNotesOptional => 'Notes (facultatif)';

  @override
  String get serviceStatusGood => 'Bon';

  @override
  String get serviceDueSoon => 'À prévoir';

  @override
  String get serviceStatusOverdue => 'En retard';

  @override
  String get serviceHistory => 'Historique';

  @override
  String serviceLast(String date) {
    return 'Dernier : $date';
  }

  @override
  String get serviceEmptyTitle => 'Aucun entretien';

  @override
  String get serviceEmptyBody =>
      'Appuyez sur un élément dans « À prévoir » pour enregistrer un entretien.';

  @override
  String get serviceLogTitle => 'Enregistrer un entretien';

  @override
  String get serviceType => 'Type d’entretien';

  @override
  String get serviceOdometerKm => 'Kilométrage (km)';

  @override
  String get serviceCost => 'Coût (₹)';

  @override
  String get serviceNotesHint => 'Garage, pièces remplacées...';

  @override
  String get serviceSave => 'Enregistrer l’entretien';

  @override
  String get serviceOilChange => 'Vidange';

  @override
  String get serviceOilFilter => 'Filtre à huile';

  @override
  String get serviceAirFilter => 'Filtre à air';

  @override
  String get serviceChainClean => 'Nettoyage chaîne';

  @override
  String get serviceChainLube => 'Graissage chaîne';

  @override
  String get serviceBrakePads => 'Plaquettes de frein';

  @override
  String get serviceTyres => 'Pneus';

  @override
  String get serviceBattery => 'Batterie';

  @override
  String get serviceCoolant => 'Liquide de refroidissement';

  @override
  String get expenseFuel => 'Carburant';

  @override
  String get expenseService => 'Entretien';

  @override
  String get expenseParts => 'Pièces';

  @override
  String get expenseInsurance => 'Assurance';

  @override
  String get expenseParking => 'Stationnement';

  @override
  String get expenseAccessories => 'Accessoires';

  @override
  String get expenseFine => 'Amende';

  @override
  String get docRc => 'Carte grise (RC)';

  @override
  String get docInsurance => 'Assurance';

  @override
  String get docDrivingLicence => 'Permis de conduire';

  @override
  String get docPuc => 'Certificat PUC';

  @override
  String get docInvoice => 'Facture d’achat';

  @override
  String get docWarranty => 'Carte de garantie';

  @override
  String get gradeExcellent => 'Excellent état';

  @override
  String get gradeGood => 'Bon état';

  @override
  String get gradeFair => 'État correct';

  @override
  String get gradePoor => 'Attention requise';

  @override
  String get gradeCritical => 'Critique — entretien immédiat';

  @override
  String get expensesTitle => 'Dépenses';

  @override
  String get expensesExportCsv => 'Exporter en CSV';

  @override
  String get expensesByCategory => 'Par catégorie';

  @override
  String get expensesTransactions => 'Transactions';

  @override
  String get expensesEmptyTitle => 'Aucune dépense';

  @override
  String get expensesEmptyBody =>
      'Appuyez sur + pour ajouter votre première dépense du mois.';

  @override
  String get expensesCsvHeader => 'Date,Catégorie,Montant (₹),Note';

  @override
  String expensesCsvSubject(String month) {
    return 'Dépenses — $month';
  }

  @override
  String get expensesTotalSpent => 'Total dépensé';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent % par rapport au mois dernier';
  }

  @override
  String get expensesAddTitle => 'Ajouter une dépense';

  @override
  String get expensesCategory => 'Catégorie';

  @override
  String get expensesAmount => 'Montant (₹)';

  @override
  String get expensesNoteOptional => 'Note (facultatif)';

  @override
  String get expensesNoteHint => 'Commerçant, description...';

  @override
  String get expensesSave => 'Enregistrer la dépense';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsEmptyTitle => 'Aucun document';

  @override
  String get documentsEmptyBody =>
      'Rangez votre RC, assurance, PUC et plus encore au même endroit.';

  @override
  String get documentsExpiringSoon => 'Expire bientôt';

  @override
  String get documentsValid => 'Valide';

  @override
  String get documentsExpired => 'Expiré';

  @override
  String get documentsNoExpiry => 'Sans expiration';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expire dans $count jours',
      one: 'Expire dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'Supprimer le document';

  @override
  String get documentsExpiry => 'Expiration';

  @override
  String get documentsAddTitle => 'Ajouter un document';

  @override
  String get documentsType => 'Type de document';

  @override
  String get documentsTitleField => 'Titre';

  @override
  String get documentsTitleHint => 'ex. Carte grise, Police n°...';

  @override
  String get documentsExpiryOptional => 'Date d’expiration (facultatif)';

  @override
  String get documentsPhotoSelected => 'Photo sélectionnée';

  @override
  String get documentsAttachPhoto => 'Joindre une photo';

  @override
  String get documentsSave => 'Enregistrer le document';

  @override
  String get navHome => 'Accueil';

  @override
  String get navRides => 'Trajets';

  @override
  String get navDocs => 'Docs';

  @override
  String get ridesComingSoon => 'Suivi des trajets GPS\nbientôt disponible';

  @override
  String get noBikeSelected =>
      'Sélectionnez d’abord une moto dans l’onglet Accueil.';

  @override
  String get offlineBanner => 'Pas d’Internet — mode hors ligne';

  @override
  String notifDocBody(String title, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$title expire dans $days jours',
      one: '$title expire demain',
    );
    return '$_temp0';
  }

  @override
  String notifDocTitle(int days) {
    return 'Document expirant dans $days jours';
  }

  @override
  String get notifDocTomorrowTitle => 'Un document expire demain !';

  @override
  String notifServiceOverdueTitle(String bike) {
    return 'Entretien en retard — $bike';
  }

  @override
  String notifServiceOverdueBody(String service) {
    return '$service nécessite votre attention';
  }

  @override
  String get healthOilNone =>
      'Aucune vidange enregistrée — ajoutez votre premier entretien';

  @override
  String healthOilGood(int km) {
    return 'Vidange il y a $km km — tout va bien';
  }

  @override
  String get healthOilOverdue => 'Vidange en retard !';

  @override
  String healthOilDue(int km) {
    return 'Vidange dans ~$km km';
  }

  @override
  String get healthChainNone => 'Aucun entretien de chaîne enregistré';

  @override
  String healthChainGood(int km) {
    return 'Chaîne entretenue il y a $km km';
  }

  @override
  String healthChainDue(int km) {
    return 'Entretien de chaîne dans ~$km km';
  }

  @override
  String get healthAirNone => 'Aucun entretien du filtre à air enregistré';

  @override
  String healthAirGood(String km) {
    return 'Filtre à air changé il y a $km k km';
  }

  @override
  String get healthAirDue => 'Changement du filtre à air à prévoir';

  @override
  String get healthBrakesNone => 'Aucun entretien des freins enregistré';

  @override
  String healthBrakesGood(String km) {
    return 'Freins contrôlés il y a $km k km';
  }

  @override
  String get healthBrakesDue => 'Contrôle des freins recommandé';

  @override
  String get healthTyresNone => 'Aucun entretien des pneus enregistré';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Pneus remplacés il y a $months mois',
      one: 'Pneus remplacés il y a 1 mois',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'Contrôle des pneus recommandé';

  @override
  String get healthBatteryNone => 'Aucun entretien de la batterie enregistré';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Batterie remplacée il y a $months mois',
      one: 'Batterie remplacée il y a 1 mois',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'Contrôle de la batterie recommandé';

  @override
  String get healthInsuranceNotSet =>
      'Date d’expiration de l’assurance non définie';

  @override
  String get healthInsuranceExpired =>
      'Assurance EXPIRÉE — renouvelez-la immédiatement';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'L’assurance expire dans $days jours — renouvelez-la',
      one: 'L’assurance expire dans 1 jour — renouvelez-la',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'Assurance valide encore $days jours';
  }

  @override
  String get healthEconomyNeedMore =>
      'Enregistrez plus de pleins pour suivre la consommation';

  @override
  String healthEconomyAverage(String mileage) {
    return 'Moyenne : $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'Consommation stable à $mileage km/L';
  }

  @override
  String get healthEconomyDropping =>
      'Consommation en baisse — un entretien peut être nécessaire';

  @override
  String get healthEconomyDeclining =>
      'Consommation en légère baisse — à surveiller';
}
