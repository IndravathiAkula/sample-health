import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentProgressWidget extends StatelessWidget {
  final Animation<double> animation;
  final String paymentMethod;

  const PaymentProgressWidget({
    Key? key,
    required this.animation,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Medical cross animation
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: animation.value * 2 * 3.14159,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'local_hospital',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 10.w,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          // Progress indicator
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                width: 70.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(0.5.h),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),

          // Progress text
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              String progressText = "Processing payment...";

              if (animation.value > 0.3) {
                progressText = "Verifying payment details...";
              }
              if (animation.value > 0.6) {
                progressText = "Securing transaction...";
              }
              if (animation.value > 0.9) {
                progressText = "Almost done...";
              }

              return Text(
                progressText,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),

          SizedBox(height: 1.h),

          Text(
            _getPaymentMethodText(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Security badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSecurityBadge('security', 'SSL Secured'),
              SizedBox(width: 4.w),
              _buildSecurityBadge('verified_user', 'PCI Compliant'),
              SizedBox(width: 4.w),
              _buildSecurityBadge('lock', 'Encrypted'),
            ],
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodText() {
    switch (paymentMethod) {
      case 'upi':
        return 'Processing UPI payment';
      case 'card':
        return 'Processing card payment';
      case 'wallet':
        return 'Processing wallet payment';
      default:
        return 'Processing payment';
    }
  }

  Widget _buildSecurityBadge(String icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.accentLight.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.accentLight,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.accentLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
