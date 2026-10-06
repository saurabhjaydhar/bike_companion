import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/l10n.dart';
import '../../data/models/document.dart';
import '../../main.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/hud_panel.dart';
import '../../shared/widgets/reminder_permission.dart';
import 'documents_provider.dart';
import '../../shared/widgets/clay_icon.dart';

const _uuid = Uuid();

class DocumentsScreen extends ConsumerWidget {
  final String vehicleId;
  const DocumentsScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentsProvider(vehicleId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.documentsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDocument(context, ref, vehicleId),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: docsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (docs) {
          if (docs.isEmpty) {
            return EmptyState(
              icon: Icons.folder_rounded,
              heading: l.documentsEmptyTitle,
              body: l.documentsEmptyBody,
            );
          }

          final expiring = docs
              .where((d) =>
                  d.expiryDate != null &&
                  !d.isExpired &&
                  (d.daysUntilExpiry ?? 999) <= 30)
              .toList();
          final valid = docs
              .where((d) =>
                  !d.isExpired &&
                  (d.expiryDate == null || (d.daysUntilExpiry ?? 999) > 30))
              .toList();
          final expired = docs.where((d) => d.isExpired).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(documentsProvider(vehicleId)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 100),
              children: [
                if (expiring.isNotEmpty) ...[
                  _SectionHeader(l.documentsExpiringSoon, isDark: isDark),
                  _DocGrid(
                      docs: expiring,
                      vehicleId: vehicleId,
                      isDark: isDark,
                      ref: ref),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (valid.isNotEmpty) ...[
                  _SectionHeader(l.documentsValid, isDark: isDark),
                  _DocGrid(
                      docs: valid, vehicleId: vehicleId, isDark: isDark, ref: ref),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (expired.isNotEmpty) ...[
                  _SectionHeader(l.documentsExpired, isDark: isDark),
                  _DocGrid(
                      docs: expired,
                      vehicleId: vehicleId,
                      isDark: isDark,
                      ref: ref),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionHeader(this.title, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          color:
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _DocGrid extends StatelessWidget {
  final List<VehicleDocument> docs;
  final String vehicleId;
  final bool isDark;
  final WidgetRef ref;

  const _DocGrid({
    required this.docs,
    required this.vehicleId,
    required this.isDark,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.3,
      ),
      itemCount: docs.length,
      itemBuilder: (context, i) => _DocCard(
        doc: docs[i],
        isDark: isDark,
        onTap: () => _showDocDetail(context, ref, docs[i], vehicleId),
        onDelete: () => ref
            .read(documentsProvider(vehicleId).notifier)
            .deleteDocument(docs[i].id),
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  final VehicleDocument doc;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DocCard({
    required this.doc,
    required this.isDark,
    required this.onTap,
    required this.onDelete,
  });

  Color _statusColor() {
    if (doc.isExpired) return AppColors.danger;
    final days = doc.daysUntilExpiry;
    if (days != null && days <= 30) return AppColors.warning;
    return AppColors.success;
  }

  String _statusLabel(AppLocalizations l) {
    if (doc.isExpired) return l.documentsExpired;
    final days = doc.daysUntilExpiry;
    if (days == null) return l.documentsNoExpiry;
    if (days <= 0) return l.documentsExpired;
    if (days <= 30) return l.documentsExpiresInDays(days);
    return DateFormat('d MMM y', l.localeName).format(doc.expiryDate!);
  }

  IconData _icon() {
    switch (doc.type) {
      case DocumentTypes.rc:
        return Icons.directions_car_rounded;
      case DocumentTypes.insurance:
        return Icons.verified_rounded;
      case DocumentTypes.drivingLicence:
        return Icons.badge_rounded;
      case DocumentTypes.puc:
        return Icons.eco_rounded;
      case DocumentTypes.invoice:
        return Icons.receipt_long_rounded;
      case DocumentTypes.warranty:
        return Icons.workspace_premium_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final statusColor = _statusColor();
    final showAlert =
        doc.expiryDate != null &&
        (doc.isExpired || (doc.daysUntilExpiry ?? 999) <= 30);

    return HudPanel(
      glow: showAlert ? statusColor : null,
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              title: Text(context.l10n.documentsDelete),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ),
        );
      },
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClayIcon(icon: _icon(), color: statusColor, size: 36),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              doc.title,
              style: AppTextStyles.bodySemiBold.copyWith(color: textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              _statusLabel(context.l10n),
              style: AppTextStyles.label.copyWith(color: statusColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
    );
  }
}

// ---------------------------------------------------------------------------
// Document detail sheet
// ---------------------------------------------------------------------------
void _showDocDetail(
    BuildContext context, WidgetRef ref, VehicleDocument doc, String vehicleId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    builder: (_) => _DocDetailSheet(doc: doc, vehicleId: vehicleId, ref: ref),
  );
}

class _DocDetailSheet extends StatelessWidget {
  final VehicleDocument doc;
  final String vehicleId;
  final WidgetRef ref;

  const _DocDetailSheet(
      {required this.doc, required this.vehicleId, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final Color? expiryHighlight = doc.isExpired
        ? AppColors.danger
        : (doc.daysUntilExpiry ?? 999) <= 30
            ? AppColors.warning
            : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.track,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(doc.title, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text(context.l10n.documentTypeLabel(doc.type),
              style: AppTextStyles.body.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          if (doc.expiryDate != null)
            _DetailRow(
              label: context.l10n.documentsExpiry,
              value: DateFormat('d MMM y', context.l10n.localeName)
                  .format(doc.expiryDate!),
              textSecondary: textSecondary,
              highlight: expiryHighlight,
            ),

          // Photo preview
          if (doc.filePath != null) ...[
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () => _showFullPhoto(context, doc.filePath!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: _DocImage(
                  path: doc.filePath!,
                  height: 160,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ref
                    .read(documentsProvider(vehicleId).notifier)
                    .deleteDocument(doc.id);
              },
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              label: Text(context.l10n.commonDelete,
                  style: const TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textSecondary;
  final Color? highlight;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.textSecondary,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: AppTextStyles.body.copyWith(color: textSecondary)),
          ),
          Text(value,
              style: AppTextStyles.bodySemiBold
                  .copyWith(color: highlight)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Photo helpers
// ---------------------------------------------------------------------------

/// Renders a document image from either a local file path or a remote URL.
class _DocImage extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;

  const _DocImage({
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  bool get _isRemote => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    if (_isRemote) {
      return Image.network(
        path,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (ctx, err, stack) => _placeholder(),
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _placeholder(),
      );
    }
    return Image.file(
      File(path),
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (ctx, err, stack) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
        height: height,
        width: width,
        color: AppColors.border,
        child: const Icon(Icons.broken_image_outlined,
            color: AppColors.textSecondary),
      );
}

/// Opens a full-screen photo viewer overlay.
void _showFullPhoto(BuildContext context, String path) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: _DocImage(path: path, fit: BoxFit.contain),
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Add document bottom sheet
// ---------------------------------------------------------------------------
void _showAddDocument(
    BuildContext context, WidgetRef ref, String vehicleId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    builder: (_) => _AddDocSheet(vehicleId: vehicleId, ref: ref),
  );
}

class _AddDocSheet extends StatefulWidget {
  final String vehicleId;
  final WidgetRef ref;
  const _AddDocSheet({required this.vehicleId, required this.ref});

  @override
  State<_AddDocSheet> createState() => _AddDocSheetState();
}

class _AddDocSheetState extends State<_AddDocSheet> {
  String _type = DocumentTypes.rc;
  DateTime? _expiryDate;
  String? _imagePath;
  final _titleCtrl = TextEditingController();
  bool _saving = false;
  bool _titleInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Localizations aren't available in initState.
    if (!_titleInitialized) {
      _titleCtrl.text = context.l10n.documentTypeLabel(_type);
      _titleInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() => _imagePath = file.path);
    }
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    setState(() => _saving = true);
    try {
      final docId = _uuid.v4();
      String? finalPath = _imagePath;

      // Upload photo to Firebase Storage when signed in (not anonymous).
      if (_imagePath != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.isAnonymous) {
          try {
            finalPath = await getIt<StorageService>()
                .uploadDocument(user.uid, widget.vehicleId, docId, _imagePath!);
          } catch (_) {
            // Upload failed — store local path as fallback
          }
        }
      }

      final doc = VehicleDocument(
        id: docId,
        vehicleId: widget.vehicleId,
        type: _type,
        title: title,
        filePath: finalPath,
        expiryDate: _expiryDate,
      );
      await widget.ref
          .read(documentsProvider(widget.vehicleId).notifier)
          .addDocument(doc);
      if (doc.expiryDate != null && mounted) {
        await askReminderPermissionOnce(context);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final l = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.track,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l.documentsAddTitle, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),

          Text(l.documentsType,
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(),
            items: DocumentTypes.all
                .map((t) => DropdownMenuItem(
                    value: t, child: Text(l.documentTypeLabel(t))))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _type = v;
                  _titleCtrl.text = l.documentTypeLabel(v);
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(l.documentsTitleField,
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _titleCtrl,
            decoration:
                InputDecoration(hintText: l.documentsTitleHint),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text(l.documentsExpiryOptional,
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: _pickExpiry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.surfaceVariant,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 16, color: textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _expiryDate != null
                        ? DateFormat('d MMM y', l.localeName)
                            .format(_expiryDate!)
                        : l.fieldSelectDate,
                    style: AppTextStyles.body.copyWith(
                        color: _expiryDate != null ? null : textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(_imagePath != null
                      ? l.documentsPhotoSelected
                      : l.documentsAttachPhoto),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(l.documentsSave),
            ),
          ),
        ],
      ),
    );
  }
}
