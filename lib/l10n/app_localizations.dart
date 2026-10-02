import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get commonOther;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsSystemDefault;

  /// No description provided for @settingsLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsLight;

  /// No description provided for @settingsDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsBuiltWithFlutter.
  ///
  /// In en, this message translates to:
  /// **'Built with Flutter'**
  String get settingsBuiltWithFlutter;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get settingsSignedIn;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutBody.
  ///
  /// In en, this message translates to:
  /// **'Your local data stays on this device. Sign back in anytime.'**
  String get settingsSignOutBody;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsClearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearAllData;

  /// No description provided for @settingsClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get settingsClearTitle;

  /// No description provided for @settingsClearBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all bikes, fuel logs, service records, expenses, and documents. This cannot be undone.'**
  String get settingsClearBody;

  /// No description provided for @settingsDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get settingsDataCleared;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently removes your account (GDPR)'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your Firebase account. Your local data stays on this device. This cannot be undone.'**
  String get settingsDeleteAccountBody;

  /// No description provided for @settingsDeleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete account. Please sign in again and retry.'**
  String get settingsDeleteAccountError;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bike Companion'**
  String get appTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @authSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed: {error}'**
  String authSignInFailed(String error);

  /// No description provided for @authOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue without account?'**
  String get authOfflineTitle;

  /// No description provided for @authOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Your data will be saved on this device only. It won\'t be backed up or synced to other devices.\n\nYou can sign in anytime from Settings.'**
  String get authOfflineBody;

  /// No description provided for @authOfflineError.
  ///
  /// In en, this message translates to:
  /// **'Could not start offline session. Please try again.'**
  String get authOfflineError;

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'Track fuel, service & expenses\nfor your motorcycle'**
  String get authTagline;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get authContinueWithoutAccount;

  /// No description provided for @authTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms & Privacy Policy.'**
  String get authTerms;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bike,\nalways healthy'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Track fuel, service, expenses and documents — all in one place. Know exactly when your bike needs attention.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingAddMyBike.
  ///
  /// In en, this message translates to:
  /// **'Add my bike'**
  String get onboardingAddMyBike;

  /// No description provided for @fieldBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get fieldBrand;

  /// No description provided for @fieldModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get fieldModel;

  /// No description provided for @fieldModelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Classic 350, Activa'**
  String get fieldModelHint;

  /// No description provided for @fieldNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get fieldNickname;

  /// No description provided for @fieldNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'What do you call it?'**
  String get fieldNicknameHint;

  /// No description provided for @fieldColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get fieldColour;

  /// No description provided for @fieldSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get fieldSelectDate;

  /// No description provided for @fieldCurrentOdometer.
  ///
  /// In en, this message translates to:
  /// **'Current odometer (km)'**
  String get fieldCurrentOdometer;

  /// No description provided for @fieldInsuranceExpiry.
  ///
  /// In en, this message translates to:
  /// **'Insurance expiry'**
  String get fieldInsuranceExpiry;

  /// No description provided for @fieldPucExpiry.
  ///
  /// In en, this message translates to:
  /// **'PUC expiry'**
  String get fieldPucExpiry;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get validationEnterNumber;

  /// No description provided for @addBikeInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format. Use format like MH12DE1234 or DL01AA1234.'**
  String get addBikeInvalidFormat;

  /// No description provided for @addBikeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not found in registry.'**
  String get addBikeNotFound;

  /// No description provided for @addBikeApiLimit.
  ///
  /// In en, this message translates to:
  /// **'API limit reached. Please try again later.'**
  String get addBikeApiLimit;

  /// No description provided for @addBikeNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get addBikeNoInternet;

  /// No description provided for @addBikeFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch vehicle details.'**
  String get addBikeFetchFailed;

  /// No description provided for @addBikeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Your Bike'**
  String get addBikeTitle;

  /// No description provided for @addBikeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registration number and we\'ll pull your vehicle details automatically.'**
  String get addBikeSubtitle;

  /// No description provided for @addBikeExamples.
  ///
  /// In en, this message translates to:
  /// **'e.g. UK07AB1234 · DL01AA1234 · MH12DE1234'**
  String get addBikeExamples;

  /// No description provided for @addBikeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue →'**
  String get addBikeContinue;

  /// No description provided for @addBikeFetching.
  ///
  /// In en, this message translates to:
  /// **'Fetching vehicle details…'**
  String get addBikeFetching;

  /// No description provided for @vehicleBrandRequired.
  ///
  /// In en, this message translates to:
  /// **'Brand is required'**
  String get vehicleBrandRequired;

  /// No description provided for @vehicleModelRequired.
  ///
  /// In en, this message translates to:
  /// **'Model is required'**
  String get vehicleModelRequired;

  /// No description provided for @vehicleSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save bike. Please try again.'**
  String get vehicleSaveFailed;

  /// No description provided for @vehicleDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetailsTitle;

  /// No description provided for @vehicleSectionRegistration.
  ///
  /// In en, this message translates to:
  /// **'REGISTRATION'**
  String get vehicleSectionRegistration;

  /// No description provided for @vehicleRcNumber.
  ///
  /// In en, this message translates to:
  /// **'RC Number'**
  String get vehicleRcNumber;

  /// No description provided for @vehicleSectionInfo.
  ///
  /// In en, this message translates to:
  /// **'VEHICLE INFO'**
  String get vehicleSectionInfo;

  /// No description provided for @vehicleManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get vehicleManufacturer;

  /// No description provided for @vehicleVariant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get vehicleVariant;

  /// No description provided for @vehicleFuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get vehicleFuelType;

  /// No description provided for @vehicleClass.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Class'**
  String get vehicleClass;

  /// No description provided for @vehicleSectionRegistrationDetails.
  ///
  /// In en, this message translates to:
  /// **'REGISTRATION DETAILS'**
  String get vehicleSectionRegistrationDetails;

  /// No description provided for @vehicleRegistrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get vehicleRegistrationDate;

  /// No description provided for @vehicleSectionIdentifiers.
  ///
  /// In en, this message translates to:
  /// **'IDENTIFIERS'**
  String get vehicleSectionIdentifiers;

  /// No description provided for @vehicleEngineNumber.
  ///
  /// In en, this message translates to:
  /// **'Engine Number'**
  String get vehicleEngineNumber;

  /// No description provided for @vehicleChassisNumber.
  ///
  /// In en, this message translates to:
  /// **'Chassis Number'**
  String get vehicleChassisNumber;

  /// No description provided for @vehicleSaveBike.
  ///
  /// In en, this message translates to:
  /// **'Save Bike'**
  String get vehicleSaveBike;

  /// No description provided for @vehicleFetchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details fetched. Review and confirm.'**
  String get vehicleFetchSuccess;

  /// No description provided for @vehicleFetchFailure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t fetch vehicle details. Please enter them manually below.'**
  String get vehicleFetchFailure;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commonError(String error);

  /// No description provided for @commonThisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get commonThisMonth;

  /// No description provided for @garageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Garage'**
  String get garageTitle;

  /// No description provided for @garageEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No bikes yet'**
  String get garageEmptyTitle;

  /// No description provided for @garageEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first bike to start tracking fuel, service and expenses.'**
  String get garageEmptyBody;

  /// No description provided for @garageYourBikes.
  ///
  /// In en, this message translates to:
  /// **'Your bikes'**
  String get garageYourBikes;

  /// No description provided for @garageAddAnother.
  ///
  /// In en, this message translates to:
  /// **'Add another bike'**
  String get garageAddAnother;

  /// No description provided for @garageStatBikes.
  ///
  /// In en, this message translates to:
  /// **'bikes'**
  String get garageStatBikes;

  /// No description provided for @garageStatAlerts.
  ///
  /// In en, this message translates to:
  /// **'alerts'**
  String get garageStatAlerts;

  /// No description provided for @garageDeleteBike.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String garageDeleteBike(String name);

  /// No description provided for @garageDeleteBikeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String garageDeleteBikeTitle(String name);

  /// No description provided for @garageDeleteBikeBody.
  ///
  /// In en, this message translates to:
  /// **'All fuel logs, service records, and expenses will be deleted.'**
  String get garageDeleteBikeBody;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String commonDaysAgo(int count);

  /// No description provided for @commonNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get commonNotSet;

  /// No description provided for @fieldOdometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get fieldOdometer;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardLogFuel.
  ///
  /// In en, this message translates to:
  /// **'Log fuel stop'**
  String get dashboardLogFuel;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dashboardThisMonth;

  /// No description provided for @dashboardLastFuel.
  ///
  /// In en, this message translates to:
  /// **'Last fuel'**
  String get dashboardLastFuel;

  /// No description provided for @dashboardNotLogged.
  ///
  /// In en, this message translates to:
  /// **'Not logged'**
  String get dashboardNotLogged;

  /// No description provided for @dashboardAvgMileage.
  ///
  /// In en, this message translates to:
  /// **'{mileage} km/L avg'**
  String dashboardAvgMileage(String mileage);

  /// No description provided for @dashboardNextService.
  ///
  /// In en, this message translates to:
  /// **'Next service'**
  String get dashboardNextService;

  /// No description provided for @dashboardUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get dashboardUpToDate;

  /// No description provided for @dashboardDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day left} other{{count} days left}}'**
  String dashboardDaysLeft(int count);

  /// No description provided for @dashboardFuelStop.
  ///
  /// In en, this message translates to:
  /// **'Fuel stop'**
  String get dashboardFuelStop;

  /// No description provided for @fuelOdometerTooLow.
  ///
  /// In en, this message translates to:
  /// **'Odometer must be greater than last entry ({km} km)'**
  String fuelOdometerTooLow(int km);

  /// No description provided for @fuelLogged.
  ///
  /// In en, this message translates to:
  /// **'Fuel stop logged!'**
  String get fuelLogged;

  /// No description provided for @fuelCurrentOdometer.
  ///
  /// In en, this message translates to:
  /// **'Current odometer'**
  String get fuelCurrentOdometer;

  /// No description provided for @fuelLastEntry.
  ///
  /// In en, this message translates to:
  /// **'Last entry: {km} km'**
  String fuelLastEntry(int km);

  /// No description provided for @fuelKmSinceLastEstimate.
  ///
  /// In en, this message translates to:
  /// **'{km} km since last fill · ~{litres} L estimated'**
  String fuelKmSinceLastEstimate(int km, String litres);

  /// No description provided for @fuelKmSinceLast.
  ///
  /// In en, this message translates to:
  /// **'{km} km since last fill'**
  String fuelKmSinceLast(int km);

  /// No description provided for @fuelAddMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Add more details'**
  String get fuelAddMoreDetails;

  /// No description provided for @fuelLitresFilled.
  ///
  /// In en, this message translates to:
  /// **'Litres filled'**
  String get fuelLitresFilled;

  /// No description provided for @fuelAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get fuelAmountPaid;

  /// No description provided for @fuelStationOptional.
  ///
  /// In en, this message translates to:
  /// **'Fuel station (optional)'**
  String get fuelStationOptional;

  /// No description provided for @fuelStationHint.
  ///
  /// In en, this message translates to:
  /// **'HP, Indian Oil, Bharat...'**
  String get fuelStationHint;

  /// No description provided for @fuelReceiptSoon.
  ///
  /// In en, this message translates to:
  /// **'Receipt scan coming soon!'**
  String get fuelReceiptSoon;

  /// No description provided for @fuelScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get fuelScanReceipt;

  /// No description provided for @fuelSave.
  ///
  /// In en, this message translates to:
  /// **'Save fuel stop'**
  String get fuelSave;

  /// No description provided for @fuelHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel history'**
  String get fuelHistoryTitle;

  /// No description provided for @fuelHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No fuel logs yet'**
  String get fuelHistoryEmptyTitle;

  /// No description provided for @fuelHistoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Log your first fuel stop from the dashboard.'**
  String get fuelHistoryEmptyBody;

  /// No description provided for @fuelAvgMileageAllTime.
  ///
  /// In en, this message translates to:
  /// **'Average mileage (all time)'**
  String get fuelAvgMileageAllTime;

  /// No description provided for @fieldNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get fieldNotesOptional;

  /// No description provided for @serviceStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get serviceStatusGood;

  /// No description provided for @serviceDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get serviceDueSoon;

  /// No description provided for @serviceStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get serviceStatusOverdue;

  /// No description provided for @serviceHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get serviceHistory;

  /// No description provided for @serviceLast.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String serviceLast(String date);

  /// No description provided for @serviceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No services logged'**
  String get serviceEmptyTitle;

  /// No description provided for @serviceEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap any item in \"Due soon\" to log a service.'**
  String get serviceEmptyBody;

  /// No description provided for @serviceLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log service'**
  String get serviceLogTitle;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service type'**
  String get serviceType;

  /// No description provided for @serviceOdometerKm.
  ///
  /// In en, this message translates to:
  /// **'Odometer (km)'**
  String get serviceOdometerKm;

  /// No description provided for @serviceCost.
  ///
  /// In en, this message translates to:
  /// **'Cost (₹)'**
  String get serviceCost;

  /// No description provided for @serviceNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Shop name, parts replaced...'**
  String get serviceNotesHint;

  /// No description provided for @serviceSave.
  ///
  /// In en, this message translates to:
  /// **'Save service'**
  String get serviceSave;

  /// No description provided for @serviceOilChange.
  ///
  /// In en, this message translates to:
  /// **'Oil Change'**
  String get serviceOilChange;

  /// No description provided for @serviceOilFilter.
  ///
  /// In en, this message translates to:
  /// **'Oil Filter'**
  String get serviceOilFilter;

  /// No description provided for @serviceAirFilter.
  ///
  /// In en, this message translates to:
  /// **'Air Filter'**
  String get serviceAirFilter;

  /// No description provided for @serviceChainClean.
  ///
  /// In en, this message translates to:
  /// **'Chain Clean'**
  String get serviceChainClean;

  /// No description provided for @serviceChainLube.
  ///
  /// In en, this message translates to:
  /// **'Chain Lube'**
  String get serviceChainLube;

  /// No description provided for @serviceBrakePads.
  ///
  /// In en, this message translates to:
  /// **'Brake Pads'**
  String get serviceBrakePads;

  /// No description provided for @serviceTyres.
  ///
  /// In en, this message translates to:
  /// **'Tyres'**
  String get serviceTyres;

  /// No description provided for @serviceBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get serviceBattery;

  /// No description provided for @serviceCoolant.
  ///
  /// In en, this message translates to:
  /// **'Coolant'**
  String get serviceCoolant;

  /// No description provided for @expenseFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get expenseFuel;

  /// No description provided for @expenseService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get expenseService;

  /// No description provided for @expenseParts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get expenseParts;

  /// No description provided for @expenseInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get expenseInsurance;

  /// No description provided for @expenseParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get expenseParking;

  /// No description provided for @expenseAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get expenseAccessories;

  /// No description provided for @expenseFine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get expenseFine;

  /// No description provided for @docRc.
  ///
  /// In en, this message translates to:
  /// **'RC Book'**
  String get docRc;

  /// No description provided for @docInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get docInsurance;

  /// No description provided for @docDrivingLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence'**
  String get docDrivingLicence;

  /// No description provided for @docPuc.
  ///
  /// In en, this message translates to:
  /// **'PUC Certificate'**
  String get docPuc;

  /// No description provided for @docInvoice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Invoice'**
  String get docInvoice;

  /// No description provided for @docWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty Card'**
  String get docWarranty;

  /// No description provided for @gradeExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent condition'**
  String get gradeExcellent;

  /// No description provided for @gradeGood.
  ///
  /// In en, this message translates to:
  /// **'Good condition'**
  String get gradeGood;

  /// No description provided for @gradeFair.
  ///
  /// In en, this message translates to:
  /// **'Fair condition'**
  String get gradeFair;

  /// No description provided for @gradePoor.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get gradePoor;

  /// No description provided for @gradeCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical — service now'**
  String get gradeCritical;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expensesTitle;

  /// No description provided for @expensesExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get expensesExportCsv;

  /// No description provided for @expensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get expensesByCategory;

  /// No description provided for @expensesTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get expensesTransactions;

  /// No description provided for @expensesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses'**
  String get expensesEmptyTitle;

  /// No description provided for @expensesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first expense this month.'**
  String get expensesEmptyBody;

  /// No description provided for @expensesCsvHeader.
  ///
  /// In en, this message translates to:
  /// **'Date,Category,Amount (₹),Note'**
  String get expensesCsvHeader;

  /// No description provided for @expensesCsvSubject.
  ///
  /// In en, this message translates to:
  /// **'Expenses — {month}'**
  String expensesCsvSubject(String month);

  /// No description provided for @expensesTotalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total spent'**
  String get expensesTotalSpent;

  /// No description provided for @expensesVsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{percent}% vs last month'**
  String expensesVsLastMonth(String percent);

  /// No description provided for @expensesAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expensesAddTitle;

  /// No description provided for @expensesCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expensesCategory;

  /// No description provided for @expensesAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount (₹)'**
  String get expensesAmount;

  /// No description provided for @expensesNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get expensesNoteOptional;

  /// No description provided for @expensesNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Merchant, description...'**
  String get expensesNoteHint;

  /// No description provided for @expensesSave.
  ///
  /// In en, this message translates to:
  /// **'Save expense'**
  String get expensesSave;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Store your RC, insurance, PUC and more in one place.'**
  String get documentsEmptyBody;

  /// No description provided for @documentsExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get documentsExpiringSoon;

  /// No description provided for @documentsValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get documentsValid;

  /// No description provided for @documentsExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get documentsExpired;

  /// No description provided for @documentsNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get documentsNoExpiry;

  /// No description provided for @documentsExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Expires in 1 day} other{Expires in {count} days}}'**
  String documentsExpiresInDays(int count);

  /// No description provided for @documentsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get documentsDelete;

  /// No description provided for @documentsExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get documentsExpiry;

  /// No description provided for @documentsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get documentsAddTitle;

  /// No description provided for @documentsType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentsType;

  /// No description provided for @documentsTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get documentsTitleField;

  /// No description provided for @documentsTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. RC Book, Policy #...'**
  String get documentsTitleHint;

  /// No description provided for @documentsExpiryOptional.
  ///
  /// In en, this message translates to:
  /// **'Expiry date (optional)'**
  String get documentsExpiryOptional;

  /// No description provided for @documentsPhotoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected'**
  String get documentsPhotoSelected;

  /// No description provided for @documentsAttachPhoto.
  ///
  /// In en, this message translates to:
  /// **'Attach photo'**
  String get documentsAttachPhoto;

  /// No description provided for @documentsSave.
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get documentsSave;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRides.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get navRides;

  /// No description provided for @navDocs.
  ///
  /// In en, this message translates to:
  /// **'Docs'**
  String get navDocs;

  /// No description provided for @ridesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'GPS ride tracking\ncoming soon'**
  String get ridesComingSoon;

  /// No description provided for @noBikeSelected.
  ///
  /// In en, this message translates to:
  /// **'Select a bike from the Home tab first.'**
  String get noBikeSelected;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'No internet — working offline'**
  String get offlineBanner;

  /// No description provided for @notifDocBody.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{{title} expires tomorrow} other{{title} expires in {days} days}}'**
  String notifDocBody(String title, int days);

  /// No description provided for @notifDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Document expiring in {days} days'**
  String notifDocTitle(int days);

  /// No description provided for @notifDocTomorrowTitle.
  ///
  /// In en, this message translates to:
  /// **'Document expires tomorrow!'**
  String get notifDocTomorrowTitle;

  /// No description provided for @notifServiceOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Service overdue — {bike}'**
  String notifServiceOverdueTitle(String bike);

  /// No description provided for @notifServiceOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'{service} needs attention'**
  String notifServiceOverdueBody(String service);

  /// No description provided for @healthOilNone.
  ///
  /// In en, this message translates to:
  /// **'No oil change recorded — log your first service'**
  String get healthOilNone;

  /// No description provided for @healthOilGood.
  ///
  /// In en, this message translates to:
  /// **'Oil changed {km} km ago — all good'**
  String healthOilGood(int km);

  /// No description provided for @healthOilOverdue.
  ///
  /// In en, this message translates to:
  /// **'Oil change overdue!'**
  String get healthOilOverdue;

  /// No description provided for @healthOilDue.
  ///
  /// In en, this message translates to:
  /// **'Oil change due in ~{km} km'**
  String healthOilDue(int km);

  /// No description provided for @healthChainNone.
  ///
  /// In en, this message translates to:
  /// **'No chain service recorded'**
  String get healthChainNone;

  /// No description provided for @healthChainGood.
  ///
  /// In en, this message translates to:
  /// **'Chain serviced {km} km ago'**
  String healthChainGood(int km);

  /// No description provided for @healthChainDue.
  ///
  /// In en, this message translates to:
  /// **'Chain service due in ~{km} km'**
  String healthChainDue(int km);

  /// No description provided for @healthAirNone.
  ///
  /// In en, this message translates to:
  /// **'No air filter service recorded'**
  String get healthAirNone;

  /// No description provided for @healthAirGood.
  ///
  /// In en, this message translates to:
  /// **'Air filter changed {km}k km ago'**
  String healthAirGood(String km);

  /// No description provided for @healthAirDue.
  ///
  /// In en, this message translates to:
  /// **'Air filter change due soon'**
  String get healthAirDue;

  /// No description provided for @healthBrakesNone.
  ///
  /// In en, this message translates to:
  /// **'No brake service recorded'**
  String get healthBrakesNone;

  /// No description provided for @healthBrakesGood.
  ///
  /// In en, this message translates to:
  /// **'Brakes checked {km}k km ago'**
  String healthBrakesGood(String km);

  /// No description provided for @healthBrakesDue.
  ///
  /// In en, this message translates to:
  /// **'Brake inspection recommended'**
  String get healthBrakesDue;

  /// No description provided for @healthTyresNone.
  ///
  /// In en, this message translates to:
  /// **'No tyre service recorded'**
  String get healthTyresNone;

  /// No description provided for @healthTyresGood.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{Tyres replaced 1 month ago} other{Tyres replaced {months} months ago}}'**
  String healthTyresGood(int months);

  /// No description provided for @healthTyresDue.
  ///
  /// In en, this message translates to:
  /// **'Tyre inspection recommended'**
  String get healthTyresDue;

  /// No description provided for @healthBatteryNone.
  ///
  /// In en, this message translates to:
  /// **'No battery service recorded'**
  String get healthBatteryNone;

  /// No description provided for @healthBatteryGood.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{Battery replaced 1 month ago} other{Battery replaced {months} months ago}}'**
  String healthBatteryGood(int months);

  /// No description provided for @healthBatteryDue.
  ///
  /// In en, this message translates to:
  /// **'Battery check recommended'**
  String get healthBatteryDue;

  /// No description provided for @healthInsuranceNotSet.
  ///
  /// In en, this message translates to:
  /// **'Insurance expiry date not set'**
  String get healthInsuranceNotSet;

  /// No description provided for @healthInsuranceExpired.
  ///
  /// In en, this message translates to:
  /// **'Insurance EXPIRED — renew immediately'**
  String get healthInsuranceExpired;

  /// No description provided for @healthInsuranceExpiring.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Insurance expires in 1 day — renew now} other{Insurance expires in {days} days — renew now}}'**
  String healthInsuranceExpiring(int days);

  /// No description provided for @healthInsuranceValid.
  ///
  /// In en, this message translates to:
  /// **'Insurance valid for {days} more days'**
  String healthInsuranceValid(int days);

  /// No description provided for @healthEconomyNeedMore.
  ///
  /// In en, this message translates to:
  /// **'Log more fill-ups to track fuel economy'**
  String get healthEconomyNeedMore;

  /// No description provided for @healthEconomyAverage.
  ///
  /// In en, this message translates to:
  /// **'Average: {mileage} km/L'**
  String healthEconomyAverage(String mileage);

  /// No description provided for @healthEconomyStable.
  ///
  /// In en, this message translates to:
  /// **'Fuel economy stable at {mileage} km/L'**
  String healthEconomyStable(String mileage);

  /// No description provided for @healthEconomyDropping.
  ///
  /// In en, this message translates to:
  /// **'Fuel economy dropping — service may be needed'**
  String get healthEconomyDropping;

  /// No description provided for @healthEconomyDeclining.
  ///
  /// In en, this message translates to:
  /// **'Fuel economy slightly declining — monitor it'**
  String get healthEconomyDeclining;

  /// No description provided for @addBikeHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan your RC card, or fill in the details yourself.'**
  String get addBikeHubSubtitle;

  /// No description provided for @addBikeScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan RC card'**
  String get addBikeScanTitle;

  /// No description provided for @addBikeScanBody.
  ///
  /// In en, this message translates to:
  /// **'Snap your RC and we\'ll fill in the details.'**
  String get addBikeScanBody;

  /// No description provided for @addBikeManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get addBikeManualTitle;

  /// No description provided for @addBikeManualBody.
  ///
  /// In en, this message translates to:
  /// **'Type in your bike\'s details yourself.'**
  String get addBikeManualBody;

  /// No description provided for @addBikeLookupTitle.
  ///
  /// In en, this message translates to:
  /// **'Look up by number'**
  String get addBikeLookupTitle;

  /// No description provided for @scanTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get scanTakePhoto;

  /// No description provided for @scanChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get scanChooseGallery;

  /// No description provided for @scanUseGemini.
  ///
  /// In en, this message translates to:
  /// **'Read with Gemini AI'**
  String get scanUseGemini;

  /// No description provided for @scanUseGeminiBody.
  ///
  /// In en, this message translates to:
  /// **'More accurate. Your RC photo is sent to Google to read the vehicle details. When off, the photo is read on your phone only.'**
  String get scanUseGeminiBody;

  /// No description provided for @scanReading.
  ///
  /// In en, this message translates to:
  /// **'Reading your RC…'**
  String get scanReading;

  /// No description provided for @vehicleScanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Details read from your RC. Check everything before saving.'**
  String get vehicleScanSuccess;

  /// No description provided for @vehicleScanFailure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read your RC clearly. Please fill in the details below.'**
  String get vehicleScanFailure;

  /// No description provided for @vehicleSectionYourBike.
  ///
  /// In en, this message translates to:
  /// **'YOUR BIKE'**
  String get vehicleSectionYourBike;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
