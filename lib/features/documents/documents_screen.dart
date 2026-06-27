import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/document.dart';
import '../../shared/widgets/empty_state.dart';
import 'documents_provider.dart';

const _uuid = Uuid();

class DocumentsScreen extends ConsumerWidget {
  final String bikeId;
  const DocumentsScreen({super.key, required this.bikeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentsProvider(bikeId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDocument(context, ref, bikeId),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: docsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (docs) {
          if (docs.isEmpty) {
            return const EmptyState(
              icon: Icons.folder_rounded,
              heading: 'No documents',
              body: 'Store your RC, insurance, PUC and more in one place.',
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
            onRefresh: () async => ref.invalidate(documentsProvider(bikeId)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 100),
              children: [
                if (expiring.isNotEmpty) ...[
                  _SectionHeader('Expiring soon', isDark: isDark),
                  _DocGrid(
                      docs: expiring,
                      bikeId: bikeId,
                      isDark: isDark,
                      ref: ref),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (valid.isNotEmpty) ...[
                  _SectionHeader('Valid', isDark: isDark),
                  _DocGrid(
                      docs: valid, bikeId: bikeId, isDark: isDark, ref: ref),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (expired.isNotEmpty) ...[
                  _SectionHeader('Expired', isDark: isDark),
                  _DocGrid(
                      docs: expired,
                      bikeId: bikeId,
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
  final List<BikeDocument> docs;
  final String bikeId;
  final bool isDark;
  final WidgetRef ref;

  const _DocGrid({
    required this.docs,
    required this.bikeId,
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
        onTap: () => _showDocDetail(context, ref, docs[i], bikeId),
        onDelete: () => ref
            .read(documentsProvider(bikeId).notifier)
            .deleteDocument(docs[i].id),
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  final BikeDocument doc;
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

  String _statusLabel() {
    if (doc.isExpired) return 'Expired';
    final days = doc.daysUntilExpiry;
    if (days == null) return 'No expiry';
    if (days <= 0) return 'Expired';
    if (days <= 30) return 'Expires in $days days';
    return DateFormat('d MMM y').format(doc.expiryDate!);
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
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final statusColor = _statusColor();
    final showAlert =
        doc.expiryDate != null &&
        (doc.isExpired || (doc.daysUntilExpiry ?? 999) <= 30);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              title: const Text('Delete document'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
              color:
                  showAlert ? statusColor.withValues(alpha: 0.4) : border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon(), size: 20, color: statusColor),
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
              _statusLabel(),
              style: AppTextStyles.label.copyWith(color: statusColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Document detail sheet
// ---------------------------------------------------------------------------
void _showDocDetail(
    BuildContext context, WidgetRef ref, BikeDocument doc, String bikeId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    builder: (_) => _DocDetailSheet(doc: doc, bikeId: bikeId, ref: ref),
  );
}

class _DocDetailSheet extends StatelessWidget {
  final BikeDocument doc;
  final String bikeId;
  final WidgetRef ref;

  const _DocDetailSheet(
      {required this.doc, required this.bikeId, required this.ref});

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
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(doc.title, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.xs),
          Text(DocumentTypes.label(doc.type),
              style: AppTextStyles.body.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          if (doc.expiryDate != null)
            _DetailRow(
              label: 'Expiry',
              value: DateFormat('d MMM y').format(doc.expiryDate!),
              textSecondary: textSecondary,
              highlight: expiryHighlight,
            ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ref
                    .read(documentsProvider(bikeId).notifier)
                    .deleteDocument(doc.id);
              },
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              label: const Text('Delete',
                  style: TextStyle(color: AppColors.danger)),
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
// Add document bottom sheet
// ---------------------------------------------------------------------------
void _showAddDocument(
    BuildContext context, WidgetRef ref, String bikeId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
    ),
    builder: (_) => _AddDocSheet(bikeId: bikeId, ref: ref),
  );
}

class _AddDocSheet extends StatefulWidget {
  final String bikeId;
  final WidgetRef ref;
  const _AddDocSheet({required this.bikeId, required this.ref});

  @override
  State<_AddDocSheet> createState() => _AddDocSheetState();
}

class _AddDocSheetState extends State<_AddDocSheet> {
  String _type = DocumentTypes.rc;
  DateTime? _expiryDate;
  String? _imagePath;
  final _titleCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = DocumentTypes.label(_type);
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
      final doc = BikeDocument(
        id: _uuid.v4(),
        bikeId: widget.bikeId,
        type: _type,
        title: title,
        filePath: _imagePath,
        expiryDate: _expiryDate,
      );
      await widget.ref
          .read(documentsProvider(widget.bikeId).notifier)
          .addDocument(doc);
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
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Add document', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),

          Text('Document type',
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(),
            items: DocumentTypes.all
                .map((t) => DropdownMenuItem(
                    value: t, child: Text(DocumentTypes.label(t))))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _type = v;
                  _titleCtrl.text = DocumentTypes.label(v);
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Title',
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _titleCtrl,
            decoration:
                const InputDecoration(hintText: 'e.g. RC Book, Policy #...'),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Expiry date (optional)',
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: _pickExpiry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 16, color: textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    _expiryDate != null
                        ? DateFormat('d MMM y').format(_expiryDate!)
                        : 'Select date',
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
                      ? 'Photo selected'
                      : 'Attach photo'),
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
                  : const Text('Save document'),
            ),
          ),
        ],
      ),
    );
  }
}
