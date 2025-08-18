import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/card_payment_form.dart';
import './widgets/outstanding_balance_card.dart';
import './widgets/payment_amount_field.dart';
import './widgets/payment_method_card.dart';
import './widgets/payment_success_widget.dart';
import './widgets/upi_payment_widget.dart';

class PaymentProcessing extends StatefulWidget {
  const PaymentProcessing({super.key});

  @override
  State<PaymentProcessing> createState() => _PaymentProcessingState();
}

class _PaymentProcessingState extends State<PaymentProcessing> {
  final TextEditingController _amountController = TextEditingController();

  int _selectedPaymentMethod = -1;
  double _paymentAmount = 0.0;
  bool _isProcessingPayment = false;
  bool _showPaymentForm = false;
  bool _showSuccessScreen = false;

  String _transactionId = '';
  String _selectedPaymentMethodName = '';

  // Mock data for outstanding balance
  final double _totalOutstandingAmount = 25750.00;
  final double _minimumPaymentAmount = 5000.00;

  final List<Map<String, dynamic>> _outstandingCharges = [
    {
      'description': 'IVF Consultation - Dr. Sarah Johnson',
      'amount': 2500.00,
      'date': '2025-08-05',
    },
    {
      'description': 'Hormone Therapy Medications',
      'amount': 8750.00,
      'date': '2025-08-07',
    },
    {
      'description': 'Ultrasound Monitoring (3 sessions)',
      'amount': 4500.00,
      'date': '2025-08-09',
    },
    {
      'description': 'Blood Work & Lab Tests',
      'amount': 3200.00,
      'date': '2025-08-10',
    },
    {
      'description': 'Embryo Transfer Procedure',
      'amount': 6800.00,
      'date': '2025-08-11',
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'UPI Payment',
      'subtitle': 'Pay using any UPI app',
      'icon': 'qr_code_scanner',
      'supportedApps': ['GPay', 'PhonePe', 'Paytm', 'BHIM'],
    },
    {
      'title': 'Credit/Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay accepted',
      'icon': 'credit_card',
      'supportedApps': null,
    },
    {
      'title': 'Net Banking',
      'subtitle': 'All major banks supported',
      'icon': 'account_balance',
      'supportedApps': ['SBI', 'HDFC', 'ICICI', 'Axis'],
    },
    {
      'title': 'Digital Wallet',
      'subtitle': 'Paytm, PhonePe, Amazon Pay',
      'icon': 'account_balance_wallet',
      'supportedApps': ['Paytm', 'PhonePe', 'Amazon Pay'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _amountController.text = _totalOutstandingAmount.toStringAsFixed(2);
    _paymentAmount = _totalOutstandingAmount;
  }

  void _onAmountChanged(double amount) {
    setState(() {
      _paymentAmount = amount;
    });
  }

  void _onPaymentMethodSelected(int index) {
    setState(() {
      _selectedPaymentMethod = index;
      _selectedPaymentMethodName = _paymentMethods[index]['title'] as String;
    });
  }

  void _proceedToPayment() {
    if (_selectedPaymentMethod == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_paymentAmount < _minimumPaymentAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Minimum payment amount is ₹${_minimumPaymentAmount.toStringAsFixed(2)}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _showPaymentForm = true;
    });
  }

  void _onUpiPayment(String upiId) {
    _processPayment('UPI - $upiId');
  }

  void _onQrCodePayment() {
    _processPayment('UPI - QR Code');
  }

  void _onCardPayment(Map<String, String> cardData) {
    _processPayment(
        'Card - ${cardData['cardType']} ending in ${cardData['cardNumber']?.substring(cardData['cardNumber']!.length - 4)}');
  }

  Future<void> _processPayment(String paymentDetails) async {
    setState(() {
      _isProcessingPayment = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    // Generate transaction ID
    _transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _isProcessingPayment = false;
      _showPaymentForm = false;
      _showSuccessScreen = true;
      _selectedPaymentMethodName = paymentDetails;
    });
  }

  void _downloadReceipt() {
    // Mock receipt download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt downloaded successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _backToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard-home',
      (route) => false,
    );
  }

  void _viewChargeDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildChargeDetailsSheet(),
    );
  }

  Widget _buildChargeDetailsSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Charge Breakdown',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _outstandingCharges.length,
              itemBuilder: (context, index) {
                final charge = _outstandingCharges[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charge['description'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date: ${charge['date']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            '₹${(charge['amount'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_showSuccessScreen) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: PaymentSuccessWidget(
            transactionId: _transactionId,
            amount: _paymentAmount,
            paymentMethod: _selectedPaymentMethodName,
            timestamp: DateTime.now(),
            onDownloadReceipt: _downloadReceipt,
            onBackToHome: _backToHome,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Make Payment',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_showPaymentForm) {
              setState(() {
                _showPaymentForm = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: Colors.green,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'SSL Secure',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isProcessingPayment
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15.w,
                    height: 15.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Processing Payment...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Please do not close the app',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Outstanding Balance Card
                  OutstandingBalanceCard(
                    totalAmount: _totalOutstandingAmount,
                    charges: _outstandingCharges,
                    onViewDetails: _viewChargeDetails,
                  ),

                  if (!_showPaymentForm) ...[
                    // Payment Amount Field
                    PaymentAmountField(
                      totalAmount: _totalOutstandingAmount,
                      minimumAmount: _minimumPaymentAmount,
                      onAmountChanged: _onAmountChanged,
                      controller: _amountController,
                    ),

                    // Payment Methods
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Payment Method',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          ...List.generate(_paymentMethods.length, (index) {
                            final method = _paymentMethods[index];
                            return PaymentMethodCard(
                              title: method['title'] as String,
                              subtitle: method['subtitle'] as String,
                              iconName: method['icon'] as String,
                              isSelected: _selectedPaymentMethod == index,
                              onTap: () => _onPaymentMethodSelected(index),
                              supportedApps:
                                  method['supportedApps'] as List<String>?,
                            );
                          }),
                        ],
                      ),
                    ),

                    // Proceed Button
                    Container(
                      margin: EdgeInsets.all(4.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _proceedToPayment,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'lock',
                                color: colorScheme.onPrimary,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Proceed to Pay ₹${_paymentAmount.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Payment Form
                  if (_showPaymentForm) ...[
                    Container(
                      margin: EdgeInsets.all(4.w),
                      child: _selectedPaymentMethod == 0
                          ? UpiPaymentWidget(
                              amount: _paymentAmount,
                              onUpiIdSubmitted: _onUpiPayment,
                              onQrCodePayment: _onQrCodePayment,
                            )
                          : _selectedPaymentMethod == 1
                              ? CardPaymentForm(
                                  amount: _paymentAmount,
                                  onCardSubmitted: _onCardPayment,
                                )
                              : Container(
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'construction',
                                        color: colorScheme.primary,
                                        size: 15.w,
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Coming Soon',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        'This payment method will be available soon.',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                  ],

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
