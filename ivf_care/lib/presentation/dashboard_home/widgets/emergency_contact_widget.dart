import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyContactWidget({
    super.key,
    required this.onPressed,
  });

  void _handleEmergencyContact() {
    HapticFeedback.heavyImpact();
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: _handleEmergencyContact,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          foregroundColor: AppTheme.lightTheme.colorScheme.onError,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor:
              AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Emergency Contact',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
