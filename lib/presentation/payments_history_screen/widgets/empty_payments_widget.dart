import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyPaymentsWidget extends StatelessWidget {
  final String selectedStatus;
  final bool isSearching;

  const EmptyPaymentsWidget({
    Key? key,
    required this.selectedStatus,
    this.isSearching = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: _getEmptyStateIcon(),
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(128),
              size: 15.w,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _getEmptyStateTitle(),
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              _getEmptyStateMessage(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4.h),
          if (!isSearching && selectedStatus == 'All')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/appointment-type-selection-screen');
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: const Text("Book Appointment"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
        ],
      ),
    );
  }

  String _getEmptyStateIcon() {
    if (isSearching) {
      return 'search_off';
    }

    switch (selectedStatus.toLowerCase()) {
      case 'paid':
        return 'check_circle';
      case 'pending':
        return 'schedule';
      case 'failed':
        return 'error';
      default:
        return 'receipt_long';
    }
  }

  String _getEmptyStateTitle() {
    if (isSearching) {
      return 'No Results Found';
    }

    switch (selectedStatus.toLowerCase()) {
      case 'paid':
        return 'No Paid Invoices';
      case 'pending':
        return 'No Pending Payments';
      case 'failed':
        return 'No Failed Payments';
      default:
        return 'No Payment History';
    }
  }

  String _getEmptyStateMessage() {
    if (isSearching) {
      return 'Try adjusting your search terms or check the spelling of your keywords.';
    }

    switch (selectedStatus.toLowerCase()) {
      case 'paid':
        return 'You haven\'t completed any payments yet. Your paid invoices will appear here once you make payments.';
      case 'pending':
        return 'Great! You don\'t have any pending payments at the moment. All your bills are up to date.';
      case 'failed':
        return 'No payment failures found. All your transactions have been processed successfully.';
      default:
        return 'Start by booking your first appointment. Your payment history and invoices will appear here.';
    }
  }
}
