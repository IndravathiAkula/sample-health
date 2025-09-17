import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimeSlotWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeSlots;
  final String? selectedTimeSlot;
  final Function(String) onTimeSlotSelected;

  const TimeSlotWidget({
    Key? key,
    required this.timeSlots,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Time Slots",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Morning slots
          if (timeSlots
              .any((slot) => (slot["time"] as String).contains("AM"))) ...[
            Text(
              "Morning",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: timeSlots
                  .where((slot) => (slot["time"] as String).contains("AM"))
                  .map((slot) => _buildTimeSlotButton(slot))
                  .toList(),
            ),
            SizedBox(height: 2.h),
          ],

          // Afternoon slots
          if (timeSlots.any((slot) =>
              (slot["time"] as String).contains("PM") &&
              int.parse((slot["time"] as String).split(":")[0]) < 6)) ...[
            Text(
              "Afternoon",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: timeSlots
                  .where((slot) =>
                      (slot["time"] as String).contains("PM") &&
                      int.parse((slot["time"] as String).split(":")[0]) < 6)
                  .map((slot) => _buildTimeSlotButton(slot))
                  .toList(),
            ),
            SizedBox(height: 2.h),
          ],

          // Evening slots
          if (timeSlots.any((slot) =>
              (slot["time"] as String).contains("PM") &&
              int.parse((slot["time"] as String).split(":")[0]) >= 6)) ...[
            Text(
              "Evening",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: timeSlots
                  .where((slot) =>
                      (slot["time"] as String).contains("PM") &&
                      int.parse((slot["time"] as String).split(":")[0]) >= 6)
                  .map((slot) => _buildTimeSlotButton(slot))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSlotButton(Map<String, dynamic> slot) {
    final isSelected = selectedTimeSlot == slot["time"];
    final isAvailable = slot["available"] as bool;

    return GestureDetector(
      onTap: isAvailable ? () => onTimeSlotSelected(slot["time"]) : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : isAvailable
                  ? AppTheme.lightTheme.colorScheme.surface
                  : AppTheme.lightTheme.dividerColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : isAvailable
                    ? AppTheme.lightTheme.dividerColor
                    : AppTheme.lightTheme.dividerColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              slot["time"],
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              "${slot["duration"]} • ${slot["type"]}",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : isAvailable
                        ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
