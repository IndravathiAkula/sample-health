import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/appointment_summary_card_widget.dart';
import './widgets/cost_breakdown_widget.dart';
import './widgets/payment_method_card_widget.dart';
import './widgets/payment_progress_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  String selectedPaymentMethod = '';
  bool isProcessing = false;
  bool showSuccess = false;

  late AnimationController _progressController;
  late AnimationController _successController;
  late Animation<double> _progressAnimation;
  late Animation<double> _successAnimation;

  Map<String, dynamic> appointmentData = {};

  // Payment form data
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAppointmentData();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _successController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _getAppointmentData() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        appointmentData = args;
      });
    } else {
      // Default appointment data for demo
      setState(() {
        appointmentData = {
          'type': 'doctor',
          'doctorName': 'Dr. Sarah Johnson',
          'specialty': 'Reproductive Endocrinologist',
          'date': 'Tomorrow, Jul 30',
          'time': '2:30 PM',
          'consultationFee': 350.00,
          'serviceFee': 25.00,
          'tax': 30.00,
          'insuranceDiscount': 100.00,
        };
      });
    }
  }

  double get totalAmount {
    final consultationFee = appointmentData['consultationFee'] ?? 150.0;
    final serviceFee = appointmentData['serviceFee'] ?? 15.0;
    final tax = appointmentData['tax'] ?? 13.25;
    final insuranceDiscount = appointmentData['insuranceDiscount'] ?? 50.0;

    return consultationFee + serviceFee + tax - insuranceDiscount;
  }

  bool get isFormValid {
    if (selectedPaymentMethod.isEmpty) return false;

    switch (selectedPaymentMethod) {
      case 'card':
        return _cardNumberController.text.length >= 16 &&
            _expiryController.text.length >= 5 &&
            _cvvController.text.length >= 3 &&
            _nameController.text.isNotEmpty;
      case 'upi':
        return _upiIdController.text.isNotEmpty ||
            selectedPaymentMethod == 'upi_qr';
      case 'wallet':
        return true;
      default:
        return false;
    }
  }

  Future<void> _processPayment() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete payment details'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    _progressController.forward();

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isProcessing = false;
      showSuccess = true;
    });

    _successController.forward();

    // Show success for 2 seconds, then navigate
    await Future.delayed(const Duration(seconds: 2));

    _showPaymentSuccessDialog();
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _successAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _successAnimation.value,
                    child: Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: AppTheme.accentLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 2.h),
              Text(
                "Payment Successful!",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                "Your appointment has been confirmed and paid. You'll receive a receipt via email.",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.mainNavigationScreen,
                            arguments: {'initialIndex': 0});
                      },
                      child: const Text("Go to Dashboard"),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.paymentsHistoryScreen,
                        );
                      },
                      child: const Text("View Receipt"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'security',
              color: AppTheme.accentLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text("Secure Payment"),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          // Remove Back and Home buttons per user request
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            margin: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.accentLight.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.accentLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  "SSL Secured",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: showSuccess ? _buildSuccessView() : _buildPaymentForm(),
      ),
      bottomNavigationBar:
          (!showSuccess && !isProcessing) ? _buildBottomBar() : null,
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _successAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _successAnimation.value,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 15.w,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          Text(
            "Payment Successful!",
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.accentLight,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Your appointment is confirmed",
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    if (isProcessing) {
      return PaymentProgressWidget(
        animation: _progressAnimation,
        paymentMethod: selectedPaymentMethod,
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Appointment Summary
          AppointmentSummaryCardWidget(
            appointmentData: appointmentData,
          ),

          SizedBox(height: 2.h),

          // Cost Breakdown
          CostBreakdownWidget(
            consultationFee: appointmentData['consultationFee'] ?? 150.0,
            serviceFee: appointmentData['serviceFee'] ?? 15.0,
            tax: appointmentData['tax'] ?? 13.25,
            insuranceDiscount: appointmentData['insuranceDiscount'] ?? 50.0,
            totalAmount: totalAmount,
          ),

          SizedBox(height: 2.h),

          // Payment Methods
          Container(
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
                Text(
                  "Choose Payment Method",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),

                // UPI Payment
                PaymentMethodCardWidget(
                  icon: 'account_balance_wallet',
                  title: 'UPI Payment',
                  subtitle: 'PhonePe, Google Pay, Paytm',
                  isSelected: selectedPaymentMethod == 'upi',
                  onTap: () => setState(() => selectedPaymentMethod = 'upi'),
                  child:
                      selectedPaymentMethod == 'upi' ? _buildUPIForm() : null,
                ),

                SizedBox(height: 2.h),

                // Card Payment
                PaymentMethodCardWidget(
                  icon: 'credit_card',
                  title: 'Credit/Debit Card',
                  subtitle: 'Visa, Mastercard, RuPay',
                  isSelected: selectedPaymentMethod == 'card',
                  onTap: () => setState(() => selectedPaymentMethod = 'card'),
                  child:
                      selectedPaymentMethod == 'card' ? _buildCardForm() : null,
                ),

                SizedBox(height: 2.h),

                // Wallet Payment
                PaymentMethodCardWidget(
                  icon: 'account_balance_wallet',
                  title: 'Digital Wallet',
                  subtitle: 'Paytm, Amazon Pay, PayPal',
                  isSelected: selectedPaymentMethod == 'wallet',
                  onTap: () => setState(() => selectedPaymentMethod = 'wallet'),
                  child: selectedPaymentMethod == 'wallet'
                      ? _buildWalletForm()
                      : null,
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildUPIForm() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          // UPI Apps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUPIAppButton('PhonePe', Colors.purple),
              _buildUPIAppButton('GPay', Colors.blue),
              _buildUPIAppButton('Paytm', Colors.indigo),
            ],
          ),

          SizedBox(height: 2.h),

          Text(
            "OR",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2.h),

          // Manual UPI ID
          TextFormField(
            controller: _upiIdController,
            decoration: InputDecoration(
              labelText: 'Enter UPI ID',
              hintText: 'yourname@paytm',
              prefixIcon: CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildUPIAppButton(String name, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = 'upi';
          _upiIdController.text = name.toLowerCase();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Text(
          name,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Column(
          children: [
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: CustomIconWidget(
                  iconName: 'credit_card',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 19,
              onChanged: (value) {
                String formatted = value.replaceAll(RegExp(r'\D'), '');
                if (formatted.length > 16)
                  formatted = formatted.substring(0, 16);

                String display = '';
                for (int i = 0; i < formatted.length; i++) {
                  if (i > 0 && i % 4 == 0) display += ' ';
                  display += formatted[i];
                }

                _cardNumberController.value = TextEditingValue(
                  text: display,
                  selection: TextSelection.collapsed(offset: display.length),
                );
              },
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'MM/YY',
                      hintText: '12/25',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    onChanged: (value) {
                      String formatted = value.replaceAll(RegExp(r'\D'), '');
                      if (formatted.length > 4)
                        formatted = formatted.substring(0, 4);

                      String display = '';
                      for (int i = 0; i < formatted.length; i++) {
                        if (i == 2) display += '/';
                        display += formatted[i];
                      }

                      _expiryController.value = TextEditingValue(
                        text: display,
                        selection:
                            TextSelection.collapsed(offset: display.length),
                      );
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                prefixIcon: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletForm() {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWalletButton('Paytm', Colors.blue),
              _buildWalletButton('Amazon Pay', Colors.orange),
              _buildWalletButton('PayPal', Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletButton(String name, Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = 'wallet';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Text(
          name,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isFormValid ? _processPayment : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                "Pay Securely",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
