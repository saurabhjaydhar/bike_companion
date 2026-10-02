class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 20;
  static const double full = 999;
}

class AppDuration {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration healthRing = Duration(milliseconds: 1200);
  static const Duration stagger = Duration(milliseconds: 50);
}

class ServiceTypes {
  static const String oilChange = 'oil_change';
  static const String oilFilter = 'oil_filter';
  static const String airFilter = 'air_filter';
  static const String chainClean = 'chain_clean';
  static const String chainLube = 'chain_lube';
  static const String brakePads = 'brake_pads';
  static const String tyres = 'tyres';
  static const String battery = 'battery';
  static const String coolant = 'coolant';
  static const String other = 'other';

  static const List<String> all = [
    oilChange, oilFilter, airFilter, chainClean, chainLube,
    brakePads, tyres, battery, coolant, other,
  ];
}

class ExpenseCategories {
  static const String fuel = 'fuel';
  static const String service = 'service';
  static const String parts = 'parts';
  static const String insurance = 'insurance';
  static const String parking = 'parking';
  static const String accessories = 'accessories';
  static const String fine = 'fine';
  static const String other = 'other';

  static const List<String> all = [
    fuel, service, parts, insurance, parking, accessories, fine, other,
  ];
}

class DocumentTypes {
  static const String rc = 'rc';
  static const String insurance = 'insurance';
  static const String drivingLicence = 'driving_licence';
  static const String puc = 'puc';
  static const String invoice = 'invoice';
  static const String warranty = 'warranty';
  static const String other = 'other';

  static const List<String> all = [
    rc, insurance, drivingLicence, puc, invoice, warranty, other,
  ];
}

class SharedPrefKeys {
  static const String activeBikeId = 'active_bike_id';
  static const String isOnboardingDone = 'is_onboarding_done';
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String rcScanUseGemini = 'rc_scan_use_gemini';
}

const List<String> kIndianBrands = [
  'Royal Enfield', 'Honda', 'Bajaj', 'TVS', 'Hero',
  'Yamaha', 'Suzuki', 'KTM', 'Kawasaki', 'BMW', 'Other',
];
