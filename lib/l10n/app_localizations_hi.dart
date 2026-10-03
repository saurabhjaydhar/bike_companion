// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonDelete => 'हटाएं';

  @override
  String get commonOther => 'अन्य';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get settingsSystemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settingsLight => 'लाइट';

  @override
  String get settingsDark => 'डार्क';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsAbout => 'ऐप के बारे में';

  @override
  String get settingsVersion => 'संस्करण';

  @override
  String get settingsBuiltWithFlutter => 'Flutter से बनाया गया';

  @override
  String get settingsAccount => 'खाता';

  @override
  String get settingsSignedIn => 'साइन इन है';

  @override
  String get settingsSignOut => 'साइन आउट';

  @override
  String get settingsSignOutTitle => 'साइन आउट करें?';

  @override
  String get settingsSignOutBody =>
      'आपका लोकल डेटा इसी डिवाइस पर रहेगा। आप कभी भी फिर से साइन इन कर सकते हैं।';

  @override
  String get settingsData => 'डेटा';

  @override
  String get settingsClearAllData => 'सारा डेटा मिटाएं';

  @override
  String get settingsClearTitle => 'सारा डेटा मिटाएं?';

  @override
  String get settingsClearBody =>
      'इससे सभी वाहन, ईंधन लॉग, सर्विस रिकॉर्ड, खर्च और दस्तावेज़ स्थायी रूप से हट जाएंगे। इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get settingsDataCleared => 'सारा डेटा मिटा दिया गया';

  @override
  String get settingsDeleteAccount => 'खाता हटाएं';

  @override
  String get settingsDeleteAccountSubtitle =>
      'आपका खाता हमेशा के लिए हटा देता है (GDPR)';

  @override
  String get settingsDeleteAccountTitle => 'खाता हटाएं?';

  @override
  String get settingsDeleteAccountBody =>
      'इससे आपका Firebase खाता हमेशा के लिए हट जाएगा। आपका लोकल डेटा इसी डिवाइस पर रहेगा। इसे वापस नहीं किया जा सकता।';

  @override
  String get settingsDeleteAccountError =>
      'खाता नहीं हटाया जा सका। कृपया फिर से साइन इन करके दोबारा कोशिश करें।';

  @override
  String get appTitle => 'Garajo';

  @override
  String get commonContinue => 'जारी रखें';

  @override
  String authSignInFailed(String error) {
    return 'साइन इन नहीं हो सका: $error';
  }

  @override
  String get authOfflineTitle => 'बिना खाते के जारी रखें?';

  @override
  String get authOfflineBody =>
      'आपका डेटा सिर्फ़ इसी डिवाइस पर सेव होगा। इसका बैकअप नहीं होगा और यह दूसरे डिवाइस पर सिंक नहीं होगा।\n\nआप कभी भी सेटिंग्स से साइन इन कर सकते हैं।';

  @override
  String get authOfflineError =>
      'ऑफ़लाइन सेशन शुरू नहीं हो सका। कृपया दोबारा कोशिश करें।';

  @override
  String get authTagline =>
      'अपनी बाइक, स्कूटर या कार के\nईंधन, सर्विस और खर्च ट्रैक करें';

  @override
  String get authContinueWithGoogle => 'Google से जारी रखें';

  @override
  String get authContinueWithoutAccount => 'बिना खाते के जारी रखें';

  @override
  String get authTerms =>
      'जारी रखकर आप हमारी शर्तों और गोपनीयता नीति से सहमत होते हैं।';

  @override
  String get onboardingWelcomeTitle => 'Garajo में आपका स्वागत है';

  @override
  String get onboardingAddMyVehicle => 'मेरा वाहन जोड़ें';

  @override
  String get fieldBrand => 'ब्रांड';

  @override
  String get fieldModel => 'मॉडल';

  @override
  String get fieldModelHint => 'जैसे Classic 350, Activa';

  @override
  String get fieldNickname => 'उपनाम';

  @override
  String get fieldNicknameHint => 'आप इसे क्या कहते हैं?';

  @override
  String get fieldColour => 'रंग';

  @override
  String get fieldSelectDate => 'तारीख चुनें';

  @override
  String get fieldCurrentOdometer => 'मौजूदा ओडोमीटर (km)';

  @override
  String get fieldInsuranceExpiry => 'बीमा समाप्ति';

  @override
  String get fieldPucExpiry => 'PUC समाप्ति';

  @override
  String get validationRequired => 'ज़रूरी है';

  @override
  String get validationEnterNumber => 'कोई संख्या दर्ज करें';

  @override
  String get addVehicleInvalidFormat =>
      'गलत फ़ॉर्मेट। MH12DE1234 या DL01AA1234 जैसा फ़ॉर्मेट इस्तेमाल करें।';

  @override
  String get addVehicleNotFound => 'रजिस्ट्री में वाहन नहीं मिला।';

  @override
  String get addVehicleApiLimit =>
      'API सीमा पूरी हो गई। कृपया बाद में दोबारा कोशिश करें।';

  @override
  String get addVehicleNoInternet =>
      'इंटरनेट कनेक्शन नहीं है। कृपया अपना नेटवर्क जांचें।';

  @override
  String get addVehicleFetchFailed => 'वाहन की जानकारी नहीं मिल सकी।';

  @override
  String get addVehicleTitle => 'अपना वाहन जोड़ें';

  @override
  String get addVehicleSubtitle =>
      'अपना रजिस्ट्रेशन नंबर डालें, हम आपके वाहन की जानकारी अपने-आप भर देंगे।';

  @override
  String get addVehicleExamples => 'जैसे UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'जारी रखें →';

  @override
  String get addVehicleFetching => 'वाहन की जानकारी लाई जा रही है…';

  @override
  String get vehicleBrandRequired => 'ब्रांड ज़रूरी है';

  @override
  String get vehicleModelRequired => 'मॉडल ज़रूरी है';

  @override
  String get vehicleSaveFailed =>
      'वाहन सहेजा नहीं जा सका। कृपया फिर से कोशिश करें।';

  @override
  String get vehicleDetailsTitle => 'वाहन की जानकारी';

  @override
  String get vehicleSectionRegistration => 'रजिस्ट्रेशन';

  @override
  String get vehicleRcNumber => 'RC नंबर';

  @override
  String get vehicleSectionInfo => 'वाहन की जानकारी';

  @override
  String get vehicleManufacturer => 'निर्माता';

  @override
  String get vehicleFuelType => 'फ्यूल का प्रकार';

  @override
  String get vehicleClass => 'वाहन श्रेणी';

  @override
  String get vehicleSectionRegistrationDetails => 'रजिस्ट्रेशन विवरण';

  @override
  String get vehicleRegistrationDate => 'रजिस्ट्रेशन की तारीख';

  @override
  String get vehicleSectionIdentifiers => 'पहचान नंबर';

  @override
  String get vehicleEngineNumber => 'इंजन नंबर';

  @override
  String get vehicleChassisNumber => 'चेसिस नंबर';

  @override
  String get vehicleSaveVehicle => 'वाहन सहेजें';

  @override
  String get vehicleFetchSuccess =>
      'वाहन की जानकारी मिल गई। जांचें और पुष्टि करें।';

  @override
  String get vehicleFetchFailure =>
      'वाहन की जानकारी नहीं मिल सकी। कृपया नीचे खुद भरें।';

  @override
  String commonError(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get commonThisMonth => 'इस महीने';

  @override
  String get garageTitle => 'मेरा गैराज';

  @override
  String get garageEmptyTitle => 'अभी कोई वाहन नहीं';

  @override
  String get garageEmptyBody =>
      'ईंधन, सर्विस और खर्च ट्रैक करना शुरू करने के लिए अपनी पहली बाइक, स्कूटर या कार जोड़ें।';

  @override
  String get garageYourVehicles => 'आपके वाहन';

  @override
  String get garageAddAnother => 'एक और वाहन जोड़ें';

  @override
  String get garageStatVehicles => 'वाहन';

  @override
  String get garageStatAlerts => 'अलर्ट';

  @override
  String garageDeleteVehicle(String name) {
    return '$name हटाएं';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return '$name हटाएं?';
  }

  @override
  String get garageDeleteVehicleBody =>
      'सभी फ्यूल लॉग, सर्विस रिकॉर्ड और खर्च हट जाएंगे।';

  @override
  String get commonToday => 'आज';

  @override
  String get commonYesterday => 'कल';

  @override
  String commonDaysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get commonNotSet => 'सेट नहीं है';

  @override
  String get fieldOdometer => 'ओडोमीटर';

  @override
  String get dashboardTitle => 'डैशबोर्ड';

  @override
  String get dashboardLogFuel => 'फ्यूल भरवाना दर्ज करें';

  @override
  String get dashboardRecentActivity => 'हाल की गतिविधि';

  @override
  String get dashboardSeeAll => 'सभी देखें';

  @override
  String get dashboardThisMonth => 'इस महीने';

  @override
  String get dashboardLastFuel => 'पिछला फ्यूल';

  @override
  String get dashboardNotLogged => 'दर्ज नहीं';

  @override
  String dashboardAvgMileage(String mileage) {
    return 'औसत $mileage km/L';
  }

  @override
  String get dashboardNextService => 'अगली सर्विस';

  @override
  String get dashboardUpToDate => 'सब ठीक है';

  @override
  String dashboardDaysLeft(int count) {
    return '$count दिन बाकी';
  }

  @override
  String get dashboardFuelStop => 'फ्यूल स्टॉप';

  @override
  String fuelOdometerTooLow(int km) {
    return 'ओडोमीटर पिछली एंट्री ($km km) से ज़्यादा होना चाहिए';
  }

  @override
  String get fuelLogged => 'फ्यूल स्टॉप दर्ज हो गया!';

  @override
  String get fuelCurrentOdometer => 'मौजूदा ओडोमीटर';

  @override
  String fuelLastEntry(int km) {
    return 'पिछली एंट्री: $km km';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return 'पिछली बार भरवाने के बाद $km km · अनुमानित ~$litres L';
  }

  @override
  String fuelKmSinceLast(int km) {
    return 'पिछली बार भरवाने के बाद $km km';
  }

  @override
  String get fuelAddMoreDetails => 'और जानकारी जोड़ें';

  @override
  String get fuelLitresFilled => 'कितने लीटर भरवाए';

  @override
  String get fuelAmountPaid => 'भुगतान की गई राशि';

  @override
  String get fuelStationOptional => 'पेट्रोल पंप (वैकल्पिक)';

  @override
  String get fuelStationHint => 'HP, Indian Oil, Bharat...';

  @override
  String get fuelReceiptSoon => 'रसीद स्कैन जल्द आ रहा है!';

  @override
  String get fuelScanReceipt => 'रसीद स्कैन करें';

  @override
  String get fuelSave => 'फ्यूल स्टॉप सेव करें';

  @override
  String get fuelHistoryTitle => 'फ्यूल इतिहास';

  @override
  String get fuelHistoryEmptyTitle => 'अभी कोई फ्यूल लॉग नहीं है';

  @override
  String get fuelHistoryEmptyBody =>
      'डैशबोर्ड से अपना पहला फ्यूल स्टॉप दर्ज करें।';

  @override
  String get fuelAvgMileageAllTime => 'औसत माइलेज (अब तक)';

  @override
  String get fieldNotesOptional => 'नोट्स (वैकल्पिक)';

  @override
  String get serviceStatusGood => 'ठीक';

  @override
  String get serviceDueSoon => 'जल्द ज़रूरी';

  @override
  String get serviceStatusOverdue => 'समय निकल गया';

  @override
  String get serviceHistory => 'इतिहास';

  @override
  String serviceLast(String date) {
    return 'पिछली बार: $date';
  }

  @override
  String get serviceEmptyTitle => 'कोई सर्विस दर्ज नहीं है';

  @override
  String get serviceEmptyBody =>
      'सर्विस दर्ज करने के लिए \"जल्द ज़रूरी\" में किसी भी आइटम पर टैप करें।';

  @override
  String get serviceLogTitle => 'सर्विस दर्ज करें';

  @override
  String get serviceType => 'सर्विस का प्रकार';

  @override
  String get serviceOdometerKm => 'ओडोमीटर (km)';

  @override
  String get serviceCost => 'खर्च (₹)';

  @override
  String get serviceNotesHint => 'दुकान का नाम, बदले गए पार्ट्स...';

  @override
  String get serviceSave => 'सर्विस सेव करें';

  @override
  String get serviceOilChange => 'ऑयल बदलना';

  @override
  String get serviceOilFilter => 'ऑयल फ़िल्टर';

  @override
  String get serviceAirFilter => 'एयर फ़िल्टर';

  @override
  String get serviceChainClean => 'चेन सफ़ाई';

  @override
  String get serviceChainLube => 'चेन लुब्रिकेशन';

  @override
  String get serviceBrakePads => 'ब्रेक पैड';

  @override
  String get serviceTyres => 'टायर';

  @override
  String get serviceBattery => 'बैटरी';

  @override
  String get serviceCoolant => 'कूलेंट';

  @override
  String get expenseFuel => 'फ्यूल';

  @override
  String get expenseService => 'सर्विस';

  @override
  String get expenseParts => 'पार्ट्स';

  @override
  String get expenseInsurance => 'बीमा';

  @override
  String get expenseParking => 'पार्किंग';

  @override
  String get expenseAccessories => 'एक्सेसरीज़';

  @override
  String get expenseFine => 'चालान';

  @override
  String get docRc => 'RC बुक';

  @override
  String get docInsurance => 'बीमा';

  @override
  String get docDrivingLicence => 'ड्राइविंग लाइसेंस';

  @override
  String get docPuc => 'PUC प्रमाणपत्र';

  @override
  String get docInvoice => 'खरीद का बिल';

  @override
  String get docWarranty => 'वारंटी कार्ड';

  @override
  String get gradeExcellent => 'बेहतरीन हालत';

  @override
  String get gradeGood => 'अच्छी हालत';

  @override
  String get gradeFair => 'ठीक-ठाक हालत';

  @override
  String get gradePoor => 'ध्यान देने की ज़रूरत';

  @override
  String get gradeCritical => 'गंभीर — अभी सर्विस कराएं';

  @override
  String get expensesTitle => 'खर्च';

  @override
  String get expensesExportCsv => 'CSV एक्सपोर्ट करें';

  @override
  String get expensesByCategory => 'श्रेणी के अनुसार';

  @override
  String get expensesTransactions => 'लेन-देन';

  @override
  String get expensesEmptyTitle => 'कोई खर्च नहीं';

  @override
  String get expensesEmptyBody =>
      'इस महीने का पहला खर्च जोड़ने के लिए + पर टैप करें।';

  @override
  String get expensesCsvHeader => 'तारीख,श्रेणी,राशि (₹),नोट';

  @override
  String expensesCsvSubject(String month) {
    return 'खर्च — $month';
  }

  @override
  String get expensesTotalSpent => 'कुल खर्च';

  @override
  String expensesVsLastMonth(String percent) {
    return 'पिछले महीने की तुलना में $percent%';
  }

  @override
  String get expensesAddTitle => 'खर्च जोड़ें';

  @override
  String get expensesCategory => 'श्रेणी';

  @override
  String get expensesAmount => 'राशि (₹)';

  @override
  String get expensesNoteOptional => 'नोट (वैकल्पिक)';

  @override
  String get expensesNoteHint => 'दुकान, विवरण...';

  @override
  String get expensesSave => 'खर्च सेव करें';

  @override
  String get documentsTitle => 'दस्तावेज़';

  @override
  String get documentsEmptyTitle => 'कोई दस्तावेज़ नहीं';

  @override
  String get documentsEmptyBody =>
      'अपना RC, बीमा, PUC और बहुत कुछ एक ही जगह रखें।';

  @override
  String get documentsExpiringSoon => 'जल्द समाप्त होने वाले';

  @override
  String get documentsValid => 'वैध';

  @override
  String get documentsExpired => 'समाप्त';

  @override
  String get documentsNoExpiry => 'कोई समाप्ति नहीं';

  @override
  String documentsExpiresInDays(int count) {
    return '$count दिन में समाप्त';
  }

  @override
  String get documentsDelete => 'दस्तावेज़ हटाएं';

  @override
  String get documentsExpiry => 'समाप्ति';

  @override
  String get documentsAddTitle => 'दस्तावेज़ जोड़ें';

  @override
  String get documentsType => 'दस्तावेज़ का प्रकार';

  @override
  String get documentsTitleField => 'शीर्षक';

  @override
  String get documentsTitleHint => 'जैसे RC बुक, पॉलिसी नंबर...';

  @override
  String get documentsExpiryOptional => 'समाप्ति की तारीख (वैकल्पिक)';

  @override
  String get documentsPhotoSelected => 'फ़ोटो चुनी गई';

  @override
  String get documentsAttachPhoto => 'फ़ोटो जोड़ें';

  @override
  String get documentsSave => 'दस्तावेज़ सेव करें';

  @override
  String get navHome => 'होम';

  @override
  String get navRides => 'राइड्स';

  @override
  String get navDocs => 'दस्तावेज़';

  @override
  String get ridesComingSoon => 'GPS राइड ट्रैकिंग\nजल्द आ रही है';

  @override
  String get noVehicleSelected => 'पहले होम टैब से एक वाहन चुनें।';

  @override
  String get offlineBanner => 'इंटरनेट नहीं है — ऑफ़लाइन काम कर रहे हैं';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'सर्विस का समय निकल गया — $vehicle';
  }

  @override
  String get healthOilNone =>
      'ऑयल बदलने का कोई रिकॉर्ड नहीं — अपनी पहली सर्विस दर्ज करें';

  @override
  String healthOilGood(int km) {
    return '$km km पहले ऑयल बदला गया — सब ठीक है';
  }

  @override
  String get healthOilOverdue => 'ऑयल बदलने का समय निकल गया!';

  @override
  String healthOilDue(int km) {
    return 'लगभग $km km में ऑयल बदलना है';
  }

  @override
  String get healthChainNone => 'चेन सर्विस का कोई रिकॉर्ड नहीं';

  @override
  String healthChainGood(int km) {
    return '$km km पहले चेन की सर्विस हुई';
  }

  @override
  String healthChainDue(int km) {
    return 'लगभग $km km में चेन सर्विस करानी है';
  }

  @override
  String get healthAirNone => 'एयर फ़िल्टर सर्विस का कोई रिकॉर्ड नहीं';

  @override
  String healthAirGood(String km) {
    return '$km हज़ार km पहले एयर फ़िल्टर बदला गया';
  }

  @override
  String get healthAirDue => 'एयर फ़िल्टर जल्द बदलना है';

  @override
  String get healthBrakesNone => 'ब्रेक सर्विस का कोई रिकॉर्ड नहीं';

  @override
  String healthBrakesGood(String km) {
    return '$km हज़ार km पहले ब्रेक की जांच हुई';
  }

  @override
  String get healthBrakesDue => 'ब्रेक की जांच कराने की सलाह है';

  @override
  String get healthTyresNone => 'टायर सर्विस का कोई रिकॉर्ड नहीं';

  @override
  String healthTyresGood(int months) {
    return '$months महीने पहले टायर बदले गए';
  }

  @override
  String get healthTyresDue => 'टायर की जांच कराने की सलाह है';

  @override
  String get healthBatteryNone => 'बैटरी सर्विस का कोई रिकॉर्ड नहीं';

  @override
  String healthBatteryGood(int months) {
    return '$months महीने पहले बैटरी बदली गई';
  }

  @override
  String get healthBatteryDue => 'बैटरी की जांच कराने की सलाह है';

  @override
  String get healthInsuranceNotSet => 'बीमा समाप्ति की तारीख सेट नहीं है';

  @override
  String get healthInsuranceExpired =>
      'बीमा समाप्त हो गया — तुरंत रिन्यू कराएं';

  @override
  String healthInsuranceExpiring(int days) {
    return 'बीमा $days दिन में समाप्त हो रहा है — अभी रिन्यू कराएं';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'बीमा $days दिन और वैध है';
  }

  @override
  String get healthEconomyNeedMore =>
      'माइलेज ट्रैक करने के लिए और फ्यूल एंट्री दर्ज करें';

  @override
  String healthEconomyAverage(String mileage) {
    return 'औसत: $mileage km/L';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'माइलेज $mileage km/L पर स्थिर है';
  }

  @override
  String get healthEconomyDropping =>
      'माइलेज गिर रहा है — सर्विस की ज़रूरत हो सकती है';

  @override
  String get healthEconomyDeclining => 'माइलेज थोड़ा कम हो रहा है — ध्यान रखें';

  @override
  String get addVehicleHubSubtitle =>
      'अपना RC कार्ड स्कैन करें, या जानकारी खुद भरें।';

  @override
  String get addVehicleScanTitle => 'RC कार्ड स्कैन करें';

  @override
  String get addVehicleScanBody => 'अपने RC की फ़ोटो लें, हम जानकारी भर देंगे।';

  @override
  String get addVehicleManualTitle => 'खुद दर्ज करें';

  @override
  String get addVehicleManualBody => 'अपने वाहन का विवरण खुद भरें।';

  @override
  String get addVehicleLookupTitle => 'नंबर से खोजें';

  @override
  String get scanTakePhoto => 'फ़ोटो लें';

  @override
  String get scanChooseGallery => 'गैलरी से चुनें';

  @override
  String get scanUseGemini => 'Gemini AI से पढ़ें';

  @override
  String get scanUseGeminiBody =>
      'ज़्यादा सटीक। वाहन की जानकारी पढ़ने के लिए आपके RC की फ़ोटो Google को भेजी जाती है। बंद होने पर फ़ोटो सिर्फ़ आपके फ़ोन पर पढ़ी जाती है।';

  @override
  String get scanReading => 'आपका RC पढ़ा जा रहा है…';

  @override
  String get scanTitle => 'अपना RC स्कैन करें';

  @override
  String get scanSubtitle =>
      'अपने RC कार्ड के दोनों तरफ़ की फ़ोटो जोड़ें — हर तरफ़ अलग जानकारी होती है। RC बुक या डिजिटल RC के लिए एक फ़ोटो काफ़ी है।';

  @override
  String get scanFront => 'सामने की तरफ़';

  @override
  String get scanFrontHint => 'रजिस्ट्रेशन नंबर, चेसिस और इंजन नंबर';

  @override
  String get scanBack => 'पीछे की तरफ़';

  @override
  String get scanBackHint => 'निर्माता, मॉडल और वाहन श्रेणी';

  @override
  String get scanAddPhoto => 'फ़ोटो जोड़ने के लिए टैप करें';

  @override
  String get scanRemovePhoto => 'फ़ोटो हटाएँ';

  @override
  String get scanReadDetails => 'जानकारी पढ़ें';

  @override
  String get scanPickerError =>
      'कैमरा या गैलरी नहीं खुल सकी। सेटिंग्स में ऐप की अनुमतियाँ जाँचें।';

  @override
  String get vehicleScanSuccess =>
      'आपके RC से जानकारी पढ़ ली गई। सेव करने से पहले सब कुछ जांच लें।';

  @override
  String get vehicleScanFailure =>
      'आपका RC साफ़ नहीं पढ़ा जा सका। कृपया नीचे जानकारी भरें।';

  @override
  String get vehicleSectionYourVehicle => 'आपका वाहन';

  @override
  String get vahanSmsButton => 'VAHAN पर SMS से जांचें';

  @override
  String get vahanSmsHint =>
      'आपका नंबर आधिकारिक VAHAN SMS सेवा को भेजता है। जवाब आपके SMS इनबॉक्स में आएगा — जानकारी इस फ़ॉर्म में भर दें।';

  @override
  String get vahanSmsError => 'आपका SMS ऐप नहीं खुल सका।';

  @override
  String get vehicleRegValidity => 'पंजीकरण वैधता तिथि';

  @override
  String get dueRegistration => 'पंजीकरण';

  @override
  String notifExpiryTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item $days दिनों में समाप्त हो रहा है',
      one: '$item कल समाप्त हो रहा है',
    );
    return '$_temp0';
  }

  @override
  String notifServiceDueTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$item $days दिनों में देय है',
      one: '$item कल देय है',
    );
    return '$_temp0';
  }

  @override
  String notifDueBody(String vehicle, String date) {
    return '$vehicle · $date। अपडेट करने के लिए टैप करें।';
  }

  @override
  String get comingUpTitle => 'आने वाला';

  @override
  String get comingUpEmpty => 'सब ठीक है — जल्द कुछ भी देय नहीं।';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिनों में',
      one: 'कल',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String dueOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन की देरी',
      one: '1 दिन की देरी',
    );
    return '$_temp0';
  }

  @override
  String get dueAddDate => 'तिथि जोड़ें';

  @override
  String get dueServiceSoon => 'जल्द देय';

  @override
  String get dueServiceOverdue => 'देरी हो गई';

  @override
  String dueValidUntil(String item) {
    return '$item वैधता तिथि';
  }

  @override
  String get dueUpdated => 'तिथि सहेजी गई — रिमाइंडर अपडेट हुए';

  @override
  String get remindersTurnOn => 'चालू करें';

  @override
  String get remindersOffBody =>
      'रिमाइंडर बंद हैं। बीमा, PUC और सर्विस की तारीख से पहले सूचना पाने के लिए इन्हें चालू करें।';

  @override
  String get remindersMutedNote => 'इस वाहन के लिए रिमाइंडर बंद हैं।';

  @override
  String get remindersPermissionTitle => 'रिमाइंडर पाएं?';

  @override
  String get remindersPermissionBody =>
      'बीमा, PUC और दस्तावेज़ समाप्त होने से 30, 7 और 1 दिन पहले हम आपको याद दिलाएंगे — सुबह 9 बजे, रात में कभी नहीं।';

  @override
  String get remindersNotNow => 'अभी नहीं';

  @override
  String get remindersEnableInSettings =>
      'सूचनाएं बंद हैं। फ़ोन की सेटिंग्स में इस ऐप के लिए इन्हें चालू करें।';

  @override
  String get settingsReminders => 'रिमाइंडर';

  @override
  String settingsRemindersNext(String item, String date) {
    return 'अगला: $item · $date';
  }

  @override
  String get settingsRemindersNone => 'जल्द कुछ भी देय नहीं';

  @override
  String get expensesModeMonth => 'महीना';

  @override
  String get expensesModeYear => 'वर्ष';

  @override
  String expensesVsLastYear(String percent) {
    return 'पिछले वर्ष से $percent%';
  }

  @override
  String get expensesAvgMonthly => 'औसत / माह';

  @override
  String get expensesCostPerKm => 'लागत / किमी';

  @override
  String get expensesFuelPerKm => 'ईंधन / किमी';

  @override
  String get expensesNeedOdometer =>
      'प्रति किमी लागत देखने के लिए ओडोमीटर रीडिंग के साथ ईंधन या सर्विस दर्ज करें।';

  @override
  String get expensesFromFuelLog => 'ईंधन लॉग';

  @override
  String get expensesFromService => 'सर्विस';

  @override
  String get expensesDeleted => 'खर्च हटाया गया';

  @override
  String get commonUndo => 'पूर्ववत करें';

  @override
  String get budgetTitle => 'बजट';

  @override
  String budgetOf(String spent, String budget) {
    return '$budget में से $spent';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount बाकी';
  }

  @override
  String budgetLeftOf(String left, String budget) {
    return '$budget में से $left बाकी';
  }

  @override
  String budgetOver(String amount) {
    return 'बजट से $amount अधिक';
  }

  @override
  String get budgetSet => 'बजट तय करें';

  @override
  String get budgetSetPrompt => 'खर्च नियंत्रण में रखने के लिए बजट तय करें।';

  @override
  String get budgetSheetTitle => 'खर्च बजट';

  @override
  String get budgetMonthly => 'मासिक बजट';

  @override
  String get budgetYearly => 'वार्षिक बजट';

  @override
  String budgetSuggested(String amount) {
    return 'हाल के महीनों के आधार पर सुझाव: $amount';
  }

  @override
  String get budgetSave => 'बजट सहेजें';

  @override
  String get budgetRemove => 'बजट हटाएं';

  @override
  String budgetAlertTitle(String vehicle) {
    return 'बजट अलर्ट — $vehicle';
  }

  @override
  String budgetAlertMonth(int percent) {
    return 'आपने इस महीने के बजट का $percent% उपयोग कर लिया है।';
  }

  @override
  String budgetAlertYear(int percent) {
    return 'आपने इस वर्ष के बजट का $percent% उपयोग कर लिया है।';
  }

  @override
  String get garageSpending => 'खर्च';

  @override
  String get garageThisYear => 'इस वर्ष';

  @override
  String get vehicleTypeTitle => 'वाहन का प्रकार';

  @override
  String get vehicleTypeDetected =>
      'आपके RC से पहचाना गया — गलत हो तो बदल दें।';

  @override
  String get vehicleTypeBike => 'बाइक';

  @override
  String get vehicleTypeScooter => 'स्कूटर';

  @override
  String get vehicleTypeCar => 'कार';

  @override
  String get serviceWheelAlignment => 'व्हील अलाइनमेंट';

  @override
  String get serviceAcService => 'AC सर्विस';

  @override
  String get serviceWipers => 'वाइपर';

  @override
  String get onboardingSlideTrackTitle => 'हर रुपये का हिसाब';

  @override
  String get onboardingSlideTrackBody =>
      'ईंधन, सर्विस और खर्च एक ही जगह — हर वाहन के लिए बजट और प्रति किमी लागत के साथ।';

  @override
  String get onboardingSlideRemindTitle => 'कोई तारीख न छूटे';

  @override
  String get onboardingSlideRemindBody =>
      'बीमा, PUC और सर्विस की तारीख से पहले रिमाइंडर — सुबह 9 बजे, रात में कभी नहीं।';

  @override
  String get onboardingSlideScanTitle => 'टाइप नहीं, स्कैन करें';

  @override
  String get onboardingSlideScanBody =>
      'अपने RC की फ़ोटो लें और हम आपके वाहन का विवरण भर देंगे।';
}
