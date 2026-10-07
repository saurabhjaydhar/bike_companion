// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonOther => 'أخرى';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsSystemDefault => 'إعداد النظام';

  @override
  String get settingsLight => 'فاتح';

  @override
  String get settingsDark => 'داكن';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsBuiltWithFlutter => 'مبني باستخدام Flutter';

  @override
  String get settingsAccount => 'الحساب';

  @override
  String get settingsSignedIn => 'تم تسجيل الدخول';

  @override
  String get settingsSignOut => 'تسجيل الخروج';

  @override
  String get settingsSignOutTitle => 'تسجيل الخروج؟';

  @override
  String get settingsSignOutBody =>
      'تبقى بياناتك المحلية على هذا الجهاز. يمكنك تسجيل الدخول مجددًا في أي وقت.';

  @override
  String get settingsData => 'البيانات';

  @override
  String get settingsClearAllData => 'مسح كل البيانات';

  @override
  String get settingsClearTitle => 'مسح كل البيانات؟';

  @override
  String get settingsClearBody =>
      'سيؤدي هذا إلى حذف جميع المركبات وسجلات الوقود والصيانة والمصروفات والمستندات نهائيًا. لا يمكن التراجع عن ذلك.';

  @override
  String get settingsDataCleared => 'تم مسح كل البيانات';

  @override
  String get settingsDeleteAccount => 'حذف الحساب';

  @override
  String get settingsDeleteAccountSubtitle => 'يحذف حسابك نهائيًا (GDPR)';

  @override
  String get settingsDeleteAccountTitle => 'حذف الحساب؟';

  @override
  String get settingsDeleteAccountBody =>
      'سيؤدي هذا إلى حذف حسابك وكل ما تم نسخه احتياطيًا في السحابة نهائيًا — المركبات والسجلات وصور المستندات. تبقى البيانات على هذا الهاتف. لا يمكن التراجع عن ذلك.';

  @override
  String get settingsDeleteAccountError =>
      'تعذّر حذف الحساب. يُرجى تسجيل الدخول مجددًا والمحاولة مرة أخرى.';

  @override
  String get appTitle => 'Garajo';

  @override
  String get commonContinue => 'متابعة';

  @override
  String authSignInFailed(String error) {
    return 'فشل تسجيل الدخول: $error';
  }

  @override
  String get authOfflineTitle => 'المتابعة بدون حساب؟';

  @override
  String get authOfflineBody =>
      'سيتم حفظ بياناتك على هذا الجهاز فقط، ولن يتم نسخها احتياطيًا أو مزامنتها مع أجهزة أخرى.\n\nيمكنك تسجيل الدخول في أي وقت من الإعدادات.';

  @override
  String get authOfflineError =>
      'تعذّر بدء جلسة بدون اتصال. يُرجى المحاولة مرة أخرى.';

  @override
  String get authTagline =>
      'تتبّع الوقود والصيانة والمصروفات\nلدراجتك أو سكوترك أو سيارتك';

  @override
  String get authContinueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get authContinueWithoutAccount => 'المتابعة بدون حساب';

  @override
  String get authTerms => 'بالمتابعة، فإنك توافق على الشروط وسياسة الخصوصية.';

  @override
  String get onboardingWelcomeTitle => 'مرحبًا بك في Garajo';

  @override
  String get onboardingAddMyVehicle => 'إضافة مركبتي';

  @override
  String get fieldBrand => 'العلامة التجارية';

  @override
  String get fieldModel => 'الطراز';

  @override
  String get fieldModelHint => 'مثل Classic 350، Activa';

  @override
  String get fieldNickname => 'الاسم المستعار';

  @override
  String get fieldNicknameHint => 'ماذا تسمّيها؟';

  @override
  String get fieldColour => 'اللون';

  @override
  String get fieldSelectDate => 'اختر التاريخ';

  @override
  String get fieldCurrentOdometer => 'قراءة العدّاد الحالية (كم)';

  @override
  String get fieldInsuranceExpiry => 'انتهاء التأمين';

  @override
  String get fieldPucExpiry => 'انتهاء شهادة PUC';

  @override
  String get validationRequired => 'مطلوب';

  @override
  String get validationEnterNumber => 'أدخل رقمًا';

  @override
  String get addVehicleInvalidFormat =>
      'تنسيق غير صالح. استخدم تنسيقًا مثل MH12DE1234 أو DL01AA1234.';

  @override
  String get addVehicleNotFound => 'لم يتم العثور على المركبة في السجل.';

  @override
  String get addVehicleApiLimit =>
      'تم بلوغ حد استخدام API. يُرجى المحاولة لاحقًا.';

  @override
  String get addVehicleNoInternet =>
      'لا يوجد اتصال بالإنترنت. يُرجى التحقق من الشبكة.';

  @override
  String get addVehicleFetchFailed => 'تعذّر جلب تفاصيل المركبة.';

  @override
  String get addVehicleTitle => 'أضف مركبتك';

  @override
  String get addVehicleSubtitle =>
      'أدخل رقم التسجيل وسنجلب تفاصيل مركبتك تلقائيًا.';

  @override
  String get addVehicleExamples => 'مثل UK07AB1234 · DL01AA1234 · MH12DE1234';

  @override
  String get addVehicleContinue => 'متابعة ←';

  @override
  String get addVehicleFetching => 'جارٍ جلب تفاصيل المركبة…';

  @override
  String get vehicleBrandRequired => 'العلامة التجارية مطلوبة';

  @override
  String get vehicleModelRequired => 'الطراز مطلوب';

  @override
  String get vehicleSaveFailed => 'تعذّر حفظ المركبة. حاول مرة أخرى.';

  @override
  String get vehicleDetailsTitle => 'تفاصيل المركبة';

  @override
  String get vehicleSectionRegistration => 'التسجيل';

  @override
  String get vehicleRcNumber => 'رقم RC';

  @override
  String get vehicleSectionInfo => 'معلومات المركبة';

  @override
  String get vehicleManufacturer => 'الشركة المصنّعة';

  @override
  String get vehicleFuelType => 'نوع الوقود';

  @override
  String get vehicleClass => 'صنف المركبة';

  @override
  String get vehicleSectionRegistrationDetails => 'تفاصيل التسجيل';

  @override
  String get vehicleRegistrationDate => 'تاريخ التسجيل';

  @override
  String get vehicleSectionIdentifiers => 'أرقام التعريف';

  @override
  String get vehicleEngineNumber => 'رقم المحرك';

  @override
  String get vehicleChassisNumber => 'رقم الهيكل';

  @override
  String get vehicleSaveVehicle => 'حفظ المركبة';

  @override
  String get vehicleFetchSuccess => 'تم جلب تفاصيل المركبة. راجعها وأكّدها.';

  @override
  String get vehicleFetchFailure =>
      'تعذّر جلب تفاصيل المركبة. يُرجى إدخالها يدويًا أدناه.';

  @override
  String commonError(String error) {
    return 'خطأ: $error';
  }

  @override
  String get commonThisMonth => 'هذا الشهر';

  @override
  String get garageTitle => 'مرآبي';

  @override
  String get garageEmptyTitle => 'لا توجد مركبات بعد';

  @override
  String get garageEmptyBody =>
      'أضف أول دراجة أو سكوتر أو سيارة لبدء تتبّع الوقود والصيانة والمصروفات.';

  @override
  String get garageYourVehicles => 'مركباتك';

  @override
  String get garageAddAnother => 'إضافة مركبة أخرى';

  @override
  String get garageStatVehicles => 'مركبات';

  @override
  String get garageStatAlerts => 'تنبيهات';

  @override
  String garageDeleteVehicle(String name) {
    return 'حذف $name';
  }

  @override
  String garageDeleteVehicleTitle(String name) {
    return 'حذف $name؟';
  }

  @override
  String get garageDeleteVehicleBody =>
      'سيتم حذف جميع سجلات الوقود وسجلات الصيانة والمصروفات.';

  @override
  String get commonToday => 'اليوم';

  @override
  String get commonYesterday => 'أمس';

  @override
  String commonDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count يوم',
      many: 'منذ $count يومًا',
      few: 'منذ $count أيام',
      two: 'منذ يومين',
      one: 'منذ يوم واحد',
      zero: 'اليوم',
    );
    return '$_temp0';
  }

  @override
  String get commonNotSet => 'غير محدد';

  @override
  String get fieldOdometer => 'العدّاد';

  @override
  String get dashboardTitle => 'لوحة المعلومات';

  @override
  String get dashboardLogFuel => 'تسجيل تعبئة وقود';

  @override
  String get dashboardRecentActivity => 'النشاط الأخير';

  @override
  String get dashboardSeeAll => 'عرض الكل';

  @override
  String get dashboardThisMonth => 'هذا الشهر';

  @override
  String get dashboardLastFuel => 'آخر تعبئة';

  @override
  String get dashboardNotLogged => 'غير مسجّل';

  @override
  String dashboardAvgMileage(String mileage) {
    return 'متوسط $mileage كم/لتر';
  }

  @override
  String get dashboardNextService => 'الصيانة التالية';

  @override
  String get dashboardUpToDate => 'محدّثة';

  @override
  String dashboardDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متبقٍ $count يوم',
      many: 'متبقٍ $count يومًا',
      few: 'متبقٍ $count أيام',
      two: 'متبقٍ يومان',
      one: 'متبقٍ يوم واحد',
      zero: 'لم يتبقَّ أي يوم',
    );
    return '$_temp0';
  }

  @override
  String get dashboardFuelStop => 'تعبئة وقود';

  @override
  String fuelOdometerTooLow(int km) {
    return 'يجب أن تكون قراءة العدّاد أكبر من آخر إدخال ($km كم)';
  }

  @override
  String get fuelLogged => 'تم تسجيل تعبئة الوقود!';

  @override
  String get fuelCurrentOdometer => 'قراءة العدّاد الحالية';

  @override
  String fuelLastEntry(int km) {
    return 'آخر إدخال: $km كم';
  }

  @override
  String fuelKmSinceLastEstimate(int km, String litres) {
    return 'المسافة منذ آخر تعبئة: $km كم · التقدير ~$litres لتر';
  }

  @override
  String fuelKmSinceLast(int km) {
    return 'المسافة منذ آخر تعبئة: $km كم';
  }

  @override
  String get fuelAddMoreDetails => 'إضافة تفاصيل أخرى';

  @override
  String get fuelLitresFilled => 'اللترات المعبّأة';

  @override
  String get fuelAmountPaid => 'المبلغ المدفوع';

  @override
  String get fuelStationOptional => 'محطة الوقود (اختياري)';

  @override
  String get fuelStationHint => 'HP، Indian Oil، Bharat...';

  @override
  String get fuelSave => 'حفظ التعبئة';

  @override
  String get fuelHistoryTitle => 'سجل الوقود';

  @override
  String get fuelHistoryEmptyTitle => 'لا توجد سجلات وقود بعد';

  @override
  String get fuelHistoryEmptyBody => 'سجّل أول تعبئة وقود من لوحة المعلومات.';

  @override
  String get fuelAvgMileageAllTime => 'متوسط استهلاك الوقود (طوال الوقت)';

  @override
  String get fieldNotesOptional => 'ملاحظات (اختياري)';

  @override
  String get serviceStatusGood => 'جيدة';

  @override
  String get serviceDueSoon => 'مستحقة قريبًا';

  @override
  String get serviceStatusOverdue => 'متأخرة';

  @override
  String get serviceHistory => 'السجل';

  @override
  String serviceLast(String date) {
    return 'آخر مرة: $date';
  }

  @override
  String get serviceEmptyTitle => 'لا توجد صيانات مسجّلة';

  @override
  String get serviceEmptyBody =>
      'انقر على أي عنصر في \"مستحقة قريبًا\" لتسجيل صيانة.';

  @override
  String get serviceLogTitle => 'تسجيل صيانة';

  @override
  String get serviceType => 'نوع الصيانة';

  @override
  String get serviceOdometerKm => 'العدّاد (كم)';

  @override
  String get serviceCost => 'التكلفة (₹)';

  @override
  String get serviceNotesHint => 'اسم الورشة، القطع المستبدلة...';

  @override
  String get serviceSave => 'حفظ الصيانة';

  @override
  String get serviceOilChange => 'تغيير الزيت';

  @override
  String get serviceOilFilter => 'فلتر الزيت';

  @override
  String get serviceAirFilter => 'فلتر الهواء';

  @override
  String get serviceChainClean => 'تنظيف الجنزير';

  @override
  String get serviceChainLube => 'تشحيم الجنزير';

  @override
  String get serviceBrakePads => 'تيل الفرامل';

  @override
  String get serviceTyres => 'الإطارات';

  @override
  String get serviceBattery => 'البطارية';

  @override
  String get serviceCoolant => 'سائل التبريد';

  @override
  String get expenseFuel => 'الوقود';

  @override
  String get expenseService => 'الصيانة';

  @override
  String get expenseParts => 'قطع الغيار';

  @override
  String get expenseInsurance => 'التأمين';

  @override
  String get expenseParking => 'المواقف';

  @override
  String get expenseAccessories => 'الإكسسوارات';

  @override
  String get expenseFine => 'المخالفات';

  @override
  String get docRc => 'دفتر RC';

  @override
  String get docInsurance => 'التأمين';

  @override
  String get docDrivingLicence => 'رخصة القيادة';

  @override
  String get docPuc => 'شهادة PUC';

  @override
  String get docInvoice => 'فاتورة الشراء';

  @override
  String get docWarranty => 'بطاقة الضمان';

  @override
  String get gradeExcellent => 'حالة ممتازة';

  @override
  String get gradeGood => 'حالة جيدة';

  @override
  String get gradeFair => 'حالة مقبولة';

  @override
  String get gradePoor => 'تحتاج إلى عناية';

  @override
  String get gradeCritical => 'حرجة — أجرِ الصيانة الآن';

  @override
  String get expensesTitle => 'المصروفات';

  @override
  String get expensesExportCsv => 'تصدير CSV';

  @override
  String get expensesByCategory => 'حسب الفئة';

  @override
  String get expensesTransactions => 'المعاملات';

  @override
  String get expensesEmptyTitle => 'لا توجد مصروفات';

  @override
  String get expensesEmptyBody => 'انقر على + لإضافة أول مصروف لهذا الشهر.';

  @override
  String get expensesCsvHeader => 'التاريخ,الفئة,المبلغ (₹),ملاحظة';

  @override
  String expensesCsvSubject(String month) {
    return 'المصروفات — $month';
  }

  @override
  String get expensesTotalSpent => 'إجمالي الإنفاق';

  @override
  String expensesVsLastMonth(String percent) {
    return '$percent% مقارنةً بالشهر الماضي';
  }

  @override
  String get expensesAddTitle => 'إضافة مصروف';

  @override
  String get expensesCategory => 'الفئة';

  @override
  String get expensesAmount => 'المبلغ (₹)';

  @override
  String get expensesNoteOptional => 'ملاحظة (اختياري)';

  @override
  String get expensesNoteHint => 'التاجر، الوصف...';

  @override
  String get expensesSave => 'حفظ المصروف';

  @override
  String get documentsTitle => 'المستندات';

  @override
  String get documentsEmptyTitle => 'لا توجد مستندات';

  @override
  String get documentsEmptyBody => 'احفظ RC والتأمين وPUC وغيرها في مكان واحد.';

  @override
  String get documentsExpiringSoon => 'تنتهي قريبًا';

  @override
  String get documentsValid => 'سارية';

  @override
  String get documentsExpired => 'منتهية';

  @override
  String get documentsNoExpiry => 'بلا تاريخ انتهاء';

  @override
  String documentsExpiresInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تنتهي خلال $count يوم',
      many: 'تنتهي خلال $count يومًا',
      few: 'تنتهي خلال $count أيام',
      two: 'تنتهي خلال يومين',
      one: 'تنتهي خلال يوم واحد',
      zero: 'تنتهي اليوم',
    );
    return '$_temp0';
  }

  @override
  String get documentsDelete => 'حذف المستند';

  @override
  String get documentsExpiry => 'الانتهاء';

  @override
  String get documentsAddTitle => 'إضافة مستند';

  @override
  String get documentsType => 'نوع المستند';

  @override
  String get documentsTitleField => 'العنوان';

  @override
  String get documentsTitleHint => 'مثل دفتر RC، رقم الوثيقة...';

  @override
  String get documentsExpiryOptional => 'تاريخ الانتهاء (اختياري)';

  @override
  String get documentsPhotoSelected => 'تم اختيار صورة';

  @override
  String get documentsAttachPhoto => 'إرفاق صورة';

  @override
  String get documentsSave => 'حفظ المستند';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDocs => 'المستندات';

  @override
  String get noVehicleSelected => 'اختر مركبة من تبويب الرئيسية أولًا.';

  @override
  String get offlineBanner => 'لا يوجد إنترنت — العمل بدون اتصال';

  @override
  String notifServiceOverdueTitle(String vehicle) {
    return 'صيانة متأخرة — $vehicle';
  }

  @override
  String get healthOilNone => 'لا يوجد تغيير زيت مسجّل — سجّل أول صيانة';

  @override
  String healthOilGood(int km) {
    return 'تم تغيير الزيت قبل $km كم — كل شيء على ما يرام';
  }

  @override
  String get healthOilOverdue => 'تغيير الزيت متأخر!';

  @override
  String healthOilDue(int km) {
    return 'تغيير الزيت مستحق بعد ~$km كم';
  }

  @override
  String get healthChainNone => 'لا توجد صيانة جنزير مسجّلة';

  @override
  String healthChainGood(int km) {
    return 'تمت صيانة الجنزير قبل $km كم';
  }

  @override
  String healthChainDue(int km) {
    return 'صيانة الجنزير مستحقة بعد ~$km كم';
  }

  @override
  String get healthAirNone => 'لا توجد صيانة فلتر هواء مسجّلة';

  @override
  String healthAirGood(String km) {
    return 'تم تغيير فلتر الهواء قبل $km ألف كم';
  }

  @override
  String get healthAirDue => 'تغيير فلتر الهواء مستحق قريبًا';

  @override
  String get healthBrakesNone => 'لا توجد صيانة فرامل مسجّلة';

  @override
  String healthBrakesGood(String km) {
    return 'تم فحص الفرامل قبل $km ألف كم';
  }

  @override
  String get healthBrakesDue => 'يُنصح بفحص الفرامل';

  @override
  String get healthTyresNone => 'لا توجد صيانة إطارات مسجّلة';

  @override
  String healthTyresGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'تم استبدال الإطارات قبل $months شهر',
      many: 'تم استبدال الإطارات قبل $months شهرًا',
      few: 'تم استبدال الإطارات قبل $months أشهر',
      two: 'تم استبدال الإطارات قبل شهرين',
      one: 'تم استبدال الإطارات قبل شهر واحد',
      zero: 'تم استبدال الإطارات هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get healthTyresDue => 'يُنصح بفحص الإطارات';

  @override
  String get healthBatteryNone => 'لا توجد صيانة بطارية مسجّلة';

  @override
  String healthBatteryGood(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'تم استبدال البطارية قبل $months شهر',
      many: 'تم استبدال البطارية قبل $months شهرًا',
      few: 'تم استبدال البطارية قبل $months أشهر',
      two: 'تم استبدال البطارية قبل شهرين',
      one: 'تم استبدال البطارية قبل شهر واحد',
      zero: 'تم استبدال البطارية هذا الشهر',
    );
    return '$_temp0';
  }

  @override
  String get healthBatteryDue => 'يُنصح بفحص البطارية';

  @override
  String get healthInsuranceNotSet => 'لم يتم تحديد تاريخ انتهاء التأمين';

  @override
  String get healthInsuranceExpired => 'انتهى التأمين — جدّده فورًا';

  @override
  String healthInsuranceExpiring(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ينتهي التأمين خلال $days يوم — جدّده الآن',
      many: 'ينتهي التأمين خلال $days يومًا — جدّده الآن',
      few: 'ينتهي التأمين خلال $days أيام — جدّده الآن',
      two: 'ينتهي التأمين خلال يومين — جدّده الآن',
      one: 'ينتهي التأمين خلال يوم واحد — جدّده الآن',
      zero: 'ينتهي التأمين اليوم — جدّده الآن',
    );
    return '$_temp0';
  }

  @override
  String healthInsuranceValid(int days) {
    return 'التأمين ساري — الأيام المتبقية: $days';
  }

  @override
  String get healthEconomyNeedMore =>
      'سجّل المزيد من التعبئات لتتبّع استهلاك الوقود';

  @override
  String healthEconomyAverage(String mileage) {
    return 'المتوسط: $mileage كم/لتر';
  }

  @override
  String healthEconomyStable(String mileage) {
    return 'استهلاك الوقود مستقر عند $mileage كم/لتر';
  }

  @override
  String get healthEconomyDropping =>
      'كفاءة الوقود في انخفاض — قد تحتاج إلى صيانة';

  @override
  String get healthEconomyDeclining => 'كفاءة الوقود تنخفض قليلًا — راقبها';

  @override
  String get addVehicleHubSubtitle =>
      'امسح بطاقة RC ضوئيًا أو أدخل البيانات بنفسك.';

  @override
  String get addVehicleScanTitle => 'مسح بطاقة RC';

  @override
  String get addVehicleScanBody => 'التقط صورة لبطاقة RC وسنملأ البيانات.';

  @override
  String get addVehicleManualTitle => 'إدخال يدوي';

  @override
  String get addVehicleManualBody => 'أدخل تفاصيل مركبتك بنفسك.';

  @override
  String get addVehicleLookupTitle => 'البحث برقم اللوحة';

  @override
  String get scanTakePhoto => 'التقاط صورة';

  @override
  String get scanChooseGallery => 'اختيار من المعرض';

  @override
  String get scanUseGemini => 'القراءة باستخدام Gemini AI';

  @override
  String get scanUseGeminiBody =>
      'أكثر دقة. تُرسل صورة بطاقة RC إلى Google لقراءة بيانات المركبة. عند الإيقاف، تُقرأ الصورة على هاتفك فقط.';

  @override
  String get scanReading => 'جارٍ قراءة بطاقة RC…';

  @override
  String get scanTitle => 'امسح بطاقة RC';

  @override
  String get scanSubtitle =>
      'أضف صورًا لوجهي بطاقة RC، فلكل وجه بيانات مختلفة. لدفتر RC أو بطاقة RC رقمية تكفي صورة واحدة.';

  @override
  String get scanFront => 'الوجه الأمامي';

  @override
  String get scanFrontHint => 'رقم التسجيل ورقم الشاسيه ورقم المحرك';

  @override
  String get scanBack => 'الوجه الخلفي';

  @override
  String get scanBackHint => 'الشركة المصنّعة والطراز وفئة المركبة';

  @override
  String get scanAddPhoto => 'انقر لإضافة صورة';

  @override
  String get scanRemovePhoto => 'إزالة الصورة';

  @override
  String get scanReadDetails => 'قراءة البيانات';

  @override
  String get scanPickerError =>
      'تعذّر فتح الكاميرا أو المعرض. تحقّق من أذونات التطبيق في الإعدادات.';

  @override
  String get vehicleScanSuccess =>
      'تمت قراءة البيانات من بطاقة RC. راجع كل شيء قبل الحفظ.';

  @override
  String get vehicleScanFailure =>
      'تعذّرت قراءة بطاقة RC بوضوح. يُرجى إدخال البيانات أدناه.';

  @override
  String get vehicleSectionYourVehicle => 'مركبتك';

  @override
  String get vahanSmsButton => 'التحقق عبر VAHAN برسالة SMS';

  @override
  String get vahanSmsHint =>
      'يرسل رقم اللوحة إلى خدمة VAHAN الرسمية عبر SMS. يصل الرد إلى رسائلك — انسخ البيانات إلى هذا النموذج.';

  @override
  String get vahanSmsError => 'تعذّر فتح تطبيق الرسائل.';

  @override
  String get vehicleRegValidity => 'التسجيل صالح حتى';

  @override
  String get dueRegistration => 'التسجيل';

  @override
  String notifExpiryTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'تنتهي صلاحية $item خلال $days يومًا',
      one: 'تنتهي صلاحية $item غدًا',
    );
    return '$_temp0';
  }

  @override
  String notifServiceDueTitle(String item, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'موعد $item خلال $days يومًا',
      one: 'موعد $item غدًا',
    );
    return '$_temp0';
  }

  @override
  String notifDueBody(String vehicle, String date) {
    return '$vehicle · $date. اضغط للتحديث.';
  }

  @override
  String get comingUpTitle => 'القادم';

  @override
  String get comingUpEmpty => 'كل شيء على ما يرام — لا شيء مستحق قريبًا.';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'خلال $days يومًا',
      one: 'غدًا',
      zero: 'اليوم',
    );
    return '$_temp0';
  }

  @override
  String dueOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'متأخر $days يومًا',
      one: 'متأخر يومًا واحدًا',
    );
    return '$_temp0';
  }

  @override
  String get dueAddDate => 'إضافة تاريخ';

  @override
  String get dueServiceSoon => 'قريبًا';

  @override
  String get dueServiceOverdue => 'متأخر';

  @override
  String dueValidUntil(String item) {
    return '$item صالح حتى';
  }

  @override
  String get dueUpdated => 'تم حفظ التاريخ — تم تحديث التذكيرات';

  @override
  String get remindersTurnOn => 'تشغيل';

  @override
  String get remindersOffBody =>
      'التذكيرات متوقفة. شغّلها لتعرف مسبقًا بمواعيد التأمين وشهادة PUC والصيانة.';

  @override
  String get remindersMutedNote => 'التذكيرات متوقفة لهذه المركبة.';

  @override
  String get remindersPermissionTitle => 'هل تريد تلقي التذكيرات؟';

  @override
  String get remindersPermissionBody =>
      'سنذكّرك قبل 30 و7 ويوم واحد من انتهاء التأمين وشهادة PUC والمستندات — في التاسعة صباحًا، وليس ليلًا أبدًا.';

  @override
  String get remindersNotNow => 'ليس الآن';

  @override
  String get remindersEnableInSettings =>
      'الإشعارات محظورة. شغّلها لهذا التطبيق من إعدادات الهاتف.';

  @override
  String get settingsReminders => 'التذكيرات';

  @override
  String settingsRemindersNext(String item, String date) {
    return 'التالي: $item · $date';
  }

  @override
  String get settingsRemindersNone => 'لا شيء مستحق قريبًا';

  @override
  String get expensesModeMonth => 'شهر';

  @override
  String get expensesModeYear => 'سنة';

  @override
  String expensesVsLastYear(String percent) {
    return '$percent% مقارنة بالعام الماضي';
  }

  @override
  String get expensesAvgMonthly => 'المتوسط / شهر';

  @override
  String get expensesCostPerKm => 'التكلفة / كم';

  @override
  String get expensesFuelPerKm => 'الوقود / كم';

  @override
  String get expensesNeedOdometer =>
      'سجّل التعبئة أو الصيانة مع قراءة العداد لرؤية التكلفة لكل كم.';

  @override
  String get expensesFromFuelLog => 'تعبئة وقود';

  @override
  String get expensesFromService => 'صيانة';

  @override
  String get expensesDeleted => 'تم حذف المصروف';

  @override
  String get commonUndo => 'تراجع';

  @override
  String get budgetTitle => 'الميزانية';

  @override
  String budgetOf(String spent, String budget) {
    return '$spent من $budget';
  }

  @override
  String budgetLeft(String amount) {
    return 'متبقٍ $amount';
  }

  @override
  String budgetLeftOf(String left, String budget) {
    return 'متبقٍ $left من $budget';
  }

  @override
  String budgetOver(String amount) {
    return 'تجاوز الميزانية بمقدار $amount';
  }

  @override
  String get budgetSet => 'تحديد الميزانية';

  @override
  String get budgetSetPrompt => 'حدّد ميزانية لتبقى نفقاتك تحت السيطرة.';

  @override
  String get budgetSheetTitle => 'ميزانية الإنفاق';

  @override
  String get budgetMonthly => 'الميزانية الشهرية';

  @override
  String get budgetYearly => 'الميزانية السنوية';

  @override
  String budgetSuggested(String amount) {
    return 'مقترح بناءً على الأشهر الأخيرة: $amount';
  }

  @override
  String get budgetSave => 'حفظ الميزانية';

  @override
  String get budgetRemove => 'إزالة الميزانية';

  @override
  String budgetAlertTitle(String vehicle) {
    return 'تنبيه الميزانية — $vehicle';
  }

  @override
  String budgetAlertMonth(int percent) {
    return 'لقد استخدمت $percent% من ميزانية هذا الشهر.';
  }

  @override
  String budgetAlertYear(int percent) {
    return 'لقد استخدمت $percent% من ميزانية هذا العام.';
  }

  @override
  String get garageSpending => 'الإنفاق';

  @override
  String get garageThisYear => 'هذا العام';

  @override
  String get vehicleTypeTitle => 'نوع المركبة';

  @override
  String get vehicleTypeDetected =>
      'تم التعرّف عليه من بطاقة RC — غيّره إن كان خاطئًا.';

  @override
  String get vehicleTypeBike => 'دراجة نارية';

  @override
  String get vehicleTypeScooter => 'سكوتر';

  @override
  String get vehicleTypeCar => 'سيارة';

  @override
  String get serviceWheelAlignment => 'ضبط الزوايا';

  @override
  String get serviceAcService => 'صيانة المكيّف';

  @override
  String get serviceWipers => 'المسّاحات';

  @override
  String get onboardingSlideTrackTitle => 'تتبّع كل روبية';

  @override
  String get onboardingSlideTrackBody =>
      'الوقود والصيانة والمصروفات في مكان واحد، مع ميزانيات وتكلفة لكل كم لكل مركبة.';

  @override
  String get onboardingSlideRemindTitle => 'لا تفوّت أي موعد';

  @override
  String get onboardingSlideRemindBody =>
      'تذكيرات قبل مواعيد التأمين وشهادة PUC والصيانة — في التاسعة صباحًا، وليس ليلًا أبدًا.';

  @override
  String get onboardingSlideScanTitle => 'امسح ولا تكتب';

  @override
  String get onboardingSlideScanBody => 'صوّر بطاقة RC وسنملأ تفاصيل مركبتك.';

  @override
  String fuelLitresFromPrice(String litres, String price) {
    return '≈ $litres لتر بسعر ₹$price/لتر (آخر تعبئة)';
  }

  @override
  String get logButton => 'تسجيل';

  @override
  String get logSheetTitle => 'ماذا تريد أن تسجّل؟';

  @override
  String get logFuelSub => 'اللترات والتكلفة والاستهلاك';

  @override
  String get logExpenseSub => 'قطع غيار، تأمين، مواقف، رسوم طرق';

  @override
  String get logServiceSub => 'تغيير الزيت، السلسلة، الإطارات';

  @override
  String get logOdometerTitle => 'تحديث عداد المسافة';

  @override
  String get logOdometerSub => 'حافظ على تحديث الكيلومترات';

  @override
  String get logDocumentSub => 'الاستمارة، التأمين، فحص الانبعاثات';

  @override
  String get odometerSave => 'حفظ القراءة';

  @override
  String get odometerUpdated => 'تم تحديث العداد';

  @override
  String get odometerInvalid => 'أدخل القراءة بالكيلومتر';
}
