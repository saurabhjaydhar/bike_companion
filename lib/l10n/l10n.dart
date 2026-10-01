import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../data/models/health_score.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Localizations for code that runs without a BuildContext (e.g. scheduled
/// notifications). Uses the language picked in Settings, else the device's.
Future<AppLocalizations> loadAppLocalizations() async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(SharedPrefKeys.locale) ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  final supported =
      AppLocalizations.supportedLocales.any((l) => l.languageCode == code);
  return lookupAppLocalizations(Locale(supported ? code : 'en'));
}

/// Localized labels for the stable type/category keys stored in the database.
extension L10nLabels on AppLocalizations {
  String serviceTypeLabel(String type) {
    switch (type) {
      case ServiceTypes.oilChange: return serviceOilChange;
      case ServiceTypes.oilFilter: return serviceOilFilter;
      case ServiceTypes.airFilter: return serviceAirFilter;
      case ServiceTypes.chainClean: return serviceChainClean;
      case ServiceTypes.chainLube: return serviceChainLube;
      case ServiceTypes.brakePads: return serviceBrakePads;
      case ServiceTypes.tyres: return serviceTyres;
      case ServiceTypes.battery: return serviceBattery;
      case ServiceTypes.coolant: return serviceCoolant;
      default: return commonOther;
    }
  }

  String expenseCategoryLabel(String category) {
    switch (category) {
      case ExpenseCategories.fuel: return expenseFuel;
      case ExpenseCategories.service: return expenseService;
      case ExpenseCategories.parts: return expenseParts;
      case ExpenseCategories.insurance: return expenseInsurance;
      case ExpenseCategories.parking: return expenseParking;
      case ExpenseCategories.accessories: return expenseAccessories;
      case ExpenseCategories.fine: return expenseFine;
      default: return commonOther;
    }
  }

  String documentTypeLabel(String type) {
    switch (type) {
      case DocumentTypes.rc: return docRc;
      case DocumentTypes.insurance: return docInsurance;
      case DocumentTypes.drivingLicence: return docDrivingLicence;
      case DocumentTypes.puc: return docPuc;
      case DocumentTypes.invoice: return docInvoice;
      case DocumentTypes.warranty: return docWarranty;
      default: return commonOther;
    }
  }

  String healthGradeLabel(HealthGrade grade) {
    switch (grade) {
      case HealthGrade.excellent: return gradeExcellent;
      case HealthGrade.good: return gradeGood;
      case HealthGrade.fair: return gradeFair;
      case HealthGrade.poor: return gradePoor;
      case HealthGrade.critical: return gradeCritical;
    }
  }
}
