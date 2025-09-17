import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../l10n/app_localizations.dart';

class CostBreakdownWidget extends StatelessWidget {
  final double consultationFee;
  final double serviceFee;
  final double tax;
  final double insuranceDiscount;
  final double totalAmount;

  const CostBreakdownWidget({
    Key? key,
    required this.consultationFee,
    required this.serviceFee,
    required this.tax,
    required this.insuranceDiscount,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                localizations?.paymentSummary ?? "Payment Summary",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Cost breakdown items
          _buildCostItem(
            localizations?.consultationFee ?? 'Consultation Fee',
            consultationFee,
            null,
          ),

          _buildCostItem(
            localizations?.serviceFee ?? 'Service Fee',
            serviceFee,
            null,
          ),

          _buildCostItem(
            localizations?.taxProcessing ?? 'Tax & Processing',
            tax,
            null,
          ),

          if (insuranceDiscount > 0)
            _buildCostItem(
              localizations?.insuranceCoverage ?? 'Insurance Coverage',
              -insuranceDiscount,
              AppTheme.accentLight,
              prefix: '-',
            ),

          SizedBox(height: 2.h),

          // Divider
          Container(
            height: 1,
            width: double.infinity,
            color: AppTheme.lightTheme.dividerColor,
          ),

          SizedBox(height: 2.h),

          // Total amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations?.totalAmount ?? "Total Amount",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "₹${totalAmount.toStringAsFixed(2)}",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Insurance info
          if (insuranceDiscount > 0)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentLight.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentLight.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'verified_user',
                    color: AppTheme.accentLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      "${localizations?.yourInsuranceCovers ?? 'Your insurance covers'} ₹${insuranceDiscount.toStringAsFixed(2)} ${localizations?.ofThisAppointment ?? 'of this appointment'}",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentLight,
                        fontWeight: FontWeight.w500,
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

  Widget _buildCostItem(
    String title,
    double amount,
    Color? textColor, {
    String prefix = '',
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            "$prefix₹${amount.abs().toStringAsFixed(2)}",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor ?? AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}