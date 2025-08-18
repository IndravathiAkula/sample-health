import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationCardWidget extends StatelessWidget {
  final Map<String, dynamic> medication;
  final VoidCallback onMarkTaken;
  final VoidCallback onSkipDose;
  final VoidCallback onSnoozeReminder;
  final VoidCallback onViewDetails;

  const MedicationCardWidget({
    super.key,
    required this.medication,
    required this.onMarkTaken,
    required this.onSkipDose,
    required this.onSnoozeReminder,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isTaken = medication["isTaken"] as bool? ?? false;
    final bool isMissed = medication["isMissed"] as bool? ?? false;
    final String nextDoseTime = medication["nextDoseTime"] as String? ?? "";
    final double progress = medication["progress"] as double? ?? 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with medication name and status
              Row(
                children: [
                  // Pill icon with color coding
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isTaken
                          ? AppTheme.lightTheme.colorScheme.secondaryContainer
                          : isMissed
                              ? AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'medication',
                        color: isTaken
                            ? AppTheme.lightTheme.colorScheme.primary
                            : isMissed
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  // Medication details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication["name"] as String? ?? "",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "${medication["dosage"]} • ${medication["frequency"]}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Progress ring
                  SizedBox(
                    width: 12.w,
                    height: 12.w,
                    child: Stack(
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          backgroundColor:
                              colorScheme.outline.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isTaken
                                ? AppTheme
                                    .lightTheme.colorScheme.secondaryContainer
                                : AppTheme.lightTheme.colorScheme.primary,
                          ),
                          strokeWidth: 3,
                        ),
                        Center(
                          child: Text(
                            "${(progress * 100).toInt()}%",
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              // Next dose information
              if (nextDoseTime.isNotEmpty && !isTaken)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isMissed
                        ? AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isMissed
                          ? AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.3)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: isMissed ? 'warning' : 'schedule',
                        color: isMissed
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          isMissed
                              ? "Missed dose at $nextDoseTime"
                              : "Next dose at $nextDoseTime",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isMissed
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if (nextDoseTime.isNotEmpty && !isTaken) SizedBox(height: 2.h),
              // Action buttons
              Row(
                children: [
                  // Mark as taken button
                  if (!isTaken)
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: onMarkTaken,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              "Mark as Taken",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Taken status
                  if (isTaken)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.secondaryContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme
                                .lightTheme.colorScheme.secondaryContainer,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme
                                  .lightTheme.colorScheme.secondaryContainer,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              "Taken",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.secondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isTaken) SizedBox(width: 2.w),
                  // Quick actions menu
                  if (!isTaken)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'skip':
                            onSkipDose();
                            break;
                          case 'snooze':
                            onSnoozeReminder();
                            break;
                          case 'details':
                            onViewDetails();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'skip',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'skip_next',
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "Skip Dose",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'snooze',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'snooze',
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "Snooze Reminder",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'details',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                size: 4.w,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "View Details",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          size: 5.w,
                        ),
                      ),
                    ),
                  // View details for taken medications
                  if (isTaken) SizedBox(width: 2.w),
                  if (isTaken)
                    GestureDetector(
                      onTap: onViewDetails,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'info',
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          size: 5.w,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
