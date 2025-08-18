import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String patientId;
  final String? avatarUrl;
  final VoidCallback? onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.patientId,
    this.avatarUrl,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: avatarUrl != null
                  ? CustomImageWidget(
                      imageUrl: avatarUrl!,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: colorScheme.primary,
                        size: 8.w,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 4.w),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Patient ID: $patientId',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Edit Button
          if (onEditPressed != null)
            IconButton(
              onPressed: onEditPressed,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: colorScheme.primary,
                size: 6.w,
              ),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surface,
                padding: EdgeInsets.all(2.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
