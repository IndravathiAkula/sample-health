import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String category;
  final VoidCallback onUploadPressed;

  const EmptyStateWidget({
    super.key,
    required this.category,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getCategoryIcon(category),
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              _getEmptyTitle(category),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              _getEmptyDescription(category),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Upload button
            ElevatedButton.icon(
              onPressed: onUploadPressed,
              icon: CustomIconWidget(
                iconName: 'add',
                color: colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Upload ${_getCategoryDisplayName(category)}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
            SizedBox(height: 3.h),
            // File format info
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Supported: PDF, JPG, PNG, DOC (Max 10MB)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'lab results':
        return 'science';
      case 'prescriptions':
        return 'medication';
      case 'images':
        return 'image';
      case 'reports':
        return 'description';
      case 'insurance':
        return 'health_and_safety';
      default:
        return 'folder_open';
    }
  }

  String _getEmptyTitle(String category) {
    switch (category.toLowerCase()) {
      case 'lab results':
        return 'No Lab Results Yet';
      case 'prescriptions':
        return 'No Prescriptions Yet';
      case 'images':
        return 'No Images Yet';
      case 'reports':
        return 'No Reports Yet';
      case 'insurance':
        return 'No Insurance Documents Yet';
      default:
        return 'No Documents Yet';
    }
  }

  String _getEmptyDescription(String category) {
    switch (category.toLowerCase()) {
      case 'lab results':
        return 'Upload your lab test results, blood work, and diagnostic reports to keep track of your health progress.';
      case 'prescriptions':
        return 'Store your medication prescriptions and treatment plans for easy access during appointments.';
      case 'images':
        return 'Upload medical images, scans, and photos related to your treatment for comprehensive records.';
      case 'reports':
        return 'Keep all your medical reports, consultation notes, and treatment summaries in one place.';
      case 'insurance':
        return 'Upload your insurance cards, coverage details, and claim documents for quick reference.';
      default:
        return 'Start building your digital medical record by uploading your first document.';
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'lab results':
        return 'Lab Result';
      case 'prescriptions':
        return 'Prescription';
      case 'images':
        return 'Image';
      case 'reports':
        return 'Report';
      case 'insurance':
        return 'Insurance Document';
      default:
        return 'Document';
    }
  }
}
