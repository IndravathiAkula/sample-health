import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotificationPreferencesWidget extends StatelessWidget {
  final bool appointmentReminders;
  final bool medicationAlerts;
  final bool promotionalCommunications;
  final Function(bool) onAppointmentRemindersChanged;
  final Function(bool) onMedicationAlertsChanged;
  final Function(bool) onPromotionalCommunicationsChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.appointmentReminders,
    required this.medicationAlerts,
    required this.promotionalCommunications,
    required this.onAppointmentRemindersChanged,
    required this.onMedicationAlertsChanged,
    required this.onPromotionalCommunicationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> notificationTypes = [
      {
        'title': 'Appointment Reminders',
        'subtitle': 'Get notified about upcoming appointments',
        'icon': 'calendar_today',
        'value': appointmentReminders,
        'onChanged': onAppointmentRemindersChanged,
      },
      {
        'title': 'Medication Alerts',
        'subtitle': 'Reminders for medication schedules',
        'icon': 'medication',
        'value': medicationAlerts,
        'onChanged': onMedicationAlertsChanged,
      },
      {
        'title': 'Health Tips & Updates',
        'subtitle': 'Educational content and clinic updates',
        'icon': 'notifications',
        'value': promotionalCommunications,
        'onChanged': onPromotionalCommunicationsChanged,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: notificationTypes.asMap().entries.map((entry) {
          final index = entry.key;
          final notification = entry.value;
          final isLast = index == notificationTypes.length - 1;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: notification['value']
                            ? colorScheme.primary.withValues(alpha: 0.2)
                            : colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: notification['icon'],
                        color: notification['value']
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 5.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['title'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            notification['subtitle'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: notification['value'],
                      onChanged: notification['onChanged'],
                      activeColor: colorScheme.primary,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  indent: 4.w,
                  endIndent: 4.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
