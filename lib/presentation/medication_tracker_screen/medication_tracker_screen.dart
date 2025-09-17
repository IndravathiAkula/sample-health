import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import './widgets/adherence_chart.dart';
import './widgets/medication_schedule_card.dart';
import './widgets/prescription_card.dart';
import './widgets/progress_ring_chart.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MedicationTrackerScreen> createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  final ScrollController _scrollController = ScrollController();

  // Mock data for today's medications
  final List<Map<String, dynamic>> todaysMedications = [
    {
      "id": 1,
      "name": "Lisinopril",
      "dosage": "10mg tablet",
      "time": "8:00 AM",
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isTaken": true,
      "takenAt": "8:15 AM",
      "isMissed": false,
    },
    {
      "id": 2,
      "name": "Metformin",
      "dosage": "500mg tablet",
      "time": "12:00 PM",
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isTaken": false,
      "isMissed": true,
      "takenAt": null,
    },
    {
      "id": 3,
      "name": "Atorvastatin",
      "dosage": "20mg tablet",
      "time": "6:00 PM",
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isTaken": false,
      "isMissed": false,
      "takenAt": null,
    },
    {
      "id": 4,
      "name": "Vitamin D3",
      "dosage": "1000 IU capsule",
      "time": "9:00 PM",
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isTaken": false,
      "isMissed": false,
      "takenAt": null,
    },
  ];

  // Mock data for current prescriptions
  final List<Map<String, dynamic>> currentPrescriptions = [
    {
      "id": 1,
      "drugName": "Lisinopril",
      "prescribingDoctor": "Sarah Johnson",
      "dosageInstructions":
      "Take 10mg once daily in the morning with or without food",
      "refillInfo": "2 refills remaining",
      "nextRefillDate": "March 15, 2025",
      "daysRemaining": 15,
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "drugName": "Metformin",
      "prescribingDoctor": "Michael Chen",
      "dosageInstructions":
      "Take 500mg twice daily with meals to reduce stomach upset",
      "refillInfo": "1 refill remaining",
      "nextRefillDate": "February 28, 2025",
      "daysRemaining": 5,
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 3,
      "drugName": "Atorvastatin",
      "prescribingDoctor": "Sarah Johnson",
      "dosageInstructions":
      "Take 20mg once daily in the evening, preferably at the same time",
      "refillInfo": "3 refills remaining",
      "nextRefillDate": "April 10, 2025",
      "daysRemaining": 25,
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 4,
      "drugName": "Vitamin D3",
      "prescribingDoctor": "Emily Rodriguez",
      "dosageInstructions":
      "Take 1000 IU once daily, preferably with a meal containing fat",
      "refillInfo": "No prescription required",
      "nextRefillDate": "As needed",
      "daysRemaining": 30,
      "pillImage":
      "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
  ];

  // Mock adherence data
  final List<Map<String, dynamic>> adherenceData = [
    {"date": "2025-01-21", "adherence": 95.0},
    {"date": "2025-01-22", "adherence": 88.0},
    {"date": "2025-01-23", "adherence": 92.0},
    {"date": "2025-01-24", "adherence": 85.0},
    {"date": "2025-01-25", "adherence": 90.0},
    {"date": "2025-01-26", "adherence": 78.0},
    {"date": "2025-01-27", "adherence": 82.0},
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getTodayCompletedCount() {
    return todaysMedications.where((med) => med['isTaken'] == true).length;
  }

  int _getTodayTotalCount() {
    return todaysMedications.length;
  }

  List<Map<String, dynamic>> _getWeeklyAdherenceData() {
    return adherenceData;
  }

  List<Map<String, dynamic>> _getTodaySchedule() {
    return todaysMedications;
  }

  void _showInsights(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            localizations?.insightsView ?? 'Insights view would open here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showCalendarView(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            localizations?.calendarView ?? 'Calendar view would open here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _addNewMedication(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations?.medicationManagement ??
              'Medication management is handled by your healthcare provider',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _viewMedicationHistory(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.medicationHistory ??
            'Medication history would open here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _exportMedicationLog(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.exportLogFunctionality ??
            'Export log functionality would be implemented here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showTrackerSettings(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.trackerSettings ??
            'Tracker settings would open here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          localizations?.medicationTracker ?? 'Medication Tracker',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'medication_history',
                child: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text('Medication History'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'export_log',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Log'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'medication_history':
                  _viewMedicationHistory(localizations);
                  break;
                case 'export_log':
                  _exportMedicationLog(localizations);
                  break;
                case 'settings':
                  _showTrackerSettings(localizations);
                  break;
              }
            },
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Overview
              Container(
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      AppTheme.lightTheme.colorScheme.secondary.withValues(
                        alpha: 0.05,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations?.todaysProgress ?? 'Today\'s Progress',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${_getTodayCompletedCount()}/${_getTodayTotalCount()}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    ProgressRingChart(
                      adherencePercentage: _getTodayCompletedCount() /
                          _getTodayTotalCount() *
                          100,
                      takenMedications: _getTodayCompletedCount(),
                      totalMedications: _getTodayTotalCount(),
                    ),
                  ],
                ),
              ),

              // Weekly Adherence Chart
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
                      child: Text(
                        localizations?.weeklyAdherence ?? 'Weekly Adherence',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    AdherenceChart(adherenceData: _getWeeklyAdherenceData()),
                  ],
                ),
              ),

              // Current Prescriptions
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
                      child: Text(
                        localizations?.currentPrescriptions ??
                            'Current Prescriptions',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    ...currentPrescriptions.map(
                          (prescription) => PrescriptionCard(
                        prescription: prescription,
                        onMarkTaken: () => _markPrescriptionTaken(
                          prescription['id'] as int,
                          localizations,
                        ),
                        onSetReminder: () => _setReminder(
                            prescription['id'] as int, localizations),
                        onRequestRefill: () => _requestRefill(
                            prescription['id'] as int, localizations),
                        onViewDetails: () => _viewPrescriptionDetails(
                          prescription['id'] as int,
                          localizations,
                        ),
                        onEditDosage: () => _editDosage(
                            prescription['id'] as int, localizations),
                        onDiscontinue: () => _discontinueMedication(
                          prescription['id'] as int,
                          localizations,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Today's Medication Schedule
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
                      child: Text(
                        localizations?.todaysSchedule ?? 'Today\'s Schedule',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    ..._getTodaySchedule().map(
                          (schedule) => MedicationScheduleCard(
                        medication: schedule,
                        onMarkTaken: () => _markMedicationTaken(
                            schedule['id'] as int, localizations),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'My Medications',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
    );
  }

  Widget _buildTodaysScheduleSection() {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Schedule',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => _showFullSchedule(localizations),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: todaysMedications.length,
            itemBuilder: (context, index) {
              final medication = todaysMedications[index];
              return MedicationScheduleCard(
                medication: medication,
                onMarkTaken: () => _markMedicationTaken(
                    medication['id'] as int, localizations),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPrescriptionsSection() {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Current Prescriptions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentPrescriptions.length,
          itemBuilder: (context, index) {
            final prescription = currentPrescriptions[index];
            return PrescriptionCard(
              prescription: prescription,
              onMarkTaken: () => _markPrescriptionTaken(
                  prescription['id'] as int, localizations),
              onSetReminder: () =>
                  _setReminder(prescription['id'] as int, localizations),
              onRequestRefill: () =>
                  _requestRefill(prescription['id'] as int, localizations),
              onViewDetails: () => _viewPrescriptionDetails(
                  prescription['id'] as int, localizations),
              onEditDosage: () =>
                  _editDosage(prescription['id'] as int, localizations),
              onDiscontinue: () => _discontinueMedication(
                  prescription['id'] as int, localizations),
            );
          },
        ),
      ],
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh medication data
    });
  }

  void _markMedicationTaken(int medicationId, AppLocalizations? localizations) {
    setState(() {
      final medicationIndex = todaysMedications.indexWhere(
            (med) => (med)['id'] == medicationId,
      );
      if (medicationIndex != -1) {
        final medication = todaysMedications[medicationIndex];
        medication['isTaken'] = true;
        medication['isMissed'] = false;
        medication['takenAt'] = DateTime.now().toString().substring(11, 16);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.medicationMarkedAsTaken ??
            'Medication marked as taken'),
        backgroundColor: AppTheme.accentLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markPrescriptionTaken(
      int prescriptionId, AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.prescriptionMarkedAsTaken ??
            'Prescription marked as taken'),
        backgroundColor: AppTheme.accentLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setReminder(int prescriptionId, AppLocalizations? localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.setReminder ?? 'Set Reminder'),
        content: Text(
          localizations?.reminderFunctionality ??
              'Reminder functionality would be implemented here with notification scheduling.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations?.reminderSetSuccessfully ??
                      'Reminder set successfully'),
                  backgroundColor: AppTheme.accentLight,
                ),
              );
            },
            child: Text(localizations?.setReminder ?? 'Set Reminder'),
          ),
        ],
      ),
    );
  }

  void _requestRefill(int prescriptionId, AppLocalizations? localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.requestRefill ?? 'Request Refill'),
        content: Text(
          localizations?.refillRequestMessage ??
              'Refill request would be sent to your pharmacy and healthcare provider.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations?.refillRequestSent ??
                      'Refill request sent'),
                  backgroundColor: AppTheme.accentLight,
                ),
              );
            },
            child: Text(localizations?.request ?? 'Request'),
          ),
        ],
      ),
    );
  }

  void _viewPrescriptionDetails(
      int prescriptionId, AppLocalizations? localizations) {
    final prescription = currentPrescriptions.firstWhere(
          (p) => (p)['id'] == prescriptionId,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(prescription['drugName'] as String),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${localizations?.prescribingDoctor ?? 'Prescribing Doctor'}: Dr. ${prescription['prescribingDoctor']}',
              ),
              SizedBox(height: 1.h),
              Text(
                '${localizations?.dosageInstructions ?? 'Dosage Instructions'}: ${prescription['dosageInstructions']}',
              ),
              SizedBox(height: 1.h),
              Text(
                  '${localizations?.refillInformation ?? 'Refill Information'}: ${prescription['refillInfo']}'),
              SizedBox(height: 1.h),
              Text(
                  '${localizations?.nextRefill ?? 'Next Refill'}: ${prescription['nextRefillDate']}'),
              SizedBox(height: 1.h),
              Text(
                  '${localizations?.daysRemaining ?? 'Days Remaining'}: ${prescription['daysRemaining']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  void _editDosage(int prescriptionId, AppLocalizations? localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.editDosage ?? 'Edit Dosage'),
        content: Text(
          localizations?.dosageChangesRequireMedical ??
              'Dosage changes require medical confirmation. Please consult with your healthcare provider.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${localizations?.pleaseContact ?? 'Please contact'} ${localizations?.contactDoctor ?? 'your doctor to modify dosage'}',
                  ),
                  backgroundColor: AppTheme.warningLight,
                ),
              );
            },
            child: Text(localizations?.contactDoctor ?? 'Contact Doctor'),
          ),
        ],
      ),
    );
  }

  void _discontinueMedication(
      int prescriptionId, AppLocalizations? localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            localizations?.discontinueMedication ?? 'Discontinue Medication'),
        content: Text(
          localizations?.discontinueMedicationConfirm ??
              'Are you sure you want to discontinue this medication? This action requires medical confirmation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    localizations?.consultDoctorBeforeDiscontinuing ??
                        'Please consult your doctor before discontinuing',
                  ),
                  backgroundColor: AppTheme.errorLight,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text(localizations?.contactDoctor ?? 'Contact Doctor'),
          ),
        ],
      ),
    );
  }

  void _showFullSchedule(AppLocalizations? localizations) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.fullScheduleView ??
            'Full medication schedule view would open here'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
