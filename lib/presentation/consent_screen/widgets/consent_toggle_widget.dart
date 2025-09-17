import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConsentToggleWidget extends StatelessWidget {
  final bool isEnabled;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ConsentToggleWidget({
    super.key,
    required this.isEnabled,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isEnabled
            ? AppTheme.blankieGreen.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? AppTheme.blankieGreen.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scroll instruction (if not enabled)
          if (!isEnabled) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'expand_more',
                  color: Colors.grey,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Please scroll down to read all information',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],

          // Consent Statement
          Text(
            'Consent Statement:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.ovalGreen,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          // Checkbox Row
          GestureDetector(
            onTap: isEnabled ? () => onChanged(!value) : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0.2.h),
                  child: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: value,
                      onChanged: isEnabled
                          ? (newValue) => onChanged(newValue ?? false)
                          : null,
                      activeColor: AppTheme.ovalGreen,
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: isEnabled
                            ? (value
                                ? AppTheme.ovalGreen
                                : AppTheme.pacifierGray)
                            : Colors.grey,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I have read and understood, and I consent to Oval Fertility collecting and using my personal and medical data for the purposes described.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isEnabled
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : Colors.grey,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (value) ...[
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.blankieGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'verified_user',
                                color: AppTheme.ovalGreen,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Consent provided',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.ovalGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
