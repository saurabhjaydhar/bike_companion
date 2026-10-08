import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../core/services/auth_service.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/app_snack.dart';

/// First-run welcome: three swipeable cards on what the app does, and one
/// button to add the first vehicle (scan RC, look up by number, or enter
/// manually — see AddVehicleScreen).
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pages = PageController();
  int _page = 0;
  bool _starting = false;

  /// Starts straight away as a guest; the garage can be backed up to
  /// Google later from the dashboard or Settings.
  Future<void> _getStarted() async {
    final auth = getIt<AuthService>();
    if (auth.currentUser == null) {
      setState(() => _starting = true);
      try {
        await auth.signInAnonymously();
      } catch (_) {
        if (mounted) {
          setState(() => _starting = false);
          showAppSnack(context, context.l10n.authOfflineError,
              tone: SnackTone.error);
        }
        return;
      }
      if (!mounted) return;
      setState(() => _starting = false);
    }
    context.push('/onboarding/add-vehicle');
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final slides = [
      (Icons.insights_rounded, l.onboardingSlideTrackTitle,
          l.onboardingSlideTrackBody),
      (Icons.notifications_active_rounded, l.onboardingSlideRemindTitle,
          l.onboardingSlideRemindBody),
      (Icons.document_scanner_rounded, l.onboardingSlideScanTitle,
          l.onboardingSlideScanBody),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                l.onboardingWelcomeTitle,
                style: AppTextStyles.heading1.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    for (final (icon, title, body) in slides)
                      _Slide(icon: icon, title: title, body: body),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < slides.length; i++)
                    AnimatedContainer(
                      duration: AppDuration.fast,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _page ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.border),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l.onboardingAddMyVehicle,
                icon: Icons.add_rounded,
                isLoading: _starting,
                onPressed: _getStarted,
              ),
              if (getIt<AuthService>().currentUser == null)
                TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(l.onboardingHaveAccount),
                )
              else
                const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Slide({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 136,
          height: 136,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColors.primary.withValues(alpha: 0.28),
              AppColors.primary.withValues(alpha: 0.02),
            ]),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
                blurRadius: 40,
                spreadRadius: -4,
              ),
            ],
          ),
          child: Icon(icon, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(title,
            style: AppTextStyles.heading2.copyWith(color: textPrimary),
            textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.md),
        Text(body,
            style: AppTextStyles.body.copyWith(color: textSecondary),
            textAlign: TextAlign.center),
      ],
    );
  }
}
