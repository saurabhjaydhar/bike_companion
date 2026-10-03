import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/restore_service.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _signInWithGoogle() async {
    _setLoading(true);
    HapticFeedback.lightImpact();

    try {
      final result = await getIt<AuthService>().signInWithGoogle();
      if (result == null) {
        _setLoading(false);
        return; // User cancelled
      }

      final uid = result.user!.uid;

      // Save/update user profile in Firestore (non-blocking on failure)
      getIt<FirestoreService>()
          .saveUserProfile(uid,
              name: result.user?.displayName, email: result.user?.email)
          .ignore();

      // Restore Firestore data if returning user on a new device
      final restored = await getIt<RestoreService>().restoreIfNeeded(uid);
      if (restored) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(SharedPrefKeys.isOnboardingDone, true);
      }
      // Auth stream fires → router redirects automatically
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = context.l10n.authSignInFailed('$e');
        _loading = false;
      });
    }
  }

  Future<void> _continueOffline() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.authOfflineTitle),
        content: Text(context.l10n.authOfflineBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.commonContinue),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    _setLoading(true);
    HapticFeedback.lightImpact();

    try {
      await getIt<AuthService>().signInAnonymously();
      // Auth stream fires → router redirects automatically
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = context.l10n.authOfflineError;
        _loading = false;
      });
    }
  }

  void _setLoading(bool v) {
    if (mounted) setState(() => _loading = v);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    cs.primary.withValues(alpha: 0.28),
                    cs.primary.withValues(alpha: 0.02),
                  ]),
                  border: Border.all(
                      color: cs.primary.withValues(alpha: 0.6), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.45),
                      blurRadius: 44,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Icon(Icons.garage_rounded,
                    size: 72, color: cs.primary),
              ),
              const SizedBox(height: 24),
              Text(
                l.appTitle,
                style: AppTextStyles.display.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                l.authTagline,
                style: tt.bodyMedium?.copyWith(color: cs.outline),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),

              // Google Sign-In
              _GoogleSignInButton(
                loading: _loading,
                onPressed: _signInWithGoogle,
                isDark: isDark,
              ),

              const SizedBox(height: 12),

              // Skip / offline option
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _loading ? null : _continueOffline,
                  child: Text(l.authContinueWithoutAccount),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: tt.bodySmall?.copyWith(color: cs.error),
                  textAlign: TextAlign.center,
                ),
              ],

              const Spacer(),
              Text(
                l.authTerms,
                style: tt.bodySmall?.copyWith(color: cs.outline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Google Sign-In button
// ---------------------------------------------------------------------------
class _GoogleSignInButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;
  final bool isDark;

  const _GoogleSignInButton({
    required this.loading,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF131314) : Colors.white;
    final border = isDark ? const Color(0xFF8E918F) : const Color(0xFFDADCE0);
    final textColor = isDark ? Colors.white : const Color(0xFF1F1F1F);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleLogo(size: 20),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.authContinueWithGoogle,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.25,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _GoogleLogoPainter());
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    const toRad = 3.14159265 / 180;

    final innerR = r * 0.56;
    final arcR = (r + innerR) / 2;
    final strokeW = r - innerR;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    const segments = [
      (330.0, 90.0, Color(0xFF4285F4)),
      (60.0, 90.0, Color(0xFFEA4335)),
      (150.0, 90.0, Color(0xFFFBBC05)),
      (240.0, 90.0, Color(0xFF34A853)),
    ];

    for (final (startDeg, sweepDeg, color) in segments) {
      paint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: arcR),
        (startDeg - 90) * toRad,
        sweepDeg * toRad,
        false,
        paint,
      );
    }

    // Blue crossbar for the G
    canvas.drawRect(
      Rect.fromLTRB(cx, cy - strokeW * 0.38, cx + r, cy + strokeW * 0.38),
      Paint()..color = const Color(0xFF4285F4),
    );
    // White inner circle (cutout)
    canvas.drawCircle(Offset(cx, cy), innerR - 1,
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
