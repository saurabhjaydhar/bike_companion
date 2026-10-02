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
      'इससे सभी बाइक, फ्यूल लॉग, सर्विस रिकॉर्ड, खर्च और दस्तावेज़ हमेशा के लिए हट जाएंगे। इसे वापस नहीं किया जा सकता।';

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
  String get appTitle => 'बाइक कंपेनियन';

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
      'अपनी मोटरसाइकिल का फ्यूल, सर्विस\nऔर खर्च ट्रैक करें';

  @override
  String get authContinueWithGoogle => 'Google से जारी रखें';

  @override
  String get authContinueWithoutAccount => 'बिना खाते के जारी रखें';

  @override
  String get authTerms =>
      'जारी रखकर आप हमारी शर्तों और गोपनीयता नीति से सहमत होते हैं।';

  @override
  String get onboardingWelcomeTitle => 'आपकी बाइक,\nहमेशा फिट';

  @override
  String get onboardingWelcomeBody =>
      'फ्यूल, सर्विस, खर्च और दस्तावेज़ — सब एक ही जगह ट्रैक करें। जानें कि आपकी बाइक को कब देखभाल की ज़रूरत है।';

  @override
  String get onboardingGetStarted => 'शुरू करें';

  @override
  String get onboardingAddMyBike => 'मेरी बाइक जोड़ें';

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
  String get addBikeInvalidFormat =>
      'गलत फ़ॉर्मेट। MH12DE1234 या DL01AA1234 जैसा फ़ॉर्मेट इस्तेमाल करें।';

  @override
  String get addBikeNotFound => 'रजिस्ट्री में वाहन नहीं मिला।';

  @override
  String get addBikeApiLimit =>
      'API सीमा पूरी हो गई। कृपया बाद में दोबारा कोशिश करें।';

  @override
  String get addBikeNoInternet =>
      'इंटरनेट कनेक्शन नहीं है। कृपया अपना नेटवर्क जांचें।';

  @override
  String get addBikeFetchFailed => 'वाहन की जानकारी नहीं मिल सकी।';

  @override
  String get addBikeTitle => 'अपनी बाइक जोड़ें';

  @override
  String get addBikeSubtitle =>
      'अपना रजिस्ट्रेशन नंबर डालें, हम आपके वाहन की जानकारी अपने-आप भर देंगे।';

  @override
  String get addBikeExamples => 'जैसे UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addBikeContinue => 'जारी रखें →';

  @override
  String get addBikeFetching => 'वाहन की जानकारी लाई जा रही है…';

  @override
  String get vehicleBrandRequired => 'ब्रांड ज़रूरी है';

  @override
  String get vehicleModelRequired => 'मॉडल ज़रूरी है';

  @override
  String get vehicleSaveFailed =>
      'बाइक सेव नहीं हो सकी। कृपया दोबारा कोशिश करें।';

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
  String get vehicleVariant => 'वेरिएंट';

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
  String get vehicleSaveBike => 'बाइक सेव करें';

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
  String get garageEmptyTitle => 'अभी कोई बाइक नहीं है';

  @override
  String get garageEmptyBody =>
      'फ्यूल, सर्विस और खर्च ट्रैक करने के लिए अपनी पहली बाइक जोड़ें।';

  @override
  String get garageYourBikes => 'आपकी बाइकें';

  @override
  String get garageAddAnother => 'एक और बाइक जोड़ें';

  @override
  String get garageStatBikes => 'बाइकें';

  @override
  String get garageStatAlerts => 'अलर्ट';

  @override
  String garageDeleteBike(String name) {
    return '$name हटाएं';
  }

  @override
  String garageDeleteBikeTitle(String name) {
    return '$name हटाएं?';
  }

  @override
  String get garageDeleteBikeBody =>
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
  String get noBikeSelected => 'पहले होम टैब से कोई बाइक चुनें।';

  @override
  String get offlineBanner => 'इंटरनेट नहीं है — ऑफ़लाइन काम कर रहे हैं';

  @override
  String notifDocBody(String title, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$title $days दिन में समाप्त हो रहा है',
      one: '$title कल समाप्त हो रहा है',
    );
    return '$_temp0';
  }

  @override
  String notifDocTitle(int days) {
    return 'दस्तावेज़ $days दिन में समाप्त हो रहा है';
  }

  @override
  String get notifDocTomorrowTitle => 'दस्तावेज़ कल समाप्त हो रहा है!';

  @override
  String notifServiceOverdueTitle(String bike) {
    return 'सर्विस का समय निकल गया — $bike';
  }

  @override
  String notifServiceOverdueBody(String service) {
    return '$service पर ध्यान देने की ज़रूरत है';
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
  String get addBikeHubSubtitle =>
      'अपना RC कार्ड स्कैन करें, या जानकारी खुद भरें।';

  @override
  String get addBikeScanTitle => 'RC कार्ड स्कैन करें';

  @override
  String get addBikeScanBody => 'अपने RC की फ़ोटो लें, हम जानकारी भर देंगे।';

  @override
  String get addBikeManualTitle => 'खुद दर्ज करें';

  @override
  String get addBikeManualBody => 'अपनी बाइक की जानकारी खुद लिखें।';

  @override
  String get addBikeLookupTitle => 'नंबर से खोजें';

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
  String get vehicleScanSuccess =>
      'आपके RC से जानकारी पढ़ ली गई। सेव करने से पहले सब कुछ जांच लें।';

  @override
  String get vehicleScanFailure =>
      'आपका RC साफ़ नहीं पढ़ा जा सका। कृपया नीचे जानकारी भरें।';

  @override
  String get vehicleSectionYourBike => 'आपकी बाइक';
}
