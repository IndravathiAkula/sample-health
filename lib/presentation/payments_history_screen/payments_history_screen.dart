import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_payments_widget.dart';
import './widgets/payment_card_widget.dart';
import './widgets/payment_filter_widget.dart';

class PaymentsHistoryScreen extends StatefulWidget {
  const PaymentsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentsHistoryScreen> createState() => _PaymentsHistoryScreenState();
}

class _PaymentsHistoryScreenState extends State<PaymentsHistoryScreen>
    with TickerProviderStateMixin {
  int selectedSegment = 0;
  final List<String> segments = ['All', 'Paid', 'Pending', 'Failed'];

  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String searchQuery = '';

  // Mock payment data
  List<Map<String, dynamic>> allPayments = [
    {
      'id': 'INV-2024-001',
      'amount': 305.00,
      'status': 'paid',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'appointmentType': 'doctor',
      'doctorName': 'Dr. Sarah Johnson',
      'specialty': 'Reproductive Endocrinologist',
      'paymentMethod': 'UPI',
      'transactionId': 'TXN123456789',
      'description': 'IVF Monitoring Appointment',
    },
    {
      'id': 'INV-2024-002',
      'amount': 185.00,
      'status': 'paid',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'appointmentType': 'home',
      'serviceName': 'Injection Administration',
      'paymentMethod': 'Card',
      'transactionId': 'TXN987654321',
      'description': 'Home Healthcare Service',
    },
    {
      'id': 'INV-2024-003',
      'amount': 450.00,
      'status': 'pending',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'appointmentType': 'doctor',
      'doctorName': 'Dr. Michael Chen',
      'specialty': 'IVF Specialist',
      'paymentMethod': 'Wallet',
      'transactionId': 'TXN456789123',
      'description': 'IVF Consultation',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'id': 'INV-2024-004',
      'amount': 275.00,
      'status': 'failed',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'appointmentType': 'doctor',
      'doctorName': 'Dr. Emily Rodriguez',
      'specialty': 'Fertility Counselor',
      'paymentMethod': 'Card',
      'transactionId': 'TXN789123456',
      'description': 'Fertility Counseling Session',
      'errorMessage': 'Insufficient funds in account',
    },
    {
      'id': 'INV-2024-005',
      'amount': 220.00,
      'status': 'paid',
      'date': DateTime.now().subtract(const Duration(days: 14)),
      'appointmentType': 'home',
      'serviceName': 'Health Monitoring',
      'paymentMethod': 'UPI',
      'transactionId': 'TXN321654987',
      'description': 'Home Health Assessment',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: segments.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedSegment = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredPayments {
    List<Map<String, dynamic>> filtered = List.from(allPayments);

    // Filter by status
    if (selectedSegment > 0) {
      String statusFilter = segments[selectedSegment].toLowerCase();
      filtered = filtered
          .where((payment) => payment['status'] == statusFilter)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((payment) {
        return payment['id']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            payment['description']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (payment['doctorName']
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false) ||
            (payment['serviceName']
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false);
      }).toList();
    }

    // Sort by date (newest first)
    filtered.sort((a, b) => b['date'].compareTo(a['date']));

    return filtered;
  }

  Map<String, int> get statusCounts {
    return {
      'All': allPayments.length,
      'Paid': allPayments.where((p) => p['status'] == 'paid').length,
      'Pending': allPayments.where((p) => p['status'] == 'pending').length,
      'Failed': allPayments.where((p) => p['status'] == 'failed').length,
    };
  }

  double get totalPaidAmount {
    return allPayments
        .where((payment) => payment['status'] == 'paid')
        .fold(0.0, (sum, payment) => sum + payment['amount']);
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        searchQuery = '';
      }
    });
  }

  Future<void> _refreshPayments() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // In real app, this would fetch latest data
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Payment history refreshed'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = filteredPayments;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search payments...',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
                autofocus: true,
              )
            : const Text("Payment History"),
        leading: isSearching
            ? IconButton(
                onPressed: _toggleSearch,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, AppRoutes.mainNavigationScreen,
                    arguments: {'initialIndex': 0}),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: [
          if (!isSearching)
            IconButton(
              onPressed: _toggleSearch,
              icon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          IconButton(
            onPressed: () {
              PaymentFilterWidget.showFilterBottomSheet(
                context,
                onFilterApplied: (filters) {
                  // Apply filters
                },
              );
            },
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with total payments
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
                  AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sarah Mitchell",
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Total Paid: \$${totalPaidAmount.toStringAsFixed(2)}",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Segmented control with counts
          Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child:TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab, // 🔑 makes indicator fill the tab
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.lightTheme.colorScheme.primary,
              labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: segments.map((segment) {
                final count = statusCounts[segment] ?? 0;
                return Tab(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(segment),
                      if (count > 0)
                        Container(
                          margin: EdgeInsets.only(top: 0.5.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w,
                            vertical: 0.2.h,
                          ),
                          decoration: BoxDecoration(
                            color: selectedSegment == segments.indexOf(segment)
                                ? Colors.white.withAlpha(77)
                                : AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count.toString(),
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: selectedSegment == segments.indexOf(segment)
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),

          ),

          // Payment list
          Expanded(
            child: filteredList.isEmpty
                ? EmptyPaymentsWidget(
                    selectedStatus: segments[selectedSegment],
                    isSearching: searchQuery.isNotEmpty,
                  )
                : RefreshIndicator(
                    onRefresh: _refreshPayments,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final payment = filteredList[index];
                        return PaymentCardWidget(
                          payment: payment,
                          onTap: () => _showPaymentDetails(payment),
                          onDownloadPDF: () => _downloadInvoicePDF(payment),
                          onShare: () => _shareInvoice(payment),
                          onRetry: payment['status'] == 'failed'
                              ? () => _retryPayment(payment)
                              : null,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _payOutstandingBills,
        icon: CustomIconWidget(
          iconName: 'payment',
          color: Colors.white,
          size: 20,
        ),
        label: const Text("Pay Outstanding"),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showPaymentDetails(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'receipt_long',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text("Invoice Details"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Invoice ID', payment['id']),
                _buildDetailRow(
                    'Amount', '\$${payment['amount'].toStringAsFixed(2)}'),
                _buildDetailRow(
                    'Status', payment['status'].toString().toUpperCase()),
                _buildDetailRow(
                    'Date', DateFormat('MMM dd, yyyy').format(payment['date'])),
                _buildDetailRow('Payment Method', payment['paymentMethod']),
                _buildDetailRow('Transaction ID', payment['transactionId']),
                _buildDetailRow('Description', payment['description']),
                if (payment['status'] == 'pending' &&
                    payment['dueDate'] != null)
                  _buildDetailRow('Due Date',
                      DateFormat('MMM dd, yyyy').format(payment['dueDate'])),
                if (payment['status'] == 'failed' &&
                    payment['errorMessage'] != null)
                  _buildDetailRow('Error', payment['errorMessage'],
                      isError: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadInvoicePDF(payment);
              },
              child: const Text("Download"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isError ? AppTheme.lightTheme.colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadInvoicePDF(Map<String, dynamic> payment) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 3.w),
              const Text('Generating PDF...'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Simulate PDF generation
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice ${payment['id']} downloaded successfully'),
          backgroundColor: AppTheme.accentLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to download PDF'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _shareInvoice(Map<String, dynamic> payment) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing invoice ${payment['id']}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _retryPayment(Map<String, dynamic> payment) async {
    // Navigate to payment screen with retry data
    Navigator.pushNamed(
      context,
      '/payment-screen',
      arguments: {
        'type': payment['appointmentType'],
        'doctorName': payment['doctorName'],
        'serviceName': payment['serviceName'],
        'specialty': payment['specialty'],
        'consultationFee': payment['amount'] * 0.8,
        'serviceFee': payment['amount'] * 0.1,
        'tax': payment['amount'] * 0.1,
        'isRetry': true,
        'invoiceId': payment['id'],
      },
    );
  }

  void _payOutstandingBills() {
    final pendingPayments =
        allPayments.where((p) => p['status'] == 'pending').toList();

    if (pendingPayments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No outstanding payments'),
          backgroundColor: AppTheme.accentLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Outstanding Bills"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You have ${pendingPayments.length} outstanding bill(s)",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              ...pendingPayments.map((payment) {
                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        payment['id'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${payment['amount'].toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to payment screen for bulk payment
                Navigator.pushNamed(context, '/payment-screen', arguments: {
                  'type': 'bulk',
                  'payments': pendingPayments,
                });
              },
              child: const Text("Pay All"),
            ),
          ],
        );
      },
    );
  }
}
