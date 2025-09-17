import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterApplied;

  const PaymentFilterWidget({
    Key? key,
    required this.onFilterApplied,
  }) : super(key: key);

  static void showFilterBottomSheet(
    BuildContext context, {
    required Function(Map<String, dynamic>) onFilterApplied,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PaymentFilterWidget(
        onFilterApplied: onFilterApplied,
      ),
    );
  }

  @override
  State<PaymentFilterWidget> createState() => _PaymentFilterWidgetState();
}

class _PaymentFilterWidgetState extends State<PaymentFilterWidget> {
  // Filter states
  Set<String> selectedStatuses = {};
  Set<String> selectedPaymentMethods = {};
  Set<String> selectedAppointmentTypes = {};
  DateTimeRange? selectedDateRange;
  RangeValues amountRange = const RangeValues(0, 1000);

  final List<String> statusOptions = ['paid', 'pending', 'failed'];
  final List<String> paymentMethodOptions = ['UPI', 'Card', 'Wallet'];
  final List<String> appointmentTypeOptions = ['doctor', 'home'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Payments",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: _clearAllFilters,
                child: const Text("Clear All"),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Status filter
          _buildFilterSection(
            "Payment Status",
            statusOptions,
            selectedStatuses,
            (value) => setState(() {
              if (selectedStatuses.contains(value)) {
                selectedStatuses.remove(value);
              } else {
                selectedStatuses.add(value);
              }
            }),
            (value) => value.toUpperCase(),
          ),

          SizedBox(height: 3.h),

          // Payment method filter
          _buildFilterSection(
            "Payment Method",
            paymentMethodOptions,
            selectedPaymentMethods,
            (value) => setState(() {
              if (selectedPaymentMethods.contains(value)) {
                selectedPaymentMethods.remove(value);
              } else {
                selectedPaymentMethods.add(value);
              }
            }),
            (value) => value,
          ),

          SizedBox(height: 3.h),

          // Appointment type filter
          _buildFilterSection(
            "Appointment Type",
            appointmentTypeOptions,
            selectedAppointmentTypes,
            (value) => setState(() {
              if (selectedAppointmentTypes.contains(value)) {
                selectedAppointmentTypes.remove(value);
              } else {
                selectedAppointmentTypes.add(value);
              }
            }),
            (value) => value == 'doctor' ? 'Doctor Visit' : 'Home Service',
          ),

          SizedBox(height: 3.h),

          // Date range filter
          _buildDateRangeFilter(),

          SizedBox(height: 3.h),

          // Amount range filter
          _buildAmountRangeFilter(),

          SizedBox(height: 4.h),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: const Text("Apply Filters"),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    Set<String> selectedOptions,
    Function(String) onOptionToggled,
    String Function(String) displayNameFormatter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return FilterChip(
              label: Text(displayNameFormatter(option)),
              selected: isSelected,
              onSelected: (_) => onOptionToggled(option),
              backgroundColor: Colors.transparent,
              selectedColor:
                  AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.dividerColor,
              ),
              labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date Range",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: _selectDateRange,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    selectedDateRange != null
                        ? '${DateFormat('MMM dd').format(selectedDateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(selectedDateRange!.end)}'
                        : 'Select date range',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: selectedDateRange != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (selectedDateRange != null)
                  InkWell(
                    onTap: () => setState(() => selectedDateRange = null),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Amount Range",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        RangeSlider(
          values: amountRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '₹${amountRange.start.round()}',
            '₹${amountRange.end.round()}',
          ),
          onChanged: (values) => setState(() => amountRange = values),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${amountRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '₹${amountRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      selectedStatuses.clear();
      selectedPaymentMethods.clear();
      selectedAppointmentTypes.clear();
      selectedDateRange = null;
      amountRange = const RangeValues(0, 1000);
    });
  }

  void _applyFilters() {
    final filters = {
      'statuses': selectedStatuses.toList(),
      'paymentMethods': selectedPaymentMethods.toList(),
      'appointmentTypes': selectedAppointmentTypes.toList(),
      'dateRange': selectedDateRange,
      'amountRange': amountRange,
    };

    widget.onFilterApplied(filters);
    Navigator.of(context).pop();
  }
}
