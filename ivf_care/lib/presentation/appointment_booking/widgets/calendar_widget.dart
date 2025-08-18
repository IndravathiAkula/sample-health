import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime> availableDates;
  final Map<DateTime, String> dateAvailability;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.availableDates,
    required this.dateAvailability,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final startDate = firstDay.subtract(Duration(days: firstDay.weekday - 1));

    List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Color _getDateColor(DateTime date) {
    final today = DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (dateOnly.isBefore(todayOnly)) {
      return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3);
    }

    final availability = widget.dateAvailability[dateOnly];
    switch (availability) {
      case 'available':
        return AppTheme.accentGreenLight;
      case 'limited':
        return AppTheme.accentPeachLight;
      case 'unavailable':
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3);
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3);
    }
  }

  bool _isDateSelectable(DateTime date) {
    final today = DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (dateOnly.isBefore(todayOnly.add(const Duration(days: 1)))) {
      return false;
    }

    final availability = widget.dateAvailability[dateOnly];
    return availability == 'available' || availability == 'limited';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Month navigation header
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth =
                          DateTime(_currentMonth.year, _currentMonth.month - 1);
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'chevron_left',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth =
                          DateTime(_currentMonth.year, _currentMonth.month + 1);
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Weekday headers
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Calendar grid
          Container(
            height: 35.h,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final days = _getDaysInMonth(_currentMonth);
                final date = days[index];
                final isCurrentMonth = date.month == _currentMonth.month;
                final isSelected = widget.selectedDate.year == date.year &&
                    widget.selectedDate.month == date.month &&
                    widget.selectedDate.day == date.day;
                final isSelectable = _isDateSelectable(date);
                final dateColor = _getDateColor(date);

                return GestureDetector(
                  onTap: isSelectable && isCurrentMonth
                      ? () => widget.onDateSelected(date)
                      : null,
                  child: Container(
                    margin: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isCurrentMonth && isSelectable
                          ? Border.all(
                              color: dateColor,
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${date.day}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : isCurrentMonth
                                    ? isSelectable
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.3)
                                    : AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.2),
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        if (isCurrentMonth && isSelectable && !isSelected)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: dateColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Legend
          Container(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Available', AppTheme.accentGreenLight),
                _buildLegendItem('Limited', AppTheme.accentPeachLight),
                _buildLegendItem(
                    'Unavailable',
                    AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }
}
