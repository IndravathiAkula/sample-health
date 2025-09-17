import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConsentContentWidget extends StatelessWidget {
  const ConsentContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main description
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.snuggleBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.snuggleBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'health_and_safety',
                    color: AppTheme.ovalGreen,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Your Privacy Matters',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.ovalGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'At Oval Fertility, your personal and medical data is collected to provide fertility care, manage appointments, and improve your experience. We store your data securely and only share it with authorized doctors and labs.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Key Points Header
        Text(
          'Key Points:',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.ovalGreen,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 2.h),

        // Key Points List
        _buildConsentPoint(
          icon: 'person',
          title: 'We collect personal, medical & appointment details',
          description:
              'Name, contact information, medical history, and appointment preferences',
        ),

        SizedBox(height: 2.h),

        _buildConsentPoint(
          icon: 'medical_services',
          title: 'Data is used only for your care & related services',
          description:
              'Treatment planning, appointment scheduling, medication tracking, and communication',
        ),

        SizedBox(height: 2.h),

        _buildConsentPoint(
          icon: 'security',
          title: 'Stored securely, shared only with authorized providers',
          description:
              'HIPAA-compliant encryption, authorized healthcare professionals only',
        ),

        SizedBox(height: 2.h),

        _buildConsentPoint(
          icon: 'settings',
          title:
              'You can withdraw consent anytime in Settings or by contacting us',
          description:
              'Full control over your data with easy withdrawal options',
        ),
      ],
    );
  }

  Widget _buildConsentPoint({
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.blankieGreen.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.blankieGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.ovalGreen,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0.5.h),
                      child: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.blankieGreen,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.ovalGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
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
