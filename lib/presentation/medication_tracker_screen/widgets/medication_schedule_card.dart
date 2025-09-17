import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationScheduleCard extends StatelessWidget {
  final Map<String, dynamic> medication;
  final VoidCallback onMarkTaken;

  const MedicationScheduleCard({
    Key? key,
    required this.medication,
    required this.onMarkTaken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTaken = medication['isTaken'] ?? false;
    final bool isMissed = medication['isMissed'] ?? false;
    final String status = isTaken ? 'taken' : (isMissed ? 'missed' : 'pending');

    return Container(
      width: 85.w,
      margin: EdgeInsets.only(right: 4.w, bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getBorderColor(status),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomImageWidget(
                    imageUrl: medication['pillImage'] as String,
                    width: 8.w,
                    height: 8.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication['time'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      medication['name'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildStatusIcon(status),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            medication['dosage'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          if (!isTaken)
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: onMarkTaken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMissed
                      ? AppTheme.warningLight
                      : AppTheme.lightTheme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: isMissed ? 'warning' : 'check',
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isMissed ? 'Mark as Taken' : 'Take Now',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isTaken)
            Container(
              width: double.infinity,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentLight,
                  width: 1,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.accentLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Taken at ${medication['takenAt'] ?? medication['time']}',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.accentLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case 'taken':
        return Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: AppTheme.accentLight,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'check',
            color: Colors.white,
            size: 16,
          ),
        );
      case 'missed':
        return Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: AppTheme.warningLight,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'warning',
            color: Colors.white,
            size: 16,
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.outline,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'schedule',
            color: Colors.white,
            size: 16,
          ),
        );
    }
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'taken':
        return AppTheme.accentLight;
      case 'missed':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }
}
