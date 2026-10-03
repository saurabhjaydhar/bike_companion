import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/analytics.dart';
import '../../core/services/rc_scan_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/rc_details.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/primary_button.dart';

/// Scan RC: add photos of the front and back of the RC card, then read both
/// together into the review form. One side is enough for an RC book page or
/// a digital RC.
class RcScanScreen extends ConsumerStatefulWidget {
  const RcScanScreen({super.key});

  @override
  ConsumerState<RcScanScreen> createState() => _RcScanScreenState();
}

class _RcScanScreenState extends ConsumerState<RcScanScreen> {
  String? _frontPath;
  String? _backPath;
  bool _scanning = false;
  bool _useGemini = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(
          () => _useGemini =
              prefs.getBool(SharedPrefKeys.rcScanUseGemini) ?? false,
        );
      }
    });
  }

  Future<void> _setUseGemini(bool value) async {
    setState(() => _useGemini = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.rcScanUseGemini, value);
  }

  Future<void> _addPhoto({required bool front}) async {
    final source = await _chooseSource();
    if (source == null || !mounted) return;
    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2048,
        imageQuality: 90,
      );
      if (file == null || !mounted) return;
      HapticFeedback.selectionClick();
      setState(() => front ? _frontPath = file.path : _backPath = file.path);
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.scanPickerError)));
      }
    }
  }

  Future<ImageSource?> _chooseSource() {
    final l = context.l10n;
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_camera_rounded,
                  color: AppColors.primary,
                ),
                title: Text(l.scanTakePhoto),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary,
                ),
                title: Text(l.scanChooseGallery),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _read() async {
    final paths = [?_frontPath, ?_backPath];
    if (paths.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() => _scanning = true);
    final result = await ref
        .read(rcScanServiceProvider)
        .scan(paths, allowCloud: _useGemini);
    Analytics.rcScan(
      found: result.found,
      reader: result.source.name,
      photos: paths.length,
    );
    if (!mounted) return;
    setState(() => _scanning = false);

    context.push(
      '/onboarding/vehicle-details',
      extra: {
        'details': result.details ?? const RcDetails(rcNumber: ''),
        'source': RcPrefill.scan,
        'prefillSuccess': result.found,
        'failureReason': null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          children: [
            Text(
              l.scanTitle,
              style: AppTextStyles.heading1.copyWith(color: textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.scanSubtitle,
              style: AppTextStyles.body.copyWith(color: textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            _SideSlot(
              label: l.scanFront,
              hint: l.scanFrontHint,
              path: _frontPath,
              enabled: !_scanning,
              onTap: () => _addPhoto(front: true),
              onRemove: () => setState(() => _frontPath = null),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SideSlot(
              label: l.scanBack,
              hint: l.scanBackHint,
              path: _backPath,
              enabled: !_scanning,
              onTap: () => _addPhoto(front: false),
              onRemove: () => setState(() => _backPath = null),
            ),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile(
              value: _useGemini,
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primary,
              secondary: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.accent,
              ),
              title: Text(l.scanUseGemini),
              subtitle: Text(l.scanUseGeminiBody),
              isThreeLine: true,
              onChanged: _scanning ? null : _setUseGemini,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l.scanReadDetails,
              icon: Icons.document_scanner_rounded,
              isLoading: _scanning,
              onPressed: _frontPath != null || _backPath != null ? _read : null,
            ),
            if (_scanning) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l.scanReading,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo slot for one side of the card
// ---------------------------------------------------------------------------
class _SideSlot extends StatelessWidget {
  final String label;
  final String hint;
  final String? path;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SideSlot({
    required this.label,
    required this.hint,
    required this.path,
    required this.enabled,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    final l = context.l10n;
    final hasPhoto = path != null;

    return HudPanel(
      glow: hasPhoto ? AppColors.primary : null,
      onTap: enabled ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasPhoto
                    ? Icons.check_circle_rounded
                    : Icons.credit_card_rounded,
                color: hasPhoto ? AppColors.primary : textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.heading3.copyWith(
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      hint,
                      style: AppTextStyles.caption.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasPhoto)
                IconButton(
                  tooltip: l.scanRemovePhoto,
                  icon: Icon(Icons.close_rounded, color: textSecondary),
                  onPressed: enabled ? onRemove : null,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // ID-1 card proportions, so a smart card fills the frame.
          AspectRatio(
            aspectRatio: 1.586,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: hasPhoto
                  ? Image.file(File(path!), fit: BoxFit.cover)
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceVariantDark
                            : AppColors.surfaceVariant,
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.border,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_a_photo_rounded,
                              color: AppColors.primary,
                              size: 32,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l.scanAddPhoto,
                              style: AppTextStyles.caption.copyWith(
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
