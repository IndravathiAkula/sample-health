import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class UpiPaymentWidget extends StatefulWidget {
  final double amount;
  final Function(String) onUpiIdSubmitted;
  final VoidCallback onQrCodePayment;

  const UpiPaymentWidget({
    super.key,
    required this.amount,
    required this.onUpiIdSubmitted,
    required this.onQrCodePayment,
  });

  @override
  State<UpiPaymentWidget> createState() => _UpiPaymentWidgetState();
}

class _UpiPaymentWidgetState extends State<UpiPaymentWidget> {
  final TextEditingController _upiController = TextEditingController();
  String? _errorText;
  bool _isValidating = false;

  final List<Map<String, dynamic>> _popularApps = [
    {
      'name': 'Google Pay',
      'icon': 'account_balance_wallet',
      'color': Color(0xFF4285F4),
    },
    {
      'name': 'PhonePe',
      'icon': 'phone_android',
      'color': Color(0xFF5F259F),
    },
    {
      'name': 'Paytm',
      'icon': 'payment',
      'color': Color(0xFF00BAF2),
    },
    {
      'name': 'BHIM',
      'icon': 'account_balance',
      'color': Color(0xFF0066CC),
    },
  ];

  void _validateUpiId(String value) {
    if (value.isEmpty) {
      setState(() => _errorText = null);
      return;
    }

    final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
    if (!upiRegex.hasMatch(value)) {
      setState(() => _errorText = 'Please enter a valid UPI ID');
    } else {
      setState(() => _errorText = null);
    }
  }

  Future<void> _submitUpiPayment() async {
    if (_upiController.text.isEmpty) {
      setState(() => _errorText = 'Please enter your UPI ID');
      return;
    }

    if (_errorText != null) return;

    setState(() => _isValidating = true);

    // Simulate UPI ID validation
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isValidating = false);
    widget.onUpiIdSubmitted(_upiController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'UPI Payment',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // QR Code Payment Option
          GestureDetector(
            onTap: widget.onQrCodePayment,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code',
                    color: colorScheme.primary,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Scan QR Code',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Use any UPI app to scan and pay',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Divider with "OR"
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // UPI ID Input
          TextFormField(
            controller: _upiController,
            onChanged: _validateUpiId,
            decoration: InputDecoration(
              labelText: 'Enter UPI ID',
              hintText: 'example@upi',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'alternate_email',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),
              errorText: _errorText,
              suffixIcon: _upiController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _upiController.clear();
                        setState(() => _errorText = null);
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 5.w,
                      ),
                    )
                  : null,
            ),
            keyboardType: TextInputType.emailAddress,
          ),

          SizedBox(height: 2.h),

          // Pay with UPI ID Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValidating ? null : _submitUpiPayment,
              child: _isValidating
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text('Pay ₹${widget.amount.toStringAsFixed(2)}'),
            ),
          ),

          SizedBox(height: 3.h),

          // Popular UPI Apps
          Text(
            'Popular UPI Apps',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1,
            ),
            itemCount: _popularApps.length,
            itemBuilder: (context, index) {
              final app = _popularApps[index];
              return GestureDetector(
                onTap: widget.onQrCodePayment,
                child: Container(
                  decoration: BoxDecoration(
                    color: (app['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (app['color'] as Color).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: app['icon'] as String,
                        color: app['color'] as Color,
                        size: 6.w,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        app['name'] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }
}
