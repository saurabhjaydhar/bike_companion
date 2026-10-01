import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/active_bike_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/bike.dart';
import '../../data/repositories/bike_repository.dart';
import '../../features/garage/garage_provider.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';

const _uuid = Uuid();

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Form data
  String _brand = kIndianBrands.first;
  final _modelCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _colourHex = '#1A56DB';
  final _regCtrl = TextEditingController();
  DateTime? _purchaseDate;
  final _odometerCtrl = TextEditingController(text: '0');
  DateTime? _insuranceExpiry;
  DateTime? _pucExpiry;

  final _step2Key = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _modelCtrl.dispose();
    _nameCtrl.dispose();
    _regCtrl.dispose();
    _odometerCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == 1 && !(_step2Key.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppDuration.slow,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      final bike = Bike(
        id: _uuid.v4(),
        name: _nameCtrl.text.trim(),
        brand: _brand,
        model: _modelCtrl.text.trim(),
        colourHex: _colourHex,
        regNumber: _regCtrl.text.trim().toUpperCase(),
        purchaseDate: _purchaseDate,
        odometerCurrent: int.tryParse(_odometerCtrl.text) ?? 0,
        odometerOfficial: int.tryParse(_odometerCtrl.text) ?? 0,
        insuranceExpiry: _insuranceExpiry,
        pucExpiry: _pucExpiry,
        createdAt: DateTime.now(),
      );

      await getIt<BikeRepository>().insertBike(bike);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SharedPrefKeys.isOnboardingDone, true);

      ref.invalidate(garageProvider);
      await setActiveBike(ref, bike.id);

      if (mounted) context.go('/garage');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
              child: Row(
                children: List.generate(3, (i) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: AppDuration.normal,
                      height: 3,
                      margin: EdgeInsets.only(right: i < 2 ? AppSpacing.xs : 0),
                      decoration: BoxDecoration(
                        color: i <= _currentPage
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.border),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _WelcomePage(onStart: _next),
                  _AddBikePage(
                    formKey: _step2Key,
                    brand: _brand,
                    modelCtrl: _modelCtrl,
                    nameCtrl: _nameCtrl,
                    colourHex: _colourHex,
                    regCtrl: _regCtrl,
                    purchaseDate: _purchaseDate,
                    odometerCtrl: _odometerCtrl,
                    onBrandChanged: (v) => setState(() => _brand = v),
                    onColourChanged: (v) => setState(() => _colourHex = v),
                    onPurchaseDateChanged: (v) =>
                        setState(() => _purchaseDate = v),
                    onNext: _next,
                  ),
                  _KeyDatesPage(
                    insuranceExpiry: _insuranceExpiry,
                    pucExpiry: _pucExpiry,
                    onInsuranceChanged: (v) =>
                        setState(() => _insuranceExpiry = v),
                    onPucChanged: (v) => setState(() => _pucExpiry = v),
                    onFinish: _finish,
                    saving: _saving,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 1 — Welcome
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
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
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

// ---------------------------------------------------------------------------
// Page 2 — Add your bike
// ---------------------------------------------------------------------------
class _AddBikePage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String brand;
  final TextEditingController modelCtrl;
  final TextEditingController nameCtrl;
  final String colourHex;
  final TextEditingController regCtrl;
  final DateTime? purchaseDate;
  final TextEditingController odometerCtrl;
  final ValueChanged<String> onBrandChanged;
  final ValueChanged<String> onColourChanged;
  final ValueChanged<DateTime?> onPurchaseDateChanged;
  final VoidCallback onNext;

  const _AddBikePage({
    required this.formKey,
    required this.brand,
    required this.modelCtrl,
    required this.nameCtrl,
    required this.colourHex,
    required this.regCtrl,
    required this.purchaseDate,
    required this.odometerCtrl,
    required this.onBrandChanged,
    required this.onColourChanged,
    required this.onPurchaseDateChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Text(l.onboardingAboutBikeTitle,
                style: AppTextStyles.heading1),
            const SizedBox(height: AppSpacing.xxl),

            // Brand picker
            Text(l.fieldBrand, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: brand,
              decoration: const InputDecoration(),
              items: kIndianBrands
                  .map((b) => DropdownMenuItem(
                      value: b, child: Text(b == 'Other' ? l.commonOther : b)))
                  .toList(),
              onChanged: (v) => onBrandChanged(v!),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Model
            Text(l.fieldModel, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: modelCtrl,
              decoration:
                  InputDecoration(hintText: l.fieldModelHint),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l.validationRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Nickname
            Text(l.fieldNickname, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: nameCtrl,
              decoration: InputDecoration(hintText: l.fieldNicknameHint),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l.validationRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Colour picker
            Text(l.fieldColour, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            _ColourPicker(
              selected: colourHex,
              onChanged: onColourChanged,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Registration
            Text(l.fieldRegNumber, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: regCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(hintText: 'MH 12 AB 1234'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l.validationRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Purchase date
            Text(l.fieldPurchaseDateOptional, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            _DateField(
              value: purchaseDate,
              hint: l.fieldSelectDate,
              onChanged: onPurchaseDateChanged,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Odometer
            Text(l.fieldCurrentOdometer, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: odometerCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '0'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.validationRequired;
                if (int.tryParse(v) == null) return l.validationEnterNumber;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(label: l.commonNext, onPressed: onNext),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page 3 — Key dates
// ---------------------------------------------------------------------------
class _KeyDatesPage extends StatelessWidget {
  final DateTime? insuranceExpiry;
  final DateTime? pucExpiry;
  final ValueChanged<DateTime?> onInsuranceChanged;
  final ValueChanged<DateTime?> onPucChanged;
  final VoidCallback onFinish;
  final bool saving;

  const _KeyDatesPage({
    required this.insuranceExpiry,
    required this.pucExpiry,
    required this.onInsuranceChanged,
    required this.onPucChanged,
    required this.onFinish,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(l.onboardingImportantDates, style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.onboardingRemindBody,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxl),

          Text(l.fieldInsuranceExpiry, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          _DateField(
            value: insuranceExpiry,
            hint: l.fieldSelectDate,
            onChanged: onInsuranceChanged,
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(l.fieldPucExpiry, style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          _DateField(
            value: pucExpiry,
            hint: l.fieldSelectDate,
            onChanged: onPucChanged,
          ),
          const SizedBox(height: AppSpacing.xxl),

          PrimaryButton(
            label: l.onboardingAddMyBike,
            onPressed: onFinish,
            isLoading: saving,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
class _ColourPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ColourPicker({required this.selected, required this.onChanged});

  static const _colours = [
    ('#1A56DB', Color(0xFF1A56DB)),
    ('#EF4444', Color(0xFFEF4444)),
    ('#0E9F6E', Color(0xFF0E9F6E)),
    ('#F59E0B', Color(0xFFF59E0B)),
    ('#8B5CF6', Color(0xFF8B5CF6)),
    ('#EC4899', Color(0xFFEC4899)),
    ('#06B6D4', Color(0xFF06B6D4)),
    ('#111827', Color(0xFF111827)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _colours.map(((String, Color) entry) {
        final (hex, colour) = entry;
        final isSelected = selected == hex;
        return GestureDetector(
          onTap: () => onChanged(hex),
          child: AnimatedContainer(
            duration: AppDuration.fast,
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colour,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: isSelected
                  ? [BoxShadow(color: colour.withValues(alpha: 0.5), blurRadius: 6)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final ValueChanged<DateTime?> onChanged;

  const _DateField({
    required this.value,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2040),
        );
        onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value != null
                    ? '${value!.day} / ${value!.month} / ${value!.year}'
                    : hint,
                style: AppTextStyles.body.copyWith(
                  color: value != null
                      ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                      : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary),
                ),
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 16,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
