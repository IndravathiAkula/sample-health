import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import '../../services/notification_service.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/health_metrics_card_widget.dart';
import './widgets/medication_reminder_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/upcoming_appointment_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _medications = [];
  bool _isRefreshing = false;
  final NotificationService _notificationService = NotificationService();

  // Mock data for dashboard
  final Map<String, dynamic> _upcomingAppointment = {
    'doctorName': 'Dr. Sarah Johnson',
    'specialty': 'Reproductive Endocrinologist',
    'date': 'Today',
    'time': '2:30 PM',
    'type': 'video',
    'doctorImage':
        'https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  };

  final List<Map<String, dynamic>> _healthMetrics = [
    {
      'type': 'Estradiol (E2)',
      'value': '180',
      'unit': 'pg/mL',
      'trend': 'up',
      'lastUpdated': '2 hours ago',
    },
    {
      'type': 'FSH',
      'value': '8.2',
      'unit': 'mIU/mL',
      'trend': 'stable',
      'lastUpdated': '1 day ago',
    },
    {
      'type': 'LH',
      'value': '15.8',
      'unit': 'mIU/mL',
      'trend': 'up',
      'lastUpdated': '3 hours ago',
    },
    {
      'type': 'Progesterone',
      'value': '22.4',
      'unit': 'ng/mL',
      'trend': 'stable',
      'lastUpdated': '1 hour ago',
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      'type': 'appointment',
      'title': 'Monitoring Appointment Confirmed',
      'description':
          'Ultrasound and blood work with Dr. Sarah Johnson scheduled for today at 2:30 PM',
      'timestamp': '2 hours ago',
      'status': 'confirmed',
    },
    {
      'type': 'medication',
      'title': 'Medication Reminder',
      'description':
          'Gonal-F injection completed - next dose tomorrow at 8:00 PM',
      'timestamp': '1 day ago',
      'status': 'completed',
    },
    {
      'type': 'lab_result',
      'title': 'Hormone Panel Results Available',
      'description': 'Estradiol and progesterone levels are ready for review',
      'timestamp': '2 days ago',
      'status': 'completed',
    },
    {
      'type': 'cycle_tracking',
      'title': 'Cycle Day 12 Update',
      'description':
          'Follicle development tracking - 3 dominant follicles detected',
      'timestamp': '3 days ago',
      'status': 'completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMedications();
    _initializeNotificationService();
    _scheduleMockNotifications();
  }

  Future<void> _initializeNotificationService() async {
    await _notificationService.initialize();
  }

  Future<void> _scheduleMockNotifications() async {
    // Schedule some demo medication notifications
    final now = DateTime.now();

    // Schedule reminder for Gonal-F in 1 minute (for demo)
    await _notificationService.scheduleMedicationReminder(
      medicationName: 'Gonal-F',
      scheduledTime: now.add(const Duration(minutes: 16)),
      dosage: '225 IU',
    );

    // Schedule missed dose notification for Metformin (simulate missed dose)
    await _notificationService.scheduleMissedDoseNotification(
      medicationName: 'Metformin',
      scheduledTime: now.subtract(const Duration(minutes: 30)),
      dosage: '500mg',
    );

    // Add some historical notifications for demo
    await _notificationService.showImmediateNotification(
      title: 'Appointment Reminder',
      body:
          'You have an appointment with Dr. Sarah Johnson tomorrow at 2:30 PM',
      type: 'appointment',
    );
  }

  void _initializeMedications() {
    _medications = [
      {
        'name': 'Gonal-F',
        'dosage': '225 IU',
        'time': '8:00 PM',
        'taken': false,
      },
      {
        'name': 'Cetrotide',
        'dosage': '0.25mg',
        'time': '9:00 AM',
        'taken': true,
      },
      {
        'name': 'Metformin',
        'dosage': '500mg',
        'time': '12:00 PM',
        'taken': false,
      },
    ];
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.dashboardRefreshedSuccessfully ??
              'Dashboard refreshed successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onMedicationToggle(int index, bool taken) {
    setState(() {
      _medications[index]['taken'] = taken;
    });

    // Schedule notifications based on medication status
    final medication = _medications[index];
    if (taken) {
      // Cancel any pending notifications for this medication
      _notificationService.cancelNotification(medication['name'].hashCode);
    } else {
      // Schedule reminder notification
      final now = DateTime.now();
      final medicationTime = _parseMedicationTime(medication['time']);

      _notificationService.scheduleMedicationReminder(
        medicationName: medication['name'],
        scheduledTime: medicationTime,
        dosage: medication['dosage'],
      );
    }
  }

  DateTime _parseMedicationTime(String timeString) {
    final now = DateTime.now();
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minuteParts = parts[1].split(' ');
    final minute = int.parse(minuteParts[0]);
    final isPM = minuteParts.length > 1 && minuteParts[1] == 'PM';

    var actualHour = hour;
    if (isPM && hour != 12) actualHour += 12;
    if (!isPM && hour == 12) actualHour = 0;

    var scheduledTime =
        DateTime(now.year, now.month, now.day, actualHour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  void _onBottomNavTap(int index) {
    // Bottom navigation is now handled by MainNavigationScreen
    // This method can be removed or kept for backward compatibility
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                DashboardHeaderWidget(
                  patientName: 'Sarah Mitchell',
                  currentDate: 'Monday, July 28, 2025 - Cycle Day 12',
                  notificationCount: 3,
                  onProfileTap: () {
                    Navigator.pushNamed(context, AppRoutes.profileScreen);
                  },
                ),
                SizedBox(height: 1.h),
                UpcomingAppointmentCardWidget(
                  appointmentData: _upcomingAppointment,
                  onJoinVideoCall: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations?.joiningVideoCall ??
                            'Joining video call...'),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onGetDirections: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations?.openingDirections ??
                            'Opening directions...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                MedicationReminderCardWidget(
                  medications: _medications,
                  onMedicationToggle: _onMedicationToggle,
                ),
                HealthMetricsCardWidget(
                  healthMetrics: _healthMetrics,
                  onLogNewReading: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            localizations?.healthMetricsLoggingComingSoon ??
                                'Health metrics logging coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                QuickActionsWidget(
                  onBookAppointment: () {
                    Navigator.pushNamed(
                        context, '/appointment-type-selection-screen');
                  },
                  onViewLabResults: () {
                    Navigator.pushNamed(context, '/medical-records-screen');
                  },
                  onRefillPrescription: () {
                    Navigator.pushNamed(context, '/medication-tracker-screen');
                  },
                  onEmergencyContacts: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations
                                ?.emergencyFertilityContactsComingSoon ??
                            'Emergency fertility contacts feature coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                RecentActivityWidget(
                  activities: _recentActivities,
                ),
                SizedBox(height: 10.h), // Extra padding for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }
}
