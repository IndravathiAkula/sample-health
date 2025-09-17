import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onBookAppointment;
  final VoidCallback? onViewLabResults;
  final VoidCallback? onRefillPrescription;
  final VoidCallback? onEmergencyContacts;

  const QuickActionsWidget({
    super.key,
    this.onBookAppointment,
    this.onViewLabResults,
    this.onRefillPrescription,
    this.onEmergencyContacts,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickActions = [
      {
        'title': 'Book\nAppointment',
        'icon': 'calendar_today',
        'color': AppTheme.lightTheme.colorScheme.primary,
        'onTap': onBookAppointment,
      },
      {
        'title': 'View Lab\nResults',
        'icon': 'science',
        'color': AppTheme.lightTheme.colorScheme.secondary,
        'onTap': onViewLabResults,
      },
      {
        'title': 'Refill\nPrescription',
        'icon': 'local_pharmacy',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
        'onTap': onRefillPrescription,
      },
      {
        'title': 'Emergency\nContacts',
        'icon': 'emergency',
        'color': AppTheme.lightTheme.colorScheme.error,
        'onTap': onEmergencyContacts,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.1,
            ),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];

              return InkWell(
                onTap: action['onTap'],
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color:
                              (action['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: action['icon'],
                          color: action['color'],
                          size: 8.w,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        action['title'],
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
