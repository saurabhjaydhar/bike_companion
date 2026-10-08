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
      'Your garage is backed up to your Google account. Signing out removes it from this phone — sign back in to get it back.';

  @override
  String get settingsSignOutGuestBody =>
      'You\'re using Garajo as a guest, so your garage is saved only on this phone. Signing out erases it for good. Back it up to Google first to keep it.';

  @override
  String get settingsSignOutErase => 'Erase and sign out';

  @override
  String get settingsSignOutUnsyncedTitle => 'Changes not backed up';

  @override
  String get settingsSignOutUnsyncedBody =>
      'Some recent changes haven\'t reached your backup yet. Connect to the internet and try again, or sign out now and lose them.';

  @override
  String get settingsSignOutAnyway => 'Sign out anyway';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsClearAllData => 'Clear all data';

  @override
  String get settingsClearTitle => 'Clear all data?';

  @override
  String get settingsClearBody =>
      'This permanently deletes all vehicles, fuel logs, service records, expenses and documents — on this phone and in your backup. This cannot be undone.';

  @override
  String get settingsDataCleared => 'All data cleared';

  @override
  String get settingsClearError =>
      'Couldn\'t clear your data. Check your connection and try again.';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle =>
      'Permanently removes your account (GDPR)';

  @override
  String get settingsDeleteAccountTitle => 'Delete account?';

  @override
  String get settingsDeleteAccountBody =>
      'This permanently deletes your account and everything in it — vehicles, records and document photos, on this phone and in the cloud. This cannot be undone.';

  @override
  String get settingsDeleteAccountError =>
      'Could not delete account. Please sign in again and retry.';

  @override
  String get appTitle => 'Garajo';

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
      'Track fuel, service & expenses\nfor your bike, scooter or car';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithoutAccount => 'Continue without account';

  @override
  String get authTerms =>
      'By continuing you agree to our Terms & Privacy Policy.';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Garajo';

  @override
  String get onboardingAddMyVehicle => 'Add my vehicle';

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
  String get addVehicleInvalidFormat =>
      'Invalid format. Use format like MH12DE1234 or DL01AA1234.';

  @override
  String get addVehicleNotFound => 'Vehicle not found in registry.';

  @override
  String get addVehicleApiLimit => 'API limit reached. Please try again later.';

  @override
  String get addVehicleNoInternet =>
      'No internet connection. Please check your network.';

  @override
  String get addVehicleFetchFailed => 'Could not fetch vehicle details.';

  @override
  String get addVehicleTitle => 'Add Your Vehicle';

  @override
  String get addVehicleSubtitle =>
      'Enter your registration number and we\'ll pull your vehicle details automatically.';

  @override
  String get addVehicleExamples => 'e.g. UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'Continue →';

  @override
  String get addVehicleFetching => 'Fetching vehicle details…';

  @override
  String get vehicleBrandRequired => 'Brand is required';

  @override
  String get vehicleModelRequired => 'Model is required';

  @override
  String get vehicleSaveFailed => 'Failed to save vehicle. Please try again.';

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
  String get vehicleSaveVehicle => 'Save Vehicle';

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
  String get garageEmptyTitle => 'No vehicles yet';

  @override
  String get garageEmptyBody =>
      'Add your first bike, scooter or car to start tracking fuel, service and expenses.';

  @override
  String get garageYourVehicles => 'Your vehicles';

  @override
  String get garageAddAnother => 'Add another vehicle';

  @override
  String get garageStatVehicles => 'vehicles';

  @override
  String get garageStatAlerts => 'alerts';

  @override
  String garageDeleteVehicle(String name) {
    return 'Delete $name';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get garageDeleteVehicleBody =>
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
  String get navDocs => 'Docs';

  @override
  String get noVehicleSelected => 'Select a vehicle from the Home tab first.';

  @override
  String get offlineBanner => 'No internet — working offline';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'Service overdue — $vehicle';
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
  String get addVehicleHubSubtitle =>
      'Scan your RC card, or fill in the details yourself.';

  @override
  String get addVehicleScanTitle => 'Scan RC card';

  @override
  String get addVehicleScanBody =>
      'Snap your RC and we\'ll fill in the details.';

  @override
  String get addVehicleManualTitle => 'Enter manually';

  @override
  String get addVehicleManualBody =>
      'Type in your vehicle\'s details yourself.';

  @override
  String get addVehicleLookupTitle => 'Look up by number';

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
  String get scanTitle => 'Scan your RC';

  @override
  String get scanSubtitle =>
      'Add photos of both sides of your RC card — each side has different details. For an RC book or digital RC, one photo is enough.';

  @override
  String get scanFront => 'Front side';

  @override
  String get scanFrontHint => 'Registration number, chassis and engine number';

  @override
  String get scanBack => 'Back side';

  @override
  String get scanBackHint => 'Maker, model and vehicle class';

  @override
  String get scanAddPhoto => 'Tap to add a photo';

  @override
  String get scanRemovePhoto => 'Remove photo';

  @override
  String get scanReadDetails => 'Read details';

  @override
  String get scanPickerError =>
      'Couldn\'t open the camera or gallery. Check the app\'s permissions in Settings.';

  @override
  String get vehicleScanSuccess =>
      'Details read from your RC. Check everything before saving.';

  @override
  String get vehicleScanFailure =>
      'Couldn\'t read your RC clearly. Please fill in the details below.';

  @override
  String get vehicleSectionYourVehicle => 'YOUR VEHICLE';

  @override
  String get vahanSmsButton => 'Check on VAHAN by SMS';

  @override
  String get vahanSmsHint =>
      'Sends your number to the official VAHAN SMS service. The reply arrives in your SMS inbox — copy the details into this form.';

  @override
  String get vahanSmsError => 'Couldn\'t open your SMS app.';

  @override
  String get vehicleRegValidity => 'Registration valid until';

  @override
  String get dueRegistration => 'Registration';

  @override
  String notifExpiryTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item expires in $days days',
      one: '$item expires tomorrow',
    );
    return '$_temp0';
  }

  @override
  String notifServiceDueTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item due in $days days',
      one: '$item due tomorrow',
    );
    return '$_temp0';
  }

  @override
  String notifDueBody(String vehicle, String date) {
    return '$vehicle · $date. Tap to update.';
  }

  @override
  String get comingUpTitle => 'Coming up';

  @override
  String get comingUpEmpty => 'You\'re all set — nothing due soon.';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'tomorrow',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String dueOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String get dueAddDate => 'Add date';

  @override
  String get dueServiceSoon => 'Due soon';

  @override
  String get dueServiceOverdue => 'Overdue';

  @override
  String dueValidUntil(String item) {
    return '$item valid until';
  }

  @override
  String get dueUpdated => 'Date saved — reminders updated';

  @override
  String get remindersTurnOn => 'Turn on';

  @override
  String get remindersOffBody =>
      'Reminders are off. Turn them on to hear before insurance, PUC and services are due.';

  @override
  String get remindersMutedNote => 'Reminders are off for this vehicle.';

  @override
  String get remindersPermissionTitle => 'Get reminders?';

  @override
  String get remindersPermissionBody =>
      'We\'ll remind you 30, 7 and 1 day before insurance, PUC and documents expire — at 9 AM, never at night.';

  @override
  String get remindersNotNow => 'Not now';

  @override
  String get remindersEnableInSettings =>
      'Notifications are blocked. Turn them on for this app in your phone\'s Settings.';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String settingsRemindersNext(String item, String date) {
    return 'Next: $item · $date';
  }

  @override
  String get settingsRemindersNone => 'Nothing due soon';

  @override
  String get expensesModeMonth => 'Month';

  @override
  String get expensesModeYear => 'Year';

  @override
  String expensesVsLastYear(String percent) {
    return '$percent% vs last year';
  }

  @override
  String get expensesAvgMonthly => 'Avg / month';

  @override
  String get expensesCostPerKm => 'Cost / km';

  @override
  String get expensesFuelPerKm => 'Fuel / km';

  @override
  String get expensesNeedOdometer =>
      'Log fuel or services with odometer readings to see cost per km.';

  @override
  String get expensesFromFuelLog => 'Fuel log';

  @override
  String get expensesFromService => 'Service';

  @override
  String get expensesDeleted => 'Expense deleted';

  @override
  String get commonUndo => 'Undo';

  @override
  String get budgetTitle => 'Budget';

  @override
  String budgetOf(String spent, String budget) {
    return '$spent of $budget';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount left';
  }

  @override
  String budgetLeftOf(String left, String budget) {
    return '$left left of $budget';
  }

  @override
  String budgetOver(String amount) {
    return '$amount over budget';
  }

  @override
  String get budgetSet => 'Set budget';

  @override
  String get budgetSetPrompt => 'Set a budget to keep spending in check.';

  @override
  String get budgetSheetTitle => 'Spending budget';

  @override
  String get budgetMonthly => 'Monthly budget';

  @override
  String get budgetYearly => 'Yearly budget';

  @override
  String budgetSuggested(String amount) {
    return 'Suggested from recent months: $amount';
  }

  @override
  String get budgetSave => 'Save budget';

  @override
  String get budgetRemove => 'Remove budget';

  @override
  String budgetAlertTitle(String vehicle) {
    return 'Budget alert — $vehicle';
  }

  @override
  String budgetAlertMonth(int percent) {
    return 'You\'ve used $percent% of this month\'s budget.';
  }

  @override
  String budgetAlertYear(int percent) {
    return 'You\'ve used $percent% of this year\'s budget.';
  }

  @override
  String get garageSpending => 'Spending';

  @override
  String get garageThisYear => 'This year';

  @override
  String get vehicleTypeTitle => 'VEHICLE TYPE';

  @override
  String get vehicleTypeDetected =>
      'Detected from your RC — change it if it\'s wrong.';

  @override
  String get vehicleTypeBike => 'Bike';

  @override
  String get vehicleTypeScooter => 'Scooter';

  @override
  String get vehicleTypeCar => 'Car';

  @override
  String get serviceWheelAlignment => 'Wheel Alignment';

  @override
  String get serviceAcService => 'AC Service';

  @override
  String get serviceWipers => 'Wipers';

  @override
  String get onboardingSlideTrackTitle => 'Track every rupee';

  @override
  String get onboardingSlideTrackBody =>
      'Fuel, service and expenses in one place — with budgets and cost per km for each vehicle.';

  @override
  String get onboardingSlideRemindTitle => 'Never miss a date';

  @override
  String get onboardingSlideRemindBody =>
      'Reminders before insurance, PUC and services are due — at 9 AM, never at night.';

  @override
  String get onboardingSlideScanTitle => 'Scan, don\'t type';

  @override
  String get onboardingSlideScanBody =>
      'Photograph your RC and we\'ll fill in your vehicle\'s details.';

  @override
  String fuelLitresFromPrice(String litres, String price) {
    return '≈ $litres L at ₹$price/L (your last fill-up)';
  }

  @override
  String get logButton => 'Log';

  @override
  String get logSheetTitle => 'What are you logging?';

  @override
  String get logFuelSub => 'Litres, cost and mileage';

  @override
  String get logExpenseSub => 'Parts, insurance, parking, tolls';

  @override
  String get logServiceSub => 'Oil change, chain, tyres';

  @override
  String get logOdometerTitle => 'Update odometer';

  @override
  String get logOdometerSub => 'Keep your km up to date';

  @override
  String get logDocumentSub => 'RC, insurance, PUC';

  @override
  String get odometerSave => 'Save reading';

  @override
  String get odometerUpdated => 'Odometer updated';

  @override
  String get odometerInvalid => 'Enter a reading in km';

  @override
  String fuelOdometerEstimated(int km) {
    return 'Guessed from your usual $km km between fills. Nudge it to match.';
  }

  @override
  String fuelTripMileage(int km, String litres, String mileage) {
    return '$km km · $litres L · $mileage km/L';
  }

  @override
  String get vehicleEditTitle => 'Edit vehicle';

  @override
  String get vehicleUpdated => 'Vehicle updated';

  @override
  String get vehicleMoreDetails => 'More details';

  @override
  String get vehicleSectionDueDates => 'RENEWAL DATES';

  @override
  String get healthFuelEconomy => 'Fuel economy';

  @override
  String get healthBreakdownTitle => 'Health score';

  @override
  String get healthBreakdownBody =>
      'What makes up the score. Fix the top items to raise it.';

  @override
  String get healthFixLog => 'Log it';

  @override
  String get healthFixUpdate => 'Update date';

  @override
  String get onboardingHaveAccount => 'I already have an account';

  @override
  String get backupTitle => 'Back up your garage';

  @override
  String get backupBody =>
      'Saved on this phone only. Sign in with Google to keep it safe and sync it.';

  @override
  String get backupLater => 'Later';

  @override
  String get backupAction => 'Back up';

  @override
  String get backupDone => 'Garage backed up to your Google account';

  @override
  String get settingsGuest => 'Guest';

  @override
  String get tipNext => 'Next';

  @override
  String get tipSkip => 'Skip';

  @override
  String get tipGotIt => 'Got it';

  @override
  String get tourScoreTitle => 'Health score';

  @override
  String get tourScoreBody =>
      'How your vehicle is doing, from services, insurance and mileage. Tap it to see what to fix.';

  @override
  String get tourLogTitle => 'Log anything';

  @override
  String get tourLogBody =>
      'Fuel, an expense, a service, an odometer reading or a document – all from this one button.';

  @override
  String get tourSwitchTitle => 'Your vehicles';

  @override
  String get tourSwitchBody =>
      'Tap the name to switch vehicle, add another or edit its details.';

  @override
  String get tipExpenses =>
      'Swipe left or right to change the month. Set a budget and we\'ll warn you before you overspend.';

  @override
  String get tipService =>
      'Tap any item to log it. We work out when it\'s due next and remind you.';

  @override
  String get tipDocuments =>
      'Add your RC, insurance and PUC with expiry dates. We\'ll remind you before they run out.';

  @override
  String get tipFuelLog =>
      'Just the odometer and what you paid. We work out litres and mileage, and fill in the reading for you next time.';

  @override
  String get tipGarage =>
      'Tap a vehicle to open it. Use ⋮ to edit or delete it.';

  @override
  String get settingsShowTips => 'Show tips again';

  @override
  String get settingsTipsReset => 'Tips will show again on each screen';
}
