import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentAmountField extends StatefulWidget {
  final double totalAmount;
  final double minimumAmount;
  final Function(double) onAmountChanged;
  final TextEditingController controller;

  const PaymentAmountField({
    super.key,
    required this.totalAmount,
    required this.minimumAmount,
    required this.onAmountChanged,
    required this.controller,
  });

  @override
  State<PaymentAmountField> createState() => _PaymentAmountFieldState();
}

class _PaymentAmountFieldState extends State<PaymentAmountField> {
  String? _errorText;
  bool _isFullPayment = true;

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.totalAmount.toStringAsFixed(2);
    widget.controller.addListener(_validateAmount);
  }

  void _validateAmount() {
    final text = widget.controller.text;
    if (text.isEmpty) {
      setState(() => _errorText = 'Please enter an amount');
      return;
    }

    final amount = double.tryParse(text);
    if (amount == null) {
      setState(() => _errorText = 'Please enter a valid amount');
      return;
    }

    if (amount < widget.minimumAmount) {
      setState(() => _errorText =
          'Minimum payment: ₹${widget.minimumAmount.toStringAsFixed(2)}');
      return;
    }

    if (amount > widget.totalAmount) {
      setState(() => _errorText = 'Amount cannot exceed total balance');
      return;
    }

    setState(() => _errorText = null);
    widget.onAmountChanged(amount);
  }

  void _setFullPayment() {
    setState(() => _isFullPayment = true);
    widget.controller.text = widget.totalAmount.toStringAsFixed(2);
  }

  void _setPartialPayment() {
    setState(() => _isFullPayment = false);
    widget.controller.text = widget.minimumAmount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentAmount = double.tryParse(widget.controller.text) ?? 0;
    final remainingBalance = widget.totalAmount - currentAmount;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Amount',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _setFullPayment,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: _isFullPayment
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isFullPayment
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'payment',
                          color: _isFullPayment
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 6.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Full Payment',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _isFullPayment
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: GestureDetector(
                  onTap: _setPartialPayment,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: !_isFullPayment
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !_isFullPayment
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'account_balance',
                          color: !_isFullPayment
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 6.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Partial Payment',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: !_isFullPayment
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          TextFormField(
            controller: widget.controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Enter Amount',
              prefixText: '₹ ',
              prefixStyle: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              errorText: _errorText,
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        setState(() => _errorText = 'Please enter an amount');
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 5.w,
                      ),
                    )
                  : null,
            ),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          if (remainingBalance > 0 && currentAmount < widget.totalAmount) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Remaining balance: ₹${remainingBalance.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateAmount);
    super.dispose();
  }
}
