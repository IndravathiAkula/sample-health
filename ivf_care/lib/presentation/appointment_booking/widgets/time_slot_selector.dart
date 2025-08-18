import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimeSlotSelector extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedTimeSlot;
  final Function(String) onTimeSlotSelected;
  final bool isLoading;

  const TimeSlotSelector({
    super.key,
    required this.selectedDate,
    this.selectedTimeSlot,
    required this.onTimeSlotSelected,
    this.isLoading = false,
  });

  // Mock time slots data with doctor information
  static const Map<String, List<Map<String, dynamic>>> timeSlots = {
    'morning': [
      {
        'time': '09:00 AM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '09:30 AM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '10:00 AM',
        'doctor': 'Dr. Michael Chen',
        'duration': '45 min',
        'available': false
      },
      {
        'time': '10:30 AM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '11:00 AM',
        'doctor': 'Dr. Michael Chen',
        'duration': '45 min',
        'available': true
      },
      {
        'time': '11:30 AM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
    ],
    'afternoon': [
      {
        'time': '02:00 PM',
        'doctor': 'Dr. Emily Rodriguez',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '02:30 PM',
        'doctor': 'Dr. Emily Rodriguez',
        'duration': '30 min',
        'available': false
      },
      {
        'time': '03:00 PM',
        'doctor': 'Dr. Michael Chen',
        'duration': '45 min',
        'available': true
      },
      {
        'time': '03:30 PM',
        'doctor': 'Dr. Emily Rodriguez',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '04:00 PM',
        'doctor': 'Dr. Michael Chen',
        'duration': '45 min',
        'available': true
      },
      {
        'time': '04:30 PM',
        'doctor': 'Dr. Emily Rodriguez',
        'duration': '30 min',
        'available': false
      },
    ],
    'evening': [
      {
        'time': '06:00 PM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '06:30 PM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
      {
        'time': '07:00 PM',
        'doctor': 'Dr. Emily Rodriguez',
        'duration': '30 min',
        'available': false
      },
      {
        'time': '07:30 PM',
        'doctor': 'Dr. Sarah Johnson',
        'duration': '30 min',
        'available': true
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingSkeleton();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Time Slots',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select your preferred appointment time for ${_formatDate(selectedDate)}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),

          // Morning slots
          _buildTimeSection('Morning', 'morning', Icons.wb_sunny_outlined),
          SizedBox(height: 3.h),

          // Afternoon slots
          _buildTimeSection('Afternoon', 'afternoon', Icons.wb_sunny),
          SizedBox(height: 3.h),

          // Evening slots
          _buildTimeSection('Evening', 'evening', Icons.nights_stay_outlined),
        ],
      ),
    );
  }

  Widget _buildTimeSection(String title, String period, IconData icon) {
    final slots = timeSlots[period] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon.toString().split('.').last,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = selectedTimeSlot == slot['time'];
            final isAvailable = slot['available'] as bool;

            return GestureDetector(
              onTap: isAvailable
                  ? () => onTimeSlotSelected(slot['time'] as String)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accentBlueLight
                      : isAvailable
                          ? AppTheme.lightTheme.colorScheme.surface
                          : AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : isAvailable
                            ? AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          slot['time'] as String,
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : isAvailable
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                          ),
                        ),
                        if (!isAvailable)
                          CustomIconWidget(
                            iconName: 'block',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 16,
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      slot['doctor'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isAvailable
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      slot['duration'] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isAvailable
                            ? AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6)
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 3.h),
          ...List.generate(
              3,
              (sectionIndex) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 25.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 2.h,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                  )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
