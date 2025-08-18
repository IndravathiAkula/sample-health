import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentCard extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String title = document['title'] as String;
    final String date = document['date'] as String;
    final String fileSize = document['fileSize'] as String;
    final String status = document['status'] as String;
    final String type = document['type'] as String;
    final String thumbnail = document['thumbnail'] as String;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Document thumbnail
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: _getTypeColor(type, colorScheme).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _getTypeColor(type, colorScheme).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: thumbnail.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: CustomImageWidget(
                        imageUrl: thumbnail,
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: CustomIconWidget(
                        iconName: _getTypeIcon(type),
                        color: _getTypeColor(type, colorScheme),
                        size: 6.w,
                      ),
                    ),
            ),
            SizedBox(width: 4.w),
            // Document details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(status, colorScheme, theme),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'folder',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        fileSize,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action indicator
            CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
      String status, ColorScheme colorScheme, ThemeData theme) {
    Color badgeColor;
    String badgeText;

    switch (status.toLowerCase()) {
      case 'new':
        badgeColor = colorScheme.error;
        badgeText = 'NEW';
        break;
      case 'viewed':
        badgeColor = colorScheme.primary;
        badgeText = 'VIEWED';
        break;
      case 'shared':
        badgeColor = AppTheme.successLight;
        badgeText = 'SHARED';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        badgeText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'lab':
        return 'science';
      case 'prescription':
        return 'medication';
      case 'image':
        return 'image';
      case 'report':
        return 'description';
      case 'insurance':
        return 'health_and_safety';
      default:
        return 'insert_drive_file';
    }
  }

  Color _getTypeColor(String type, ColorScheme colorScheme) {
    switch (type.toLowerCase()) {
      case 'lab':
        return AppTheme.accentBlueLight;
      case 'prescription':
        return AppTheme.accentGreenLight;
      case 'image':
        return AppTheme.accentPeachLight;
      case 'report':
        return colorScheme.primary;
      case 'insurance':
        return AppTheme.successLight;
      default:
        return colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}
