import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../main.dart';

// ---------------------------------------------------------------------------
// Theme mode provider — persisted to SharedPreferences
// ---------------------------------------------------------------------------
final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode') ?? 'system';
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
// Screen
// ---------------------------------------------------------------------------
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final currentMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Appearance section
          _SectionLabel('Appearance', textSecondary),
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
                  label: 'System default',
                  selected: currentMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.system),
                  textPrimary: textPrimary,
                  divider: true,
                ),
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  label: 'Light',
                  selected: currentMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.light),
                  textPrimary: textPrimary,
                  divider: true,
                ),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark',
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

          // About section
          _SectionLabel('About', textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Version',
                      style: AppTextStyles.body.copyWith(color: textPrimary)),
                  trailing: Text('1.0.0',
                      style:
                          AppTextStyles.body.copyWith(color: textSecondary)),
                ),
                Divider(height: 1, color: border),
                ListTile(
                  title: Text('Built with Flutter',
                      style: AppTextStyles.body.copyWith(color: textPrimary)),
                  trailing: const Icon(Icons.favorite_rounded,
                      color: AppColors.danger, size: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Account section
          _SectionLabel('Account', textSecondary),
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
                    'Sign out',
                    style: AppTextStyles.body.copyWith(color: AppColors.danger),
                  ),
                  onTap: () => _confirmSignOut(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Danger zone
          _SectionLabel('Data', textSecondary),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: border),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_rounded,
                  color: AppColors.danger),
              title: Text('Clear all data',
                  style:
                      AppTextStyles.body.copyWith(color: AppColors.danger)),
              onTap: () => _confirmClear(context),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Your local data stays on this device. Sign back in anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await getIt<AuthService>().signOut();
              // Router auth stream fires → redirects to /auth automatically.
            },
            child: const Text('Sign out', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
            'This will permanently delete all bikes, fuel logs, service records, expenses, and documents. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('All data cleared'),
                    backgroundColor: AppColors.danger),
              );
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
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
    final name = user?.displayName ?? 'Signed in';
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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: 4),
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
