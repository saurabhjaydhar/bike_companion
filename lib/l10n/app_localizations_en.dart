// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonOther => 'Other';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsSystemDefault => 'System default';

  @override
  String get settingsLight => 'Light';

  @override
  String get settingsDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsBuiltWithFlutter => 'Built with Flutter';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSignedIn => 'Signed in';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutTitle => 'Sign out?';

  @override
  String get settingsSignOutBody =>
      'Your local data stays on this device. Sign back in anytime.';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsClearAllData => 'Clear all data';

  @override
  String get settingsClearTitle => 'Clear all data?';

  @override
  String get settingsClearBody =>
      'This will permanently delete all bikes, fuel logs, service records, expenses, and documents. This cannot be undone.';

  @override
  String get settingsDataCleared => 'All data cleared';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Permanently removes your account (GDPR)';

  @override
  String get settingsDeleteAccountTitle => 'Delete account?';

  @override
  String get settingsDeleteAccountBody =>
      'This permanently deletes your Firebase account. Your local data stays on this device. This cannot be undone.';

  @override
  String get settingsDeleteAccountError =>
      'Could not delete account. Please sign in again and retry.';

  @override
  String get appTitle => 'Bike Companion';

  @override
  String get commonContinue => 'Continue';

  @override
  String authSignInFailed(String error) {
    return 'Sign-in failed: $error';
  }

  @override
  String get authOfflineTitle => 'Continue without account?';

  @override
  String get authOfflineBody =>
      'Your data will be saved on this device only. It won\'t be backed up or synced to other devices.\n\nYou can sign in anytime from Settings.';

  @override
  String get authOfflineError =>
      'Could not start offline session. Please try again.';

  @override
  String get authTagline =>
      'Track fuel, service & expenses\nfor your motorcycle';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithoutAccount => 'Continue without account';

  @override
  String get authTerms =>
      'By continuing you agree to our Terms & Privacy Policy.';

  @override
  String get onboardingWelcomeTitle => 'Your bike,\nalways healthy';

  @override
  String get onboardingWelcomeBody =>
      'Track fuel, service, expenses and documents — all in one place. Know exactly when your bike needs attention.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingAddMyBike => 'Add my bike';

  @override
  String get fieldBrand => 'Brand';

  @override
  String get fieldModel => 'Model';

  @override
  String get fieldModelHint => 'e.g. Classic 350, Activa';

  @override
  String get fieldNickname => 'Nickname';

  @override
  String get fieldNicknameHint => 'What do you call it?';

  @override
  String get fieldColour => 'Colour';

  @override
  String get fieldSelectDate => 'Select date';

  @override
  String get fieldCurrentOdometer => 'Current odometer (km)';

  @override
  String get fieldInsuranceExpiry => 'Insurance expiry';

  @override
  String get fieldPucExpiry => 'PUC expiry';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationEnterNumber => 'Enter a number';

  @override
  String get addBikeInvalidFormat =>
      'Invalid format. Use format like MH12DE1234 or DL01AA1234.';

  @override
  String get addBikeNotFound => 'Vehicle not found in registry.';

  @override
  String get addBikeApiLimit => 'API limit reached. Please try again later.';

  @override
  String get addBikeNoInternet =>
      'No internet connection. Please check your network.';

  @override
  String get addBikeFetchFailed => 'Could not fetch vehicle details.';

  @override
  String get addBikeTitle => 'Add Your Bike';

  @override
  String get addBikeSubtitle =>
      'Enter your registration number and we\'ll pull your vehicle details automatically.';

  @override
  String get addBikeExamples => 'e.g. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addBikeContinue => 'Continue →';

  @override
  String get addBikeFetching => 'Fetching vehicle details…';

  @override
  String get vehicleBrandRequired => 'Brand is required';

  @override
  String get vehicleModelRequired => 'Model is required';

  @override
  String get vehicleSaveFailed => 'Failed to save bike. Please try again.';

  @override
  String get vehicleDetailsTitle => 'Vehicle Details';

  @override
  String get vehicleSectionRegistration => 'REGISTRATION';

  @override
  String get vehicleRcNumber => 'RC Number';

  @override
  String get vehicleSectionInfo => 'VEHICLE INFO';

  @override
  String get vehicleManufacturer => 'Manufacturer';

  @override
  String get vehicleVariant => 'Variant';

  @override
  String get vehicleFuelType => 'Fuel Type';

  @override
  String get vehicleClass => 'Vehicle Class';

  @override
  String get vehicleSectionRegistrationDetails => 'REGISTRATION DETAILS';

  @override
  String get vehicleRegistrationDate => 'Registration Date';

  @override
  String get vehicleSectionIdentifiers => 'IDENTIFIERS';

  @override
  String get vehicleEngineNumber => 'Engine Number';

  @override
  String get vehicleChassisNumber => 'Chassis Number';

  @override
  String get vehicleSaveBike => 'Save Bike';

  @override
  String get vehicleFetchSuccess =>
      'Vehicle details fetched. Review and confirm.';

  @override
  String get vehicleFetchFailure =>
      'Couldn\'t fetch vehicle details. Please enter them manually below.';

  @override
  String commonError(String error) {
    return 'Error: $error';
  }

  @override
  String get commonThisMonth => 'this month';

  @override
  String get garageTitle => 'My Garage';

  @override
  String get garageEmptyTitle => 'No bikes yet';

  @override
  String get garageEmptyBody =>
      'Add your first bike to start tracking fuel, service and expenses.';

  @override
  String get garageYourBikes => 'Your bikes';

  @override
  String get garageAddAnother => 'Add another bike';

  @override
  String get garageStatBikes => 'bikes';

  @override
  String get garageStatAlerts => 'alerts';

  @override
  String garageDeleteBike(String name) {
    return 'Delete $name';
  }

  @override
  String garageDeleteBikeTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get garageDeleteBikeBody =>
      'All fuel logs, service records, and expenses will be deleted.';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'Not set';

  @override
  String get fieldOdometer => 'Odometer';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardLogFuel => 'Log fuel stop';

  @override
  String get dashboardRecentActivity => 'Recent activity';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get dashboardThisMonth => 'This month';

  @override
  String get dashboardLastFuel => 'Last fuel';

  @override
  String get dashboardNotLogged => 'Not logged';

  @override
  String dashboardAvgMileage(String mileage) {
    return '$mileage km/L avg';
  }

  @override
  String get dashboardNextService => 'Next service';

  @override
  String get dashboardUpToDate => 'Up to date';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'Fuel stop';

  @override
  String fuelOdometerTooLow(int km) {
    return 'Odometer must be greater than last entry ($km km)';
  }

  @override
  String get fuelLogged => 'Fuel stop logged!';

  @override
  String get fuelCurrentOdometer => 'Current odometer';

  @override
  String fuelLastEntry(int km) {
    return 'Last entry: $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return '$km km since last fill · ~$litres L estimated';
  }

  @override
  String fuelKmSinceLast(int km) {
    return '$km km since last fill';
  }

  @override
  String get fuelAddMoreDetails => 'Add more details';

  @override
  String get fuelLitresFilled => 'Litres filled';

  @override
  String get fuelAmountPaid => 'Amount paid';

  @override
  String get fuelStationOptional => 'Fuel station (optional)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelReceiptSoon => 'Receipt scan coming soon!';

  @override
  String get fuelScanReceipt => 'Scan receipt';

  @override
  String get fuelSave => 'Save fuel stop';

  @override
  String get fuelHistoryTitle => 'Fuel history';

  @override
  String get fuelHistoryEmptyTitle => 'No fuel logs yet';

  @override
  String get fuelHistoryEmptyBody =>
      'Log your first fuel stop from the dashboard.';

  @override
  String get fuelAvgMileageAllTime => 'Average mileage (all time)';

  @override
  String get fieldNotesOptional => 'Notes (optional)';

  @override
  String get serviceStatusGood => 'Good';

  @override
  String get serviceDueSoon => 'Due soon';

  @override
  String get serviceStatusOverdue => 'Overdue';

  @override
  String get serviceHistory => 'History';

  @override
  String serviceLast(String date) {
    return 'Last: $date';
  }

  @override
  String get serviceEmptyTitle => 'No services logged';

  @override
  String get serviceEmptyBody =>
      'Tap any item in \"Due soon\" to log a service.';

  @override
  String get serviceLogTitle => 'Log service';

  @override
  String get serviceType => 'Service type';

  @override
  String get serviceOdometerKm => 'Odometer (km)';

  @override
  String get serviceCost => 'Cost (₹)';

  @override
  String get serviceNotesHint => 'Shop name, parts replaced...';

  @override
  String get serviceSave => 'Save service';

  @override
  String get serviceOilChange => 'Oil Change';

  @override
  String get serviceOilFilter => 'Oil Filter';

  @override
  String get serviceAirFilter => 'Air Filter';

  @override
  String get serviceChainClean => 'Chain Clean';

  @override
  String get serviceChainLube => 'Chain Lube';

  @override
  String get serviceBrakePads => 'Brake Pads';

  @override
  String get serviceTyres => 'Tyres';

  @override
  String get serviceBattery => 'Battery';

  @override
  String get serviceCoolant => 'Coolant';

  @override
  String get expenseFuel => 'Fuel';

  @override
  String get expenseService => 'Service';

  @override
  String get expenseParts => 'Parts';

  @override
  String get expenseInsurance => 'Insurance';

  @override
  String get expenseParking => 'Parking';

  @override
  String get expenseAccessories => 'Accessories';

  @override
  String get expenseFine => 'Fine';

  @override
  String get docRc => 'RC Book';

  @override
  String get docInsurance => 'Insurance';

  @override
  String get docDrivingLicence => 'Driving Licence';

  @override
  String get docPuc => 'PUC Certificate';

  @override
  String get docInvoice => 'Purchase Invoice';

  @override
  String get docWarranty => 'Warranty Card';

  @override
  String get gradeExcellent => 'Excellent condition';

  @override
  String get gradeGood => 'Good condition';

  @override
  String get gradeFair => 'Fair condition';

  @override
  String get gradePoor => 'Needs attention';

  @override
  String get gradeCritical => 'Critical — service now';

  @override
  String get expensesTitle => 'Expenses';

  @override
  String get expensesExportCsv => 'Export CSV';

  @override
  String get expensesByCategory => 'By category';

  @override
  String get expensesTransactions => 'Transactions';

  @override
  String get expensesEmptyTitle => 'No expenses';

  @override
  String get expensesEmptyBody => 'Tap + to add your first expense this month.';

  @override
  String get expensesCsvHeader => 'Date,Category,Amount (₹),Note';

  @override
  String expensesCsvSubject(String month) {
    return 'Expenses — $month';
  }

  @override
  String get expensesTotalSpent => 'Total spent';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent% vs last month';
  }

  @override
  String get expensesAddTitle => 'Add expense';

  @override
  String get expensesCategory => 'Category';

  @override
  String get expensesAmount => 'Amount (₹)';

  @override
  String get expensesNoteOptional => 'Note (optional)';

  @override
  String get expensesNoteHint => 'Merchant, description...';

  @override
  String get expensesSave => 'Save expense';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsEmptyTitle => 'No documents';

  @override
  String get documentsEmptyBody =>
      'Store your RC, insurance, PUC and more in one place.';

  @override
  String get documentsExpiringSoon => 'Expiring soon';

  @override
  String get documentsValid => 'Valid';

  @override
  String get documentsExpired => 'Expired';

  @override
  String get documentsNoExpiry => 'No expiry';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Expires in $count days',
      one: 'Expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'Delete document';

  @override
  String get documentsExpiry => 'Expiry';

  @override
  String get documentsAddTitle => 'Add document';

  @override
  String get documentsType => 'Document type';

  @override
  String get documentsTitleField => 'Title';

  @override
  String get documentsTitleHint => 'e.g. RC Book, Policy #...';

  @override
  String get documentsExpiryOptional => 'Expiry date (optional)';

  @override
  String get documentsPhotoSelected => 'Photo selected';

  @override
  String get documentsAttachPhoto => 'Attach photo';

  @override
  String get documentsSave => 'Save document';

  @override
  String get navHome => 'Home';

  @override
  String get navRides => 'Rides';

  @override
  String get navDocs => 'Docs';

  @override
  String get ridesComingSoon => 'GPS ride tracking\ncoming soon';

  @override
  String get noBikeSelected => 'Select a bike from the Home tab first.';

  @override
  String get offlineBanner => 'No internet — working offline';

  @override
  String notifDocBody(String title, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$title expires in $days days',
      one: '$title expires tomorrow',
    );
    return '$_temp0';
  }

  @override
  String notifDocTitle(int days) {
    return 'Document expiring in $days days';
  }

  @override
  String get notifDocTomorrowTitle => 'Document expires tomorrow!';

  @override
  String notifServiceOverdueTitle(String bike) {
    return 'Service overdue — $bike';
  }

  @override
  String notifServiceOverdueBody(String service) {
    return '$service needs attention';
  }

  @override
  String get healthOilNone => 'No oil change recorded — log your first service';

  @override
  String healthOilGood(int km) {
    return 'Oil changed $km km ago — all good';
  }

  @override
  String get healthOilOverdue => 'Oil change overdue!';

  @override
  String healthOilDue(int km) {
    return 'Oil change due in ~$km km';
  }

  @override
  String get healthChainNone => 'No chain service recorded';

  @override
  String healthChainGood(int km) {
    return 'Chain serviced $km km ago';
  }

  @override
  String healthChainDue(int km) {
    return 'Chain service due in ~$km km';
  }

  @override
  String get healthAirNone => 'No air filter service recorded';

  @override
  String healthAirGood(String km) {
    return 'Air filter changed ${km}k km ago';
  }

  @override
  String get healthAirDue => 'Air filter change due soon';

  @override
  String get healthBrakesNone => 'No brake service recorded';

  @override
  String healthBrakesGood(String km) {
    return 'Brakes checked ${km}k km ago';
  }

  @override
  String get healthBrakesDue => 'Brake inspection recommended';

  @override
  String get healthTyresNone => 'No tyre service recorded';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Tyres replaced $months months ago',
      one: 'Tyres replaced 1 month ago',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'Tyre inspection recommended';

  @override
  String get healthBatteryNone => 'No battery service recorded';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Battery replaced $months months ago',
      one: 'Battery replaced 1 month ago',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'Battery check recommended';

  @override
  String get healthInsuranceNotSet => 'Insurance expiry date not set';

  @override
  String get healthInsuranceExpired => 'Insurance EXPIRED — renew immediately';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Insurance expires in $days days — renew now',
      one: 'Insurance expires in 1 day — renew now',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'Insurance valid for $days more days';
  }

  @override
  String get healthEconomyNeedMore => 'Log more fill-ups to track fuel economy';

  @override
  String healthEconomyAverage(String mileage) {
    return 'Average: $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'Fuel economy stable at $mileage km/L';
  }

  @override
  String get healthEconomyDropping =>
      'Fuel economy dropping — service may be needed';

  @override
  String get healthEconomyDeclining =>
      'Fuel economy slightly declining — monitor it';

  @override
  String get addBikeHubSubtitle =>
      'Scan your RC card, or fill in the details yourself.';

  @override
  String get addBikeScanTitle => 'Scan RC card';

  @override
  String get addBikeScanBody => 'Snap your RC and we\'ll fill in the details.';

  @override
  String get addBikeManualTitle => 'Enter manually';

  @override
  String get addBikeManualBody => 'Type in your bike\'s details yourself.';

  @override
  String get addBikeLookupTitle => 'Look up by number';

  @override
  String get scanTakePhoto => 'Take photo';

  @override
  String get scanChooseGallery => 'Choose from gallery';

  @override
  String get scanUseGemini => 'Read with Gemini AI';

  @override
  String get scanUseGeminiBody =>
      'More accurate. Your RC photo is sent to Google to read the vehicle details. When off, the photo is read on your phone only.';

  @override
  String get scanReading => 'Reading your RC…';

  @override
  String get vehicleScanSuccess =>
      'Details read from your RC. Check everything before saving.';

  @override
  String get vehicleScanFailure =>
      'Couldn\'t read your RC clearly. Please fill in the details below.';

  @override
  String get vehicleSectionYourBike => 'YOUR BIKE';

  @override
  String get vahanSmsButton => 'Check on VAHAN by SMS';

  @override
  String get vahanSmsHint =>
      'Sends your number to the official VAHAN SMS service. The reply arrives in your SMS inbox — copy the details into this form.';

  @override
  String get vahanSmsError => 'Couldn\'t open your SMS app.';
}
