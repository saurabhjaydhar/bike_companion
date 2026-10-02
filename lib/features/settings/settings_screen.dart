import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';

// ---------------------------------------------------------------------------
// Theme mode provider — persisted to SharedPreferences
// ---------------------------------------------------------------------------
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  // Dark ("Night Ride") is the default look until the user picks another.
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode') ?? 'dark';
    state = _fromString(saved);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _toString(mode));
  }

  ThemeMode _fromString(String s) {
    switch (s) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }

  String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light: return 'light';
      case ThemeMode.dark: return 'dark';
      case ThemeMode.system: return 'system';
    }
  }
}

// ---------------------------------------------------------------------------
// App language — null follows the device locale. Persisted to SharedPreferences
// ---------------------------------------------------------------------------
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(SharedPrefKeys.locale);
    state = saved == null ? null : Locale(saved);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(SharedPrefKeys.locale);
    } else {
      await prefs.setString(SharedPrefKeys.locale, locale.languageCode);
    }
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // Language names are shown in their own script on purpose.
  static const _languages = [
    ('en', 'English'),
    ('hi', 'हिन्दी'),
    ('es', 'Español'),
    ('fr', 'Français'),
    ('de', 'Deutsch'),
    ('it', 'Italiano'),
    ('pt', 'Português'),
    ('ar', 'العربية'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final currentMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Appearance section
          _SectionLabel(l.settingsAppearance, textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                _ThemeOption(
                  icon: Icons.brightness_auto_rounded,
                  label: l.settingsSystemDefault,
                  selected: currentMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.system),
                  textPrimary: textPrimary,
                  divider: true,
                ),
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  label: l.settingsLight,
                  selected: currentMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.light),
                  textPrimary: textPrimary,
                  divider: true,
                ),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  label: l.settingsDark,
                  selected: currentMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.dark),
                  textPrimary: textPrimary,
                  divider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Language section
          _SectionLabel(l.settingsLanguage, textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                _ThemeOption(
                  icon: Icons.language_rounded,
                  label: l.settingsSystemDefault,
                  selected: currentLocale == null,
                  onTap: () =>
                      ref.read(localeProvider.notifier).setLocale(null),
                  textPrimary: textPrimary,
                  divider: true,
                ),
                for (final (i, (code, name)) in _languages.indexed)
                  _ThemeOption(
                    icon: Icons.translate_rounded,
                    label: name,
                    selected: currentLocale?.languageCode == code,
                    onTap: () => ref
                        .read(localeProvider.notifier)
                        .setLocale(Locale(code)),
                    textPrimary: textPrimary,
                    divider: i < _languages.length - 1,
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // About section
          _SectionLabel(l.settingsAbout, textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(l.settingsVersion,
                      style: AppTextStyles.body.copyWith(color: textPrimary)),
                  trailing: Text('1.0.0',
                      style:
                          AppTextStyles.body.copyWith(color: textSecondary)),
                ),
                Divider(height: 1, color: border),
                ListTile(
                  title: Text(l.settingsBuiltWithFlutter,
                      style: AppTextStyles.body.copyWith(color: textPrimary)),
                  trailing: const Icon(Icons.favorite_rounded,
                      color: AppColors.danger, size: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Account section
          _SectionLabel(l.settingsAccount, textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                _AccountTile(textPrimary: textPrimary, textSecondary: textSecondary),
                Divider(height: 1, color: border),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
                  title: Text(
                    l.settingsSignOut,
                    style: AppTextStyles.body.copyWith(color: AppColors.danger),
                  ),
                  onTap: () => _confirmSignOut(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Danger zone
          _SectionLabel(l.settingsData, textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded,
                      color: AppColors.danger),
                  title: Text(l.settingsClearAllData,
                      style: AppTextStyles.body.copyWith(color: AppColors.danger)),
                  onTap: () => _confirmClear(context),
                ),
                Divider(height: 1, color: border),
                ListTile(
                  leading: const Icon(Icons.no_accounts_rounded,
                      color: AppColors.danger),
                  title: Text(l.settingsDeleteAccount,
                      style: AppTextStyles.body.copyWith(color: AppColors.danger)),
                  subtitle: Text(l.settingsDeleteAccountSubtitle,
                      style: AppTextStyles.label.copyWith(color: textSecondary)),
                  onTap: () => _confirmDeleteAccount(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    final l = context.l10n;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.settingsSignOutTitle),
        content: Text(l.settingsSignOutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await getIt<AuthService>().signOut();
              // Router auth stream fires → redirects to /auth automatically.
            },
            child: Text(l.settingsSignOut,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    final l = context.l10n;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.settingsDeleteAccountTitle),
        content: Text(l.settingsDeleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await getIt<AuthService>().deleteAccount();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.settingsDeleteAccountError),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              }
            },
            child: Text(l.settingsDeleteAccount,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    final l = context.l10n;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.settingsClearTitle),
        content: Text(l.settingsClearBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l.settingsDataCleared),
                    backgroundColor: AppColors.danger),
              );
            },
            child: Text(l.commonDelete,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final Color textPrimary;
  final Color textSecondary;
  const _AccountTile({required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthService>().currentUser;
    final name = user?.displayName ?? context.l10n.settingsSignedIn;
    final email = user?.email ?? '';
    final photoUrl = user?.photoURL;

    return ListTile(
      leading: photoUrl != null
          ? CircleAvatar(backgroundImage: NetworkImage(photoUrl), radius: 20)
          : CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 20,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
      title: Text(name, style: AppTextStyles.body.copyWith(color: textPrimary)),
      subtitle: email.isNotEmpty
          ? Text(email, style: AppTextStyles.label.copyWith(color: textSecondary))
          : null,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm, start: 4),
      child: Text(text.toUpperCase(),
          style: AppTextStyles.label.copyWith(color: color, fontSize: 11)),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color textPrimary;
  final bool divider;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.textPrimary,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.border;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon,
              color: selected ? AppColors.primary : textPrimary),
          title: Text(label,
              style: AppTextStyles.body.copyWith(
                  color: selected ? AppColors.primary : textPrimary)),
          trailing: selected
              ? const Icon(Icons.check_rounded, color: AppColors.primary)
              : null,
          onTap: onTap,
        ),
        if (divider) Divider(height: 1, color: border),
      ],
    );
  }
}
