import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../book_appointment_screen/widgets/calendar_widget.dart';
import '../book_appointment_screen/widgets/step_progress_widget.dart';
import '../book_appointment_screen/widgets/time_slot_widget.dart';
import './widgets/home_confirmation_details_widget.dart';
import './widgets/home_service_details_widget.dart';

class HomeAppointmentScreen extends StatefulWidget {
  const HomeAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<HomeAppointmentScreen> createState() => _HomeAppointmentScreenState();
}

class _HomeAppointmentScreenState extends State<HomeAppointmentScreen> {
  int currentStep = 0;
  final List<String> steps = ["Choose Service", "Select Time", "Confirm"];

  String selectedService = "General Home Care";
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  String? selectedTimeSlot;
  String selectedAddress = "123 Main Street, Apt 2B, New York, NY 10001";
  String specialInstructions = "";
  bool isLoading = false;

  final List<Map<String, dynamic>> homeServices = [
    {
      "id": 1,
      "name": "General Home Care",
      "description": "Basic health monitoring and medication assistance",
      "duration": "60 min",
      "price": "₹150",
      "icon": "medical_information"
    },
    {
      "id": 2,
      "name": "Injection Administration",
      "description": "Professional injection services at your home",
      "duration": "30 min",
      "price": "₹75",
      "icon": "medication"
    },
    {
      "id": 3,
      "name": "Wound Care",
      "description": "Professional wound dressing and care",
      "duration": "45 min",
      "price": "₹120",
      "icon": "healing"
    },
    {
      "id": 4,
      "name": "Health Monitoring",
      "description": "Vital signs check and health assessment",
      "duration": "30 min",
      "price": "₹100",
      "icon": "monitor_heart"
    },
  ];

  final List<Map<String, dynamic>> mockTimeSlots = [
    {
      "time": "9:00 AM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": true
    },
    {
      "time": "10:00 AM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": true
    },
    {
      "time": "11:00 AM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": false
    },
    {
      "time": "2:00 PM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": true
    },
    {
      "time": "3:00 PM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": true
    },
    {
      "time": "4:00 PM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": false
    },
    {
      "time": "5:00 PM",
      "duration": "60 min",
      "type": "Home Visit",
      "available": true
    },
  ];

  void _onServiceSelected(String serviceName) {
    setState(() {
      selectedService = serviceName;
      currentStep = 1;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedTimeSlot = null; // Reset time slot when date changes
    });
  }

  void _onTimeSlotSelected(String timeSlot) {
    // Check minimum booking lead time (3 hours)
    final selectedDateTime = _combineDateTime(selectedDate, timeSlot);
    final now = DateTime.now();
    final minimumBookingTime = now.add(Duration(hours: 3));

    if (selectedDateTime.isBefore(minimumBookingTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a time at least 3 hours in advance'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      selectedTimeSlot = timeSlot;
      currentStep = 2;
    });
  }

  DateTime _combineDateTime(DateTime date, String timeSlot) {
    final timeParts = timeSlot.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Future<void> _confirmAppointment() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call with home appointment flag
    await Future.delayed(Duration(seconds: 2));

    // Simulate API call with appointment_type = 'home'
    final appointmentData = {
      'appointment_type': 'home',
      'service': selectedService,
      'date': selectedDate.toIso8601String(),
      'time_slot': selectedTimeSlot,
      'address': selectedAddress,
      'special_instructions': specialInstructions,
    };

    setState(() {
      isLoading = false;
    });

    // Navigate to payment screen instead of showing success dialog
    final serviceDetails = _getSelectedServiceDetails();
    Navigator.pushNamed(
      context,
      '/payment-screen',
      arguments: {
        'type': 'home',
        'service': selectedService,
        'serviceName': selectedService,
        'date':
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
        'time': selectedTimeSlot,
        'address': selectedAddress,
        'specialInstructions': specialInstructions,
        'duration': serviceDetails['duration'],
        'consultationFee':
            double.parse(serviceDetails['price'].replaceAll('₹', '')),
        'serviceFee': 15.00,
        'tax': double.parse(serviceDetails['price'].replaceAll('₹', '')) * 0.1,
        'insuranceDiscount': 25.00,
      },
    );
  }

  void _showSuccessDialog() {
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
              Container(
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
              SizedBox(height: 2.h),
              Text(
                "Home Appointment Confirmed!",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                "Your home healthcare service has been successfully booked. Our healthcare professional will arrive at your location.",
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
                            context, '/dashboard-screen');
                      },
                      child: Text("Go to Dashboard"),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, '/appointments-list-screen');
                      },
                      child: Text("View Appointments"),
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

  void _goBack() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        if (currentStep == 0) {
          selectedTimeSlot = null;
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  Map<String, dynamic> _getSelectedServiceDetails() {
    return homeServices.firstWhere(
      (service) => service["name"] == selectedService,
      orElse: () => homeServices[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Home Appointment"),
        automaticallyImplyLeading: false,
        actions: [
          // Single Back button on top right
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Back',
          ),
          // Home button beside Back button
          IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.mainNavigationScreen,
              (route) => false,
            ),
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Dashboard',
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step progress indicator
            StepProgressWidget(
              currentStep: currentStep,
              steps: steps,
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: _buildStepContent(),
              ),
            ),

            // Bottom action button
            if (currentStep == 2 && selectedTimeSlot != null)
              Container(
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _confirmAppointment,
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text("Confirming..."),
                            ],
                          )
                        : Text("Confirm Home Appointment"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildServiceSelectionStep();
      case 1:
        return _buildTimeSelectionStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return _buildServiceSelectionStep();
    }
  }

  Widget _buildServiceSelectionStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeServiceDetailsWidget(
            onServiceSelected: _onServiceSelected,
            selectedService: selectedService,
            services: homeServices,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected service info
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.accentLight.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getSelectedServiceDetails()["icon"],
                    color: AppTheme.accentLight,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedService,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${_getSelectedServiceDetails()["duration"]} • ${_getSelectedServiceDetails()["price"]}",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Calendar
          CalendarWidget(
            onDateSelected: _onDateSelected,
            selectedDate: selectedDate,
          ),

          SizedBox(height: 3.h),

          // Time slots
          TimeSlotWidget(
            timeSlots: mockTimeSlots,
            selectedTimeSlot: selectedTimeSlot,
            onTimeSlotSelected: _onTimeSlotSelected,
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeConfirmationDetailsWidget(
            selectedService: _getSelectedServiceDetails(),
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot!,
            selectedAddress: selectedAddress,
            onAddressChange: (address) =>
                setState(() => selectedAddress = address),
            onInstructionsChange: (instructions) =>
                setState(() => specialInstructions = instructions),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
