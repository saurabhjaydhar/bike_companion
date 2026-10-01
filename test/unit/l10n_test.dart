import 'dart:convert';
import 'dart:io';

import 'package:bike_companion/core/constants/app_constants.dart';
import 'package:bike_companion/core/services/health_score_service.dart';
import 'package:bike_companion/data/models/bike.dart';
import 'package:bike_companion/data/models/health_score.dart';
import 'package:bike_companion/data/models/service_record.dart';
import 'package:bike_companion/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _arb(String locale) =>
    jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
        as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final hi = lookupAppLocalizations(const Locale('hi'));

  group('ARB files', () {
    test('Hindi has a translation for every English string', () {
      final enKeys = _messageKeys(_arb('en'));
      final hiKeys = _messageKeys(_arb('hi'));
      expect(enKeys.difference(hiKeys), isEmpty, reason: 'missing in hi');
      expect(hiKeys.difference(enKeys), isEmpty, reason: 'unknown in hi');
    });

    test('supported locales are English and Hindi', () {
      expect(
        AppLocalizations.supportedLocales.map((l) => l.languageCode),
        containsAll(['en', 'hi']),
      );
    });
  });

  group('labels', () {
    test('service, expense and document types are translated', () {
      expect(en.serviceTypeLabel(ServiceTypes.oilChange), 'Oil Change');
      expect(hi.serviceTypeLabel(ServiceTypes.oilChange), 'ऑयल बदलना');
      expect(hi.expenseCategoryLabel(ExpenseCategories.fuel), 'फ्यूल');
      expect(hi.documentTypeLabel(DocumentTypes.drivingLicence),
          'ड्राइविंग लाइसेंस');
      expect(hi.serviceTypeLabel('unknown'), hi.commonOther);
    });

    test('health grades are translated', () {
      expect(en.healthGradeLabel(HealthGrade.excellent), 'Excellent condition');
      expect(hi.healthGradeLabel(HealthGrade.critical),
          'गंभीर — अभी सर्विस कराएं');
    });

    test('plurals and placeholders', () {
      expect(en.commonDaysAgo(1), '1 day ago');
      expect(en.commonDaysAgo(5), '5 days ago');
      expect(hi.commonDaysAgo(5), '5 दिन पहले');
      expect(hi.garageDeleteBike('Bullet'), 'Bullet हटाएं');
    });
  });

  group('health score messages', () {
    final bike = Bike(
      id: 'b1',
      name: 'Test Bike',
      brand: 'Honda',
      model: 'Shine',
      colourHex: '#1A56DB',
      regNumber: 'MH01AB1234',
      odometerCurrent: 10000,
      odometerOfficial: 10000,
      createdAt: DateTime(2024, 1, 1),
    );

    test('render in the requested language', () {
      final score = HealthScoreService().compute(
        bike: bike,
        services: [
          ServiceRecord(
            id: 's1',
            bikeId: 'b1',
            date: DateTime.now(),
            serviceType: ServiceTypes.oilChange,
            odometer: 9000,
          ),
        ],
        fuelLogs: [],
      );
      final oil = score.factors.firstWhere((f) => f.label == 'Engine Oil');

      expect(oil.message, 'Oil changed 1000 km ago — all good');
      expect(oil.localizedMessage(en), oil.message);
      expect(oil.localizedMessage(hi),
          '1000 km पहले ऑयल बदला गया — सब ठीक है');
    });
  });

  testWidgets('Hindi locale renders app and Material strings', (tester) async {
    late AppLocalizations l;
    late MaterialLocalizations material;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('hi'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(builder: (context) {
        l = context.l10n;
        material = MaterialLocalizations.of(context);
        return Text(l.garageTitle);
      }),
    ));

    expect(find.text('मेरा गैराज'), findsOneWidget);
    expect(l.localeName, 'hi');
    expect(material.cancelButtonLabel, isNot('Cancel'));
  });
}
