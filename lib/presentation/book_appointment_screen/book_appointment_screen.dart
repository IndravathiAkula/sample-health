import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_widget.dart';
import './widgets/confirmation_details_widget.dart';
import './widgets/doctor_card_widget.dart';
import './widgets/specialty_filter_widget.dart';
import './widgets/step_progress_widget.dart';
import './widgets/time_slot_widget.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int currentStep = 0;
  final List<String> steps = ["Select Doctor", "Choose Time", "Confirm"];
  String appointmentType = "doctor"; // Default type

  String selectedSpecialty = "All";
  Map<String, dynamic>? selectedDoctor;
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  String? selectedTimeSlot;
  String selectedReason = "General Consultation";
  bool isLoading = false;

  final List<Map<String, dynamic>> mockDoctors = [
    {
      "id": 1,
      "name": "Dr. Sarah Johnson",
      "specialty": "Reproductive Endocrinologist",
      "profilePhoto":
          "https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.8,
      "reviewCount": 124,
      "nextAvailable": "Today 2:30 PM",
      "location": "Fertility Center - Building A",
      "insuranceAccepted": ["Blue Cross", "Aetna", "Cigna"],
      "consultationFee": "₹350"
    },
    {
      "id": 2,
      "name": "Dr. Michael Chen",
      "specialty": "IVF Specialist",
      "profilePhoto":
          "https://images.pexels.com/photos/6749778/pexels-photo-6749778.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.9,
      "reviewCount": 89,
      "nextAvailable": "Tomorrow 10:00 AM",
      "location": "Advanced Reproductive Medicine",
      "insuranceAccepted": ["United Health", "Blue Cross", "Kaiser"],
      "consultationFee": "₹400"
    },
    {
      "id": 3,
      "name": "Dr. Emily Rodriguez",
      "specialty": "Fertility Counselor",
      "profilePhoto":
          "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.7,
      "reviewCount": 156,
      "nextAvailable": "Jul 30, 3:00 PM",
      "location": "Reproductive Psychology Center",
      "insuranceAccepted": ["Aetna", "Humana", "Blue Cross"],
      "consultationFee": "₹200"
    },
    {
      "id": 4,
      "name": "Dr. James Wilson",
      "specialty": "Embryologist",
      "profilePhoto":
          "https://images.pexels.com/photos/6749777/pexels-photo-6749777.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.6,
      "reviewCount": 98,
      "nextAvailable": "Aug 1, 9:30 AM",
      "location": "IVF Laboratory",
      "insuranceAccepted": ["Cigna", "United Health", "Anthem"],
      "consultationFee": "₹300"
    },
    {
      "id": 5,
      "name": "Dr. Lisa Thompson",
      "specialty": "Reproductive Surgeon",
      "profilePhoto":
          "https://images.pexels.com/photos/5327656/pexels-photo-5327656.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.9,
      "reviewCount": 203,
      "nextAvailable": "Tomorrow 11:15 AM",
      "location": "Surgical Fertility Center",
      "insuranceAccepted": ["Blue Cross", "Aetna", "Medicaid"],
      "consultationFee": "₹450"
    },
  ];

  final List<Map<String, dynamic>> mockTimeSlots = [
    {
      "time": "9:00 AM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "9:30 AM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": false
    },
    {
      "time": "10:00 AM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "10:30 AM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "11:00 AM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": false
    },
    {
      "time": "11:30 AM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "2:00 PM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "2:30 PM",
      "duration": "30 min",
      "type": "Telehealth",
      "available": true
    },
    {
      "time": "3:00 PM",
      "duration": "45 min",
      "type": "Consultation",
      "available": true
    },
    {
      "time": "3:45 PM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": false
    },
    {
      "time": "4:15 PM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "6:00 PM",
      "duration": "30 min",
      "type": "Telehealth",
      "available": true
    },
    {
      "time": "6:30 PM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": true
    },
    {
      "time": "7:00 PM",
      "duration": "30 min",
      "type": "Office Visit",
      "available": false
    },
  ];

  final List<String> reasonOptions = [
    "General Consultation",
    "Initial Fertility Consultation",
    "IVF Monitoring",
    "Egg Retrieval Follow-up",
    "Embryo Transfer",
    "Hormone Level Check",
    "Ultrasound Monitoring",
    "Fertility Counseling",
    "Pre-IVF Testing",
    "Other"
  ];

  List<Map<String, dynamic>> get filteredDoctors {
    if (selectedSpecialty == "All") {
      return mockDoctors;
    }
    return mockDoctors
        .where((doctor) => doctor["specialty"] == selectedSpecialty)
        .toList();
  }

  void _onSpecialtySelected(String specialty) {
    setState(() {
      selectedSpecialty = specialty;
    });
  }

  void _onDoctorSelected(Map<String, dynamic> doctor) {
    setState(() {
      selectedDoctor = doctor;
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
    setState(() {
      selectedTimeSlot = timeSlot;
      currentStep = 2;
    });
  }

  void _onReasonChanged(String? reason) {
    if (reason != null) {
      setState(() {
        selectedReason = reason;
      });
    }
  }

  Future<void> _confirmAppointment() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Navigate to payment screen instead of showing success dialog
    Navigator.pushNamed(
      context,
      '/payment-screen',
      arguments: {
        'type': 'doctor',
        'doctorName': selectedDoctor!['name'],
        'doctorImage': selectedDoctor!['profilePhoto'],
        'specialty': selectedDoctor!['specialty'],
        'location': selectedDoctor!['location'],
        'date':
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
        'time': selectedTimeSlot,
        'reason': selectedReason,
        'consultationFee': double.parse(
            selectedDoctor!['consultationFee'].replaceAll('₹', '')),
        'serviceFee': 25.00,
        'tax': 30.00,
        'insuranceDiscount': 100.00,
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
                "Appointment Confirmed!",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                "Your fertility appointment has been successfully booked. You will receive a confirmation email shortly.",
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

  @override
  void initState() {
    super.initState();
    // Check if proper navigation flow was followed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNavigationFlow();
    });
  }

  void _checkNavigationFlow() {
    // Get the route arguments to check if appointment type was provided
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // If no arguments or no appointment_type, redirect to type selection
    if (args == null || args['appointment_type'] == null) {
      // Redirect to appointment type selection screen for consistency
      Navigator.pushReplacementNamed(
          context, '/appointment-type-selection-screen');
      return;
    }

    // Set the appointment type from arguments
    setState(() {
      appointmentType = args['appointment_type'] ?? "doctor";
    });
  }

  void _goBack() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        if (currentStep == 0) {
          selectedDoctor = null;
        } else if (currentStep == 1) {
          selectedTimeSlot = null;
        }
      });
    } else {
      // Navigate back to appointment type selection instead of just popping
      Navigator.pushReplacementNamed(
          context, '/appointment-type-selection-screen');
    }
  }

  String _getEstimatedCost() {
    if (selectedDoctor != null) {
      return selectedDoctor!["consultationFee"];
    }
    return "₹150";
  }

  String _getInsuranceCoverage() {
    return "80% covered";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Book Appointment"),
        automaticallyImplyLeading: false,
        actions: [
          // Single Back button on top right
          IconButton(
            onPressed: _goBack,
            icon: CustomIconWidget(
              iconName: currentStep > 0 ? 'arrow_back' : 'close',
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
          if (currentStep > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  currentStep = 0;
                  selectedDoctor = null;
                  selectedTimeSlot = null;
                });
              },
              child: Text("Start Over"),
            ),
        ],
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
            if (currentStep == 2 &&
                selectedDoctor != null &&
                selectedTimeSlot != null)
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
                        : Text("Confirm Appointment"),
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
        return _buildDoctorSelectionStep();
      case 1:
        return _buildTimeSelectionStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return _buildDoctorSelectionStep();
    }
  }

  Widget _buildDoctorSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Specialty filter
        SpecialtyFilterWidget(
          onSpecialtySelected: _onSpecialtySelected,
          selectedSpecialty: selectedSpecialty,
        ),

        SizedBox(height: 2.h),

        // Doctor list
        filteredDoctors.isEmpty
            ? Container(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'search_off',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "No doctors found",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Try selecting a different specialty",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return DoctorCardWidget(
                    doctor: doctor,
                    onSelect: () => _onDoctorSelected(doctor),
                    onViewProfile: () {
                      // Navigate to doctor profile (placeholder)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Doctor profile feature coming soon"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),

        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildTimeSelectionStep() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected doctor info
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: selectedDoctor!["profilePhoto"],
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDoctor!["name"],
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        selectedDoctor!["specialty"],
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
          // Confirmation details
          ConfirmationDetailsWidget(
            selectedDoctor: selectedDoctor!,
            selectedDate: selectedDate,
            selectedTimeSlot: selectedTimeSlot!,
            selectedReason: selectedReason,
            estimatedCost: _getEstimatedCost(),
            insuranceCoverage: _getInsuranceCoverage(),
          ),

          SizedBox(height: 3.h),

          // Reason for visit
          Container(
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
                  "Reason for Visit",
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppTheme.lightTheme.dividerColor),
                    ),
                  ),
                  items: reasonOptions.map((reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: _onReasonChanged,
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Insurance verification
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.accentLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'verified_user',
                  color: AppTheme.accentLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Insurance Verified",
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.accentLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Your insurance plan is accepted by this provider",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
