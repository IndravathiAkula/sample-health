import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationCalendarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklySchedule;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const MedicationCalendarWidget({
    super.key,
    required this.weeklySchedule,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

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
              // Header
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "Weekly Schedule",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Aug 2025",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              // Week days
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  final date = startOfWeek.add(Duration(days: index));
                  final isSelected = date.day == selectedDate.day &&
                      date.month == selectedDate.month &&
                      date.year == selectedDate.year;
                  final isToday = date.day == now.day &&
                      date.month == now.month &&
                      date.year == now.year;

                  // Get schedule data for this date
                  final daySchedule = weeklySchedule.firstWhere(
                    (schedule) =>
                        (schedule["date"] as DateTime).day == date.day,
                    orElse: () =>
                        {"completionRate": 0.0, "totalMedications": 0},
                  );

                  final completionRate =
                      daySchedule["completionRate"] as double? ?? 0.0;
                  final totalMedications =
                      daySchedule["totalMedications"] as int? ?? 0;

                  return GestureDetector(
                    onTap: () => onDateSelected(date),
                    child: Container(
                      width: 10.w,
                      child: Column(
                        children: [
                          // Day name
                          Text(
                            _getDayName(date.weekday),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Date circle with completion indicator
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : isToday
                                      ? AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.onPrimary
                                          : isToday
                                              ? AppTheme.lightTheme.colorScheme
                                                  .primary
                                              : colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Completion indicator
                                if (totalMedications > 0)
                                  Positioned(
                                    bottom: 1,
                                    right: 1,
                                    child: Container(
                                      width: 2.w,
                                      height: 2.w,
                                      decoration: BoxDecoration(
                                        color: completionRate >= 1.0
                                            ? AppTheme.lightTheme.colorScheme
                                                .secondaryContainer
                                            : completionRate >= 0.5
                                                ? Colors.orange
                                                : AppTheme.lightTheme
                                                    .colorScheme.error,
                                        borderRadius:
                                            BorderRadius.circular(1.w),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          // Medication count
                          if (totalMedications > 0)
                            Text(
                              "$totalMedications",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                fontSize: 10.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 3.h),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(
                    context,
                    AppTheme.lightTheme.colorScheme.secondaryContainer,
                    "Completed",
                  ),
                  _buildLegendItem(
                    context,
                    Colors.orange,
                    "Partial",
                  ),
                  _buildLegendItem(
                    context,
                    AppTheme.lightTheme.colorScheme.error,
                    "Missed",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5.w),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "";
    }
  }
}
