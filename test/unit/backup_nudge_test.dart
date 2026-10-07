import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/shared/widgets/backup_prompt.dart';

void main() {
  final now = DateTime(2026, 10, 7);

  test('signed-in riders never see the nudge', () {
    expect(shouldShowBackupNudge(isGuest: false, now: now), isFalse);
  });

  test('guests see it until they dismiss it', () {
    expect(shouldShowBackupNudge(isGuest: true, now: now), isTrue);
  });

  test('a dismissed nudge comes back after a week', () {
    bool show(int daysAgo) => shouldShowBackupNudge(
          isGuest: true,
          dismissedAt: now.subtract(Duration(days: daysAgo)),
          now: now,
        );
    expect(show(1), isFalse);
    expect(show(6), isFalse);
    expect(show(backupNudgeSnoozeDays), isTrue);
  });
}
