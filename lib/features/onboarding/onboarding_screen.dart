import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/primary_button.dart';

/// First-run welcome. Adding the vehicle itself happens in [AddVehicleScreen]
/// (scan RC, look up by number, or enter manually).
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _WelcomePage(
          onStart: () => context.push('/onboarding/add-vehicle'),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Welcome
// ---------------------------------------------------------------------------
class _WelcomePage extends StatelessWidget {
  final VoidCallback onStart;
  const _WelcomePage({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 120,
            height: 120,
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
            child: const Icon(
              Icons.two_wheeler_rounded,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            context.l10n.onboardingWelcomeTitle,
            style: AppTextStyles.display.copyWith(color: textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.l10n.onboardingWelcomeBody,
            style: AppTextStyles.body.copyWith(color: textSecondary),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          PrimaryButton(label: context.l10n.onboardingGetStarted, onPressed: onStart),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
