import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/medication_calendar_widget.dart';
import './widgets/medication_card_widget.dart';
import './widgets/medication_empty_state_widget.dart';
import './widgets/medication_header_widget.dart';
import './widgets/snooze_options_widget.dart';
import '../../widgets/custom_bottom_bar.dart';

class MedicationReminders extends StatefulWidget {
  const MedicationReminders({super.key});

  @override
  State<MedicationReminders> createState() => _MedicationRemindersState();
}

class _MedicationRemindersState extends State<MedicationReminders>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  int currentBottomNavIndex = 3; // Medications tab
  bool showCalendarView = false;
  int _currentBottomIndex = 3;
  void _onBottomNavTap(int index) {
    if (index == _currentBottomIndex) return;

    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard-home');
        break;
      case 1:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 2:
        Navigator.pushNamed(context, '/medical-records');
        break;
      case 3:
        break;
      case 4:
        Navigator.pushNamed(context, '/payment-processing');
        break;
    }
  }
  // Mock medication data
  final List<Map<String, dynamic>> medications = [
    {
      "id": 1,
      "name": "Follistim AQ",
      "dosage": "150 IU",
      "frequency": "Daily at 8:00 PM",
      "nextDoseTime": "8:00 PM",
      "isTaken": false,
      "isMissed": false,
      "progress": 0.6,
      "prescriber": "Dr. Sarah Johnson",
      "instructions":
          "Inject subcutaneously in the abdomen. Rotate injection sites.",
      "sideEffects": "Mild injection site reactions, headache, mood changes",
      "startDate": "2025-08-01",
      "endDate": "2025-08-20",
      "totalDoses": 20,
      "completedDoses": 12,
    },
    {
      "id": 2,
      "name": "Menopur",
      "dosage": "75 IU",
      "frequency": "Daily at 8:30 PM",
      "nextDoseTime": "8:30 PM",
      "isTaken": true,
      "isMissed": false,
      "progress": 1.0,
      "prescriber": "Dr. Sarah Johnson",
      "instructions":
          "Mix powder with diluent before injection. Use immediately after mixing.",
      "sideEffects": "Injection site reactions, abdominal pain, nausea",
      "startDate": "2025-08-01",
      "endDate": "2025-08-15",
      "totalDoses": 15,
      "completedDoses": 15,
    },
    {
      "id": 3,
      "name": "Cetrotide",
      "dosage": "0.25 mg",
      "frequency": "Daily at 9:00 AM",
      "nextDoseTime": "9:00 AM",
      "isTaken": false,
      "isMissed": true,
      "progress": 0.3,
      "prescriber": "Dr. Sarah Johnson",
      "instructions": "Inject subcutaneously. Do not shake the vial.",
      "sideEffects": "Injection site reactions, nausea, headache",
      "startDate": "2025-08-05",
      "endDate": "2025-08-12",
      "totalDoses": 8,
      "completedDoses": 2,
    },
    {
      "id": 4,
      "name": "Progesterone",
      "dosage": "200 mg",
      "frequency": "Twice daily",
      "nextDoseTime": "10:00 PM",
      "isTaken": false,
      "isMissed": false,
      "progress": 0.8,
      "prescriber": "Dr. Sarah Johnson",
      "instructions": "Take orally with food. Maintain consistent timing.",
      "sideEffects": "Drowsiness, dizziness, breast tenderness",
      "startDate": "2025-08-08",
      "endDate": "2025-08-25",
      "totalDoses": 34,
      "completedDoses": 27,
    },
    {
      "id": 5,
      "name": "Prenatal Vitamins",
      "dosage": "1 tablet",
      "frequency": "Daily with breakfast",
      "nextDoseTime": "8:00 AM",
      "isTaken": true,
      "isMissed": false,
      "progress": 0.9,
      "prescriber": "Dr. Sarah Johnson",
      "instructions": "Take with food to reduce nausea. Contains folic acid.",
      "sideEffects": "Mild stomach upset, constipation",
      "startDate": "2025-07-01",
      "endDate": "2025-12-31",
      "totalDoses": 183,
      "completedDoses": 165,
    },
  ];

  // Mock weekly schedule data
  final List<Map<String, dynamic>> weeklySchedule = [
    {
      "date": DateTime.now().subtract(const Duration(days: 6)),
      "completionRate": 1.0,
      "totalMedications": 5,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "completionRate": 0.8,
      "totalMedications": 5,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "completionRate": 0.6,
      "totalMedications": 5,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "completionRate": 1.0,
      "totalMedications": 5,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "completionRate": 0.4,
      "totalMedications": 5,
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "completionRate": 0.8,
      "totalMedications": 5,
    },
    {
      "date": DateTime.now(),
      "completionRate": 0.6,
      "totalMedications": 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMarkAsTaken(int medicationId) {
    HapticFeedback.lightImpact();
    setState(() {
      final medicationIndex =
          medications.indexWhere((med) => med["id"] == medicationId);
      if (medicationIndex != -1) {
        medications[medicationIndex]["isTaken"] = true;
        medications[medicationIndex]["isMissed"] = false;
        medications[medicationIndex]["completedDoses"] =
            (medications[medicationIndex]["completedDoses"] as int) + 1;

        // Update progress
        final completed = medications[medicationIndex]["completedDoses"] as int;
        final total = medications[medicationIndex]["totalDoses"] as int;
        medications[medicationIndex]["progress"] = completed / total;
      }
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            const Text("Medication marked as taken"),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleSkipDose(int medicationId) {
    setState(() {
      final medicationIndex =
          medications.indexWhere((med) => med["id"] == medicationId);
      if (medicationIndex != -1) {
        medications[medicationIndex]["isTaken"] = false;
        medications[medicationIndex]["isMissed"] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            const Text("Dose skipped. Contact your doctor if needed."),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: "Contact Doctor",
          textColor: Colors.white,
          onPressed: () {
            // Navigate to contact doctor functionality
          },
        ),
      ),
    );
  }

  void _handleSnoozeReminder(int medicationId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SnoozeOptionsWidget(
        onSnoozeSelected: (minutes) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Reminder snoozed for $minutes minutes"),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _handleViewDetails(int medicationId) {
    final medication =
        medications.firstWhere((med) => med["id"] == medicationId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMedicationDetailsSheet(medication),
    );
  }

  Widget _buildMedicationDetailsSheet(Map<String, dynamic> medication) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'medication',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication["name"] as String,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "${medication["dosage"]} • ${medication["frequency"]}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Details sections
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection(
                    context,
                    "Instructions",
                    medication["instructions"] as String,
                    'info',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailSection(
                    context,
                    "Prescriber",
                    medication["prescriber"] as String,
                    'person',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailSection(
                    context,
                    "Possible Side Effects",
                    medication["sideEffects"] as String,
                    'warning',
                  ),
                  SizedBox(height: 3.h),
                  _buildProgressSection(context, medication),
                ],
              ),
            ),
          ),
          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Close",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
      BuildContext context, String title, String content, String iconName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
      BuildContext context, Map<String, dynamic> medication) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final completed = medication["completedDoses"] as int;
    final total = medication["totalDoses"] as int;
    final progress = completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Text(
              "Treatment Progress",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$completed of $total doses completed",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                minHeight: 1.h,
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Started: ${medication["startDate"]}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    "Ends: ${medication["endDate"]}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAddMedication() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Add medication functionality would open here"),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard-home');
        break;
      case 1:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 2:
        Navigator.pushNamed(context, '/medical-records');
        break;
      case 3:
        // Current screen - do nothing
        break;
      case 4:
        Navigator.pushNamed(context, '/payment-processing');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeMedications =
        medications.where((med) => !(med["isTaken"] as bool)).toList();
    final missedMedications =
        medications.where((med) => med["isMissed"] as bool).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Header
          MedicationHeaderWidget(
            onAddMedication: _handleAddMedication,
            notificationCount: missedMedications.length,
          ),
          // Tab bar
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'medication',
                        color: _tabController.index == 0
                            ? AppTheme.lightTheme.colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Today's Medications",
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'calendar_today',
                        color: _tabController.index == 1
                            ? AppTheme.lightTheme.colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Calendar View",
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
              indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              labelColor: AppTheme.lightTheme.colorScheme.primary,
              unselectedLabelColor:
                  colorScheme.onSurface.withValues(alpha: 0.6),
              onTap: (index) {
                setState(() {
                  showCalendarView = index == 1;
                });
              },
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Today's medications
                medications.isEmpty
                    ? MedicationEmptyStateWidget(
                        onAddMedication: _handleAddMedication,
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 10.h),
                        itemCount: medications.length,
                        itemBuilder: (context, index) {
                          final medication = medications[index];
                          return MedicationCardWidget(
                            medication: medication,
                            onMarkTaken: () =>
                                _handleMarkAsTaken(medication["id"] as int),
                            onSkipDose: () =>
                                _handleSkipDose(medication["id"] as int),
                            onSnoozeReminder: () =>
                                _handleSnoozeReminder(medication["id"] as int),
                            onViewDetails: () =>
                                _handleViewDetails(medication["id"] as int),
                          );
                        },
                      ),
                // Calendar view
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Column(
                    children: [
                      MedicationCalendarWidget(
                        weeklySchedule: weeklySchedule,
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                      SizedBox(height: 2.h),
                      // Selected date medications
                      if (medications.isNotEmpty)
                        ...medications.map((medication) => MedicationCardWidget(
                              medication: medication,
                              onMarkTaken: () =>
                                  _handleMarkAsTaken(medication["id"] as int),
                              onSkipDose: () =>
                                  _handleSkipDose(medication["id"] as int),
                              onSnoozeReminder: () => _handleSnoozeReminder(
                                  medication["id"] as int),
                              onViewDetails: () =>
                                  _handleViewDetails(medication["id"] as int),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currentBottomNavIndex,
      //   onTap: _handleBottomNavTap,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: colorScheme.surface,
      //   selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      //   unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
      //   selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(
      //     fontWeight: FontWeight.w500,
      //   ),
      //   unselectedLabelStyle: theme.textTheme.labelSmall,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'home',
      //         color: currentBottomNavIndex == 0
      //             ? AppTheme.lightTheme.colorScheme.primary
      //             : colorScheme.onSurface.withValues(alpha: 0.6),
      //         size: 6.w,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'calendar_today',
      //         color: currentBottomNavIndex == 1
      //             ? AppTheme.lightTheme.colorScheme.primary
      //             : colorScheme.onSurface.withValues(alpha: 0.6),
      //         size: 6.w,
      //       ),
      //       label: 'Appointments',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'folder',
      //         color: currentBottomNavIndex == 2
      //             ? AppTheme.lightTheme.colorScheme.primary
      //             : colorScheme.onSurface.withValues(alpha: 0.6),
      //         size: 6.w,
      //       ),
      //       label: 'Records',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Stack(
      //         children: [
      //           CustomIconWidget(
      //             iconName: 'medication',
      //             color: currentBottomNavIndex == 3
      //                 ? AppTheme.lightTheme.colorScheme.primary
      //                 : colorScheme.onSurface.withValues(alpha: 0.6),
      //             size: 6.w,
      //           ),
      //           if (missedMedications.isNotEmpty)
      //             Positioned(
      //               right: 0,
      //               top: 0,
      //               child: Container(
      //                 padding: EdgeInsets.all(1.w),
      //                 decoration: BoxDecoration(
      //                   color: AppTheme.lightTheme.colorScheme.error,
      //                   borderRadius: BorderRadius.circular(2.w),
      //                 ),
      //                 constraints: BoxConstraints(
      //                   minWidth: 4.w,
      //                   minHeight: 4.w,
      //                 ),
      //                 child: Text(
      //                   missedMedications.length.toString(),
      //                   style: theme.textTheme.labelSmall?.copyWith(
      //                     color: AppTheme.lightTheme.colorScheme.onError,
      //                     fontSize: 8.sp,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //             ),
      //         ],
      //       ),
      //       label: 'Medications',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CustomIconWidget(
      //         iconName: 'account_balance_wallet',
      //         color: currentBottomNavIndex == 4
      //             ? AppTheme.lightTheme.colorScheme.primary
      //             : colorScheme.onSurface.withValues(alpha: 0.6),
      //         size: 6.w,
      //       ),
      //       label: 'Payments',
      //     ),
      //   ],
      // ),
        bottomNavigationBar: CustomBottomBar(
          currentIndex: _currentBottomIndex,
          onTap: _onBottomNavTap,
        )
    );
  }
}
