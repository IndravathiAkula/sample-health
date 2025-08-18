import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentSuccessWidget extends StatefulWidget {
  final String transactionId;
  final double amount;
  final String paymentMethod;
  final DateTime timestamp;
  final VoidCallback onDownloadReceipt;
  final VoidCallback onBackToHome;

  const PaymentSuccessWidget({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.paymentMethod,
    required this.timestamp,
    required this.onDownloadReceipt,
    required this.onBackToHome,
  });

  @override
  State<PaymentSuccessWidget> createState() => _PaymentSuccessWidgetState();
}

class _PaymentSuccessWidgetState extends State<PaymentSuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _confettiController.forward();
    _checkController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Animation
          AnimatedBuilder(
            animation: _checkAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _checkAnimation.value,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 12.w,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          // Success Message
          Text(
            'Payment Successful!',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            'Your payment has been processed successfully.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Payment Details Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  context,
                  'Transaction ID',
                  widget.transactionId,
                  'receipt_long',
                ),
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Amount Paid',
                  '₹${widget.amount.toStringAsFixed(2)}',
                  'currency_rupee',
                ),
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Payment Method',
                  widget.paymentMethod,
                  'payment',
                ),
                SizedBox(height: 2.h),
                _buildDetailRow(
                  context,
                  'Date & Time',
                  _formatDateTime(widget.timestamp),
                  'schedule',
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Action Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onDownloadReceipt,
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: colorScheme.onPrimary,
                    size: 5.w,
                  ),
                  label: const Text('Download Receipt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onBackToHome,
                  icon: CustomIconWidget(
                    iconName: 'home',
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                  label: const Text('Back to Home'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Support Information
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'support_agent',
                      color: colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Need Help?',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'If you have any questions about this payment, please contact our support team with your transaction ID.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    String iconName,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.primary,
          size: 5.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (label == 'Transaction ID')
          GestureDetector(
            onTap: () {
              // Copy to clipboard functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction ID copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: CustomIconWidget(
              iconName: 'content_copy',
              color: colorScheme.primary,
              size: 4.w,
            ),
          ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _checkController.dispose();
    super.dispose();
  }
}
