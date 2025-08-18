import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/activity_item_widget.dart';
import './widgets/emergency_contact_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/greeting_card_widget.dart';
import './widgets/medication_reminder_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/quick_action_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  int _currentBottomIndex = 0;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data for dashboard
  final Map<String, dynamic> patientData = {
    "name": "Sarah Johnson",
    "currentCycleDay": 12,
    "nextAppointment": {
      "date": "2025-08-15",
      "time": "10:30 AM",
      "doctor": "Dr. Emily Chen",
      "type": "Monitoring Visit"
    },
    "medications": [
      {
        "name": "Follistim",
        "dosage": "225 IU",
        "time": "8:00 AM",
        "isTaken": false
      },
      {
        "name": "Menopur",
        "dosage": "150 IU",
        "time": "8:00 PM",
        "isTaken": true
      },
      {
        "name": "Prenatal Vitamins",
        "dosage": "1 tablet",
        "time": "9:00 AM",
        "isTaken": false
      }
    ],
    "recentActivity": [
      {
        "title": "Lab Results Available",
        "description":
            "Your hormone levels from yesterday's blood work are now available for review.",
        "timestamp": "2 hours ago",
        "icon": "science",
        "iconColor": "#4A9B96",
        "isRead": false
      },
      {
        "title": "Appointment Confirmed",
        "description":
            "Your monitoring appointment for August 15th has been confirmed.",
        "timestamp": "1 day ago",
        "icon": "event_available",
        "iconColor": "#013935",
        "isRead": true
      },
      {
        "title": "Payment Processed",
        "description":
            "Your payment of \$1,250 for this cycle has been successfully processed.",
        "timestamp": "2 days ago",
        "icon": "payment",
        "iconColor": "#2E7D32",
        "isRead": true
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _markMedicationTaken(int index) {
    setState(() {
      (patientData["medications"] as List)[index]["isTaken"] = true;
    });
  }

  void _handleEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Emergency Contact',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Calling IVF Care Emergency Line...\n\n+1 (555) 123-4567\n\nAvailable 24/7 for urgent medical concerns.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In real app, would initiate phone call
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Call Now',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getDaysUntilAppointment() {
    final appointmentDate = DateTime.parse((patientData["nextAppointment"]
        as Map<String, dynamic>)["date"] as String);
    final now = DateTime.now();
    return appointmentDate.difference(now).inDays;
  }

  int _getPendingMedications() {
    final medications = patientData["medications"] as List;
    return medications.where((med) => !(med["isTaken"] as bool)).length;
  }

  Widget _buildMetricsSection() {
    return Container(
      height: 20.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        children: [
          MetricsCardWidget(
            title: 'Next Appointment',
            value: '${_getDaysUntilAppointment()} days',
            subtitle: (patientData["nextAppointment"]
                as Map<String, dynamic>)["type"] as String,
            icon: Icons.calendar_today,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            iconColor: AppTheme.lightTheme.colorScheme.primary,
            onTap: () => Navigator.pushNamed(context, '/appointment-booking'),
          ),
          SizedBox(width: 3.w),
          MetricsCardWidget(
            title: 'Medications',
            value: '${_getPendingMedications()}',
            subtitle: 'Pending today',
            icon: Icons.medication,
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiaryContainer,
            iconColor: AppTheme.lightTheme.colorScheme.tertiary,
            onTap: () => Navigator.pushNamed(context, '/medication-reminders'),
          ),
          SizedBox(width: 3.w),
          MetricsCardWidget(
            title: 'Treatment Progress',
            value: '${patientData["currentCycleDay"]}%',
            subtitle: 'Cycle completion',
            icon: Icons.trending_up,
            backgroundColor: AppTheme.lightTheme.colorScheme.secondaryContainer,
            iconColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysTasksSection() {
    final pendingMedications = (patientData["medications"] as List)
        .where((med) => !(med["isTaken"] as bool))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Tasks',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (pendingMedications.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${pendingMedications.length} pending',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (pendingMedications.isEmpty)
          EmptyStateWidget(
            title: 'All tasks completed!',
            message: 'Great job staying on track with your treatment plan.',
            icon: Icons.check_circle_outline,
            actionText: 'View All Medications',
            onActionPressed: () =>
                Navigator.pushNamed(context, '/medication-reminders'),
          )
        else
          ...pendingMedications.asMap().entries.map((entry) {
            final index =
                (patientData["medications"] as List).indexOf(entry.value);
            final medication = entry.value as Map<String, dynamic>;
            return MedicationReminderWidget(
              medicationName: medication["name"] as String,
              dosage: medication["dosage"] as String,
              time: medication["time"] as String,
              isTaken: medication["isTaken"] as bool,
              onMarkTaken: () => _markMedicationTaken(index),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        QuickActionWidget(
          title: 'Book Appointment',
          subtitle: 'Schedule your next visit',
          icon: Icons.calendar_month,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          iconColor: AppTheme.lightTheme.colorScheme.primary,
          onTap: () => Navigator.pushNamed(context, '/appointment-booking'),
        ),
        QuickActionWidget(
          title: 'Upload Documents',
          subtitle: 'Add lab results or medical records',
          icon: Icons.upload_file,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          iconColor: AppTheme.lightTheme.colorScheme.secondary,
          onTap: () => Navigator.pushNamed(context, '/medical-records'),
        ),
        QuickActionWidget(
          title: 'Make Payment',
          subtitle: 'Pay bills or view payment history',
          icon: Icons.payment,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          iconColor: AppTheme.lightTheme.colorScheme.tertiary,
          onTap: () => Navigator.pushNamed(context, '/payment-processing'),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    final activities = patientData["recentActivity"] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/medical-records'),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...activities.map((activity) {
          final activityMap = activity as Map<String, dynamic>;
          return ActivityItemWidget(
            title: activityMap["title"] as String,
            description: activityMap["description"] as String,
            timestamp: activityMap["timestamp"] as String,
            icon: _getIconFromString(activityMap["icon"] as String),
            iconColor: Color(int.parse((activityMap["iconColor"] as String)
                .replaceFirst('#', '0xFF'))),
            isRead: activityMap["isRead"] as bool,
          );
        }).toList(),
      ],
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science;
      case 'event_available':
        return Icons.event_available;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: _refreshData,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreetingCardWidget(
                        patientName: patientData["name"] as String,
                        currentCycleDay: patientData["currentCycleDay"] as int,
                      ),
                      _buildMetricsSection(),
                      SizedBox(height: 2.h),
                      _buildTodaysTasksSection(),
                      SizedBox(height: 2.h),
                      _buildQuickActionsSection(),
                      SizedBox(height: 2.h),
                      _buildRecentActivitySection(),
                      SizedBox(height: 2.h),
                      EmergencyContactWidget(
                        onPressed: _handleEmergencyContact,
                      ),
                      SizedBox(height: 10.h), // Bottom padding for navigation
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }
}
