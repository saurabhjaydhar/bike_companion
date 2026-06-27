import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/restore_service.dart';
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
    setState(() {
      _loading = true;
      _error = null;
    });
    HapticFeedback.lightImpact();

    try {
      final result = await getIt<AuthService>().signInWithGoogle();
      if (result == null) {
        // User cancelled the Google sheet.
        if (mounted) setState(() => _loading = false);
        return;
      }

      // Check Firestore for existing data (returning user on a new device).
      final uid = result.user!.uid;
      final restored = await getIt<RestoreService>().restoreIfNeeded(uid);

      if (restored) {
        // Mark onboarding complete so router goes to /garage, not /onboarding.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(SharedPrefKeys.isOnboardingDone, true);
      }
      // Auth stream fires → router redirects automatically.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Sign-in failed. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // App icon + name
              Icon(Icons.two_wheeler_rounded, size: 80, color: cs.primary),
              const SizedBox(height: 16),
              Text(
                'Bike Companion',
                style: tt.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Track fuel, service & expenses\nfor your motorcycle',
                style:
                    tt.bodyMedium?.copyWith(color: cs.outline),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              // Google Sign-In button
              _GoogleSignInButton(
                loading: _loading,
                onPressed: _signInWithGoogle,
                isDark: isDark,
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
                'By continuing you agree to our Terms & Privacy Policy.',
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    'Continue with Google',
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

/// Hand-drawn Google "G" logo using Flutter canvas (no asset needed).
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Draw the four colored arcs of the G.
    const segments = [
      // (startAngle °, sweepAngle °, color)
      (330.0, 90.0, Color(0xFF4285F4)),   // blue  (top-right)
      (60.0, 90.0, Color(0xFFEA4335)),    // red   (bottom-right) — adjusted
      (150.0, 90.0, Color(0xFFFBBC05)),   // yellow (bottom-left)
      (240.0, 90.0, Color(0xFF34A853)),   // green  (top-left)
    ];

    const toRad = 3.14159265 / 180;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.22
      ..strokeCap = StrokeCap.butt;

    final innerR = r * 0.56;
    final arcR = (r + innerR) / 2;
    final strokeW = (r - innerR);

    paint.strokeWidth = strokeW;

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

    // White horizontal bar for the flat part of the G.
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(cx, cy - strokeW * 0.38, cx + r, cy + strokeW * 0.38),
      barPaint,
    );
    // White cover over the extra arc portion for the G notch.
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), innerR - 1, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
