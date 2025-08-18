import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/appointment_form.dart';
import './widgets/appointment_type_selector.dart';
import './widgets/booking_confirmation_modal.dart';
import './widgets/calendar_widget.dart';
import './widgets/time_slot_selector.dart';

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  // Form state
  String _selectedAppointmentType = '';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  String _appointmentReason = '';
  String _appointmentNotes = '';
  bool _isLoadingTimeSlots = false;
  bool _isBookingAppointment = false;

  // Mock data for calendar availability
  final Map<DateTime, String> _dateAvailability = {};
  final List<DateTime> _availableDates = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _initializeMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    // Generate mock availability data for the next 30 days
    final now = DateTime.now();
    for (int i = 1; i <= 30; i++) {
      final date = DateTime(now.year, now.month, now.day + i);

      // Skip weekends for this example
      if (date.weekday == 6 || date.weekday == 7) {
        _dateAvailability[date] = 'unavailable';
        continue;
      }

      // Randomly assign availability
      final availability = ['available', 'limited', 'unavailable'][i % 3];
      _dateAvailability[date] = availability;

      if (availability != 'unavailable') {
        _availableDates.add(date);
      }
    }
  }

  void _onAppointmentTypeSelected(String type) {
    setState(() {
      _selectedAppointmentType = type;
    });
    _nextStep();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null;
      _isLoadingTimeSlots = true;
    });

    // Simulate API call to fetch time slots
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoadingTimeSlots = false;
        });
      }
    });

    _nextStep();
  }

  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
    _nextStep();
  }

  void _onFormSubmitted(String reason, String notes) {
    setState(() {
      _appointmentReason = reason;
      _appointmentNotes = notes;
      _isBookingAppointment = true;
    });

    // Simulate booking API call
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isBookingAppointment = false;
        });
        _showConfirmationModal();
      }
    });
  }

  void _nextStep() {
    if (_tabController.index < 3) {
      final nextIndex = _tabController.index + 1;
      _tabController.animateTo(nextIndex);
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_tabController.index > 0) {
      final previousIndex = _tabController.index - 1;
      _tabController.animateTo(previousIndex);
      _pageController.animateToPage(
        previousIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showConfirmationModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookingConfirmationModal(
        appointmentType: _selectedAppointmentType,
        selectedDate: _selectedDate,
        selectedTimeSlot: _selectedTimeSlot ?? '',
        reason: _appointmentReason,
        notes: _appointmentNotes,
        appointmentId:
            'APT${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        onClose: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop(0); // Return to previous screen
        },
        onAddToCalendar: () {
          // Implement calendar integration
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  const Text('Calendar integration would be implemented here'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          );
        },
        onSetReminder: () {
          // Implement reminder setting
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reminder has been set'),
              backgroundColor: AppTheme.accentGreenLight,
            ),
          );
        },
      ),
    );
  }

  bool _canProceedToNextStep() {
    switch (_tabController.index) {
      case 0:
        return _selectedAppointmentType.isNotEmpty;
      case 1:
        return _selectedDate.isAfter(DateTime.now());
      case 2:
        return _selectedTimeSlot != null;
      case 3:
        return _appointmentReason.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context,0),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                // Progress indicator
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: List.generate(4, (index) {
                      final isActive = index <= _tabController.index;
                      final isCompleted = index < _tabController.index;

                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            if (index < 3) SizedBox(width: 2.w),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                // Step labels
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2.w),
                  tabs: const [
                    Tab(text: 'Type'),
                    Tab(text: 'Date'),
                    Tab(text: 'Time'),
                    Tab(text: 'Details'),
                  ],
                  labelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  onTap: (index) {
                    // Only allow going back to previous steps
                    if (index <= _tabController.index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index);
              },
              children: [
                // Step 1: Appointment Type Selection
                SingleChildScrollView(
                  child: AppointmentTypeSelector(
                    selectedType: _selectedAppointmentType,
                    onTypeSelected: _onAppointmentTypeSelected,
                  ),
                ),

                // Step 2: Date Selection
                SingleChildScrollView(
                  child: CalendarWidget(
                    selectedDate: _selectedDate,
                    onDateSelected: _onDateSelected,
                    availableDates: _availableDates,
                    dateAvailability: _dateAvailability,
                  ),
                ),

                // Step 3: Time Slot Selection
                SingleChildScrollView(
                  child: TimeSlotSelector(
                    selectedDate: _selectedDate,
                    selectedTimeSlot: _selectedTimeSlot,
                    onTimeSlotSelected: _onTimeSlotSelected,
                    isLoading: _isLoadingTimeSlots,
                  ),
                ),

                // Step 4: Appointment Form
                SingleChildScrollView(
                  child: AppointmentForm(
                    appointmentType: _selectedAppointmentType,
                    selectedDate: _selectedDate,
                    selectedTimeSlot: _selectedTimeSlot ?? '',
                    onFormSubmitted: _onFormSubmitted,
                  ),
                ),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_tabController.index > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 18,
                            ),
                            SizedBox(width: 2.w),
                            Text('Previous'),
                          ],
                        ),
                      ),
                    ),
                  if (_tabController.index > 0) SizedBox(width: 4.w),
                  Expanded(
                    flex: _tabController.index == 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _isBookingAppointment
                          ? null
                          : _canProceedToNextStep()
                              ? _tabController.index == 3
                                  ? () => _onFormSubmitted(
                                      _appointmentReason, _appointmentNotes)
                                  : _nextStep
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                      child: _isBookingAppointment
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                const Text('Booking...'),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_tabController.index == 3
                                    ? 'Book Appointment'
                                    : 'Next'),
                                if (_tabController.index < 3) ...[
                                  SizedBox(width: 2.w),
                                  CustomIconWidget(
                                    iconName: 'arrow_forward',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
