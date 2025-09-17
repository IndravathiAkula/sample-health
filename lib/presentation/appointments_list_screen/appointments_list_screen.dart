import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import './widgets/appointment_card_widget.dart';
import './widgets/appointment_filter_widget.dart';
import './widgets/appointment_search_widget.dart';
import './widgets/appointment_segment_control_widget.dart';
import './widgets/empty_appointments_widget.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  int _selectedSegment = 0;
  String _searchQuery = '';
  Map<String, dynamic> _filters = {};
  bool _isLoading = false;

  // Mock appointment data
  final List<Map<String, dynamic>> _mockAppointments = [
    {
      "id": 1,
      "doctorName": "Dr. Sarah Johnson",
      "doctorImage":
          "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Cardiology",
      "dateTime": "2025-07-30T10:00:00",
      "location": "Main Medical Center - Room 205",
      "type": "in-person",
      "status": "confirmed",
      "notes": "Annual heart checkup and blood pressure monitoring",
    },
    {
      "id": 2,
      "doctorName": "Dr. Michael Chen",
      "doctorImage":
          "https://images.pexels.com/photos/5452293/pexels-photo-5452293.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Dermatology",
      "dateTime": "2025-08-02T14:30:00",
      "location": "Downtown Clinic",
      "type": "telehealth",
      "status": "pending",
      "notes": "Follow-up for skin condition treatment",
    },
    {
      "id": 3,
      "doctorName": "Dr. Emily Rodriguez",
      "doctorImage":
          "https://images.pexels.com/photos/5327656/pexels-photo-5327656.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Family Medicine",
      "dateTime": "2025-08-05T09:15:00",
      "location": "Westside Branch - Room 102",
      "type": "in-person",
      "status": "confirmed",
      "notes": "Routine physical examination and vaccination update",
    },
    {
      "id": 4,
      "doctorName": "Dr. James Wilson",
      "doctorImage":
          "https://images.pexels.com/photos/6749778/pexels-photo-6749778.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Orthopedics",
      "dateTime": "2025-07-25T11:00:00",
      "location": "Main Medical Center - Room 310",
      "type": "in-person",
      "status": "completed",
      "notes": "Knee injury follow-up and physical therapy consultation",
    },
    {
      "id": 5,
      "doctorName": "Dr. Lisa Thompson",
      "doctorImage":
          "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Endocrinology",
      "dateTime": "2025-07-20T15:45:00",
      "location": "Northside Facility",
      "type": "telehealth",
      "status": "completed",
      "notes": "Diabetes management and medication adjustment",
    },
    {
      "id": 6,
      "doctorName": "Dr. Robert Kim",
      "doctorImage":
          "https://images.pexels.com/photos/5452201/pexels-photo-5452201.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Neurology",
      "dateTime": "2025-08-10T13:20:00",
      "location": "Southside Center - Room 205",
      "type": "in-person",
      "status": "confirmed",
      "notes": "Headache evaluation and neurological assessment",
    },
    {
      "id": 7,
      "doctorName": "Dr. Amanda Davis",
      "doctorImage":
          "https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specialty": "Psychiatry",
      "dateTime": "2025-07-15T16:00:00",
      "location": "Downtown Clinic",
      "type": "telehealth",
      "status": "cancelled",
      "notes": "Mental health consultation and therapy session",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(localizations),
      body: RefreshIndicator(
        onRefresh: _refreshAppointments,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AppointmentSearchWidget(
              onSearchChanged: _onSearchChanged,
              initialQuery: _searchQuery,
              onFilterTap: _showFilterBottomSheet,
            ),
            AppointmentSegmentControlWidget(
              selectedIndex: _selectedSegment,
              onSegmentChanged: _onSegmentChanged,
              segmentData: _getSegmentData(localizations),
            ),
            _isLoading
                ? _buildLoadingWidget(localizations)
                : _buildAppointmentsList(localizations),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(localizations),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations? localizations) {
    return AppBar(
      title: Text(
        localizations?.myAppointments ?? 'My Appointments',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          // Safe navigation back - check if can pop, otherwise go to main navigation
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.mainNavigationScreen,
              arguments: {'initialIndex': 0},
            );
          }
        },
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [],
    );
  }

  Widget _buildLoadingWidget(AppLocalizations? localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            localizations?.loadingAppointments ?? 'Loading appointments...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(AppLocalizations? localizations) {
    final filteredAppointments = _getFilteredAppointments();

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState(localizations);
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 12.h),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return AppointmentCardWidget(
          appointment: appointment,
          onTap: () => _onAppointmentTap(appointment, localizations),
          onReschedule:
              () => _onRescheduleAppointment(appointment, localizations),
          onCancel: () => _onCancelAppointment(appointment, localizations),
          onAddToCalendar: () => _onAddToCalendar(appointment, localizations),
          onGetDirections: () => _onGetDirections(appointment, localizations),
          onViewDetails: () => _onViewDetails(appointment, localizations),
          onContactOffice: () => _onContactOffice(appointment, localizations),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations? localizations) {
    String title, subtitle, buttonText;

    switch (_selectedSegment) {
      case 0: // Upcoming
        title =
            localizations?.noUpcomingAppointments ?? 'No Upcoming Appointments';
        subtitle =
            localizations?.noUpcomingAppointmentsSubtitle ??
            'You don\'t have any upcoming appointments scheduled. Book your next appointment to stay on top of your health.';
        buttonText =
            localizations?.scheduleAppointment ?? 'Schedule Appointment';
        break;
      case 1: // Past
        title = localizations?.noPastAppointments ?? 'No Past Appointments';
        subtitle =
            localizations?.noPastAppointmentsSubtitle ??
            'You haven\'t had any appointments yet. Your appointment history will appear here after your visits.';
        buttonText =
            localizations?.scheduleFirstAppointment ??
            'Schedule First Appointment';
        break;
      default: // All
        title = localizations?.noAppointmentsFound ?? 'No Appointments Found';
        subtitle =
            localizations?.noAppointmentsFoundSubtitle ??
            'Start your healthcare journey by scheduling your first appointment with one of our qualified doctors.';
        buttonText =
            localizations?.scheduleYourFirstAppointment ??
            'Schedule Your First Appointment';
    }

    return EmptyAppointmentsWidget(
      title: title,
      subtitle: subtitle,
      buttonText: buttonText,
      onButtonPressed: _navigateToBookAppointment,
      illustrationUrl:
          'https://images.pexels.com/photos/4173251/pexels-photo-4173251.jpeg?auto=compress&cs=tinysrgb&w=400',
    );
  }

  Widget _buildFloatingActionButton(AppLocalizations? localizations) {
    return FloatingActionButton.extended(
      onPressed: _navigateToBookAppointment,
      icon: CustomIconWidget(iconName: 'add', color: Colors.white, size: 20),
      label: Text(
        localizations?.bookAppointment ?? 'Book Appointment',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
    );
  }

  List<Map<String, dynamic>> _getSegmentData(AppLocalizations? localizations) {
    final now = DateTime.now();

    final upcomingCount = _mockAppointments.where((apt) {
      final aptDate = DateTime.parse(apt['dateTime']);
      return aptDate.isAfter(now) && apt['status'] != 'cancelled';
    }).length; // <-- length always returns int, defaults to 0

    final pastCount = _mockAppointments.where((apt) {
      final aptDate = DateTime.parse(apt['dateTime']);
      return aptDate.isBefore(now) || apt['status'] == 'completed';
    }).length;

    final allCount = _mockAppointments.length;

    return [
      {
        'title': localizations?.upcoming ?? 'Upcoming',
        'count': upcomingCount, // will be 0 if none
      },
      {
        'title': localizations?.past ?? 'Past',
        'count': pastCount,
      },
      {
        'title': localizations?.all ?? 'All',
        'count': allCount,
      },
    ];
  }



  List<Map<String, dynamic>> _getFilteredAppointments() {
    List<Map<String, dynamic>> filtered = List.from(_mockAppointments);
    final now = DateTime.now();

    // Filter by segment
    switch (_selectedSegment) {
      case 0: // Upcoming
        filtered =
            filtered.where((apt) {
              final aptDate = DateTime.parse(apt['dateTime']);
              return aptDate.isAfter(now) && apt['status'] != 'cancelled';
            }).toList();
        break;
      case 1: // Past
        filtered =
            filtered.where((apt) {
              final aptDate = DateTime.parse(apt['dateTime']);
              return aptDate.isBefore(now) || apt['status'] == 'completed';
            }).toList();
        break;
      // case 2 (All) - no filtering needed
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((apt) {
            final query = _searchQuery.toLowerCase();
            return (apt['doctorName'] as String).toLowerCase().contains(
                  query,
                ) ||
                (apt['specialty'] as String).toLowerCase().contains(query) ||
                (apt['notes'] as String? ?? '').toLowerCase().contains(query);
          }).toList();
    }

    // Apply filters
    if (_filters.isNotEmpty) {
      if (_filters['specialty'] != null &&
          _filters['specialty'] != 'All Specialties') {
        filtered =
            filtered
                .where((apt) => apt['specialty'] == _filters['specialty'])
                .toList();
      }

      if (_filters['type'] != null && _filters['type'] != 'All Types') {
        final filterType =
            _filters['type'] == 'In-Person' ? 'in-person' : 'telehealth';
        filtered = filtered.where((apt) => apt['type'] == filterType).toList();
      }

      if (_filters['location'] != null &&
          _filters['location'] != 'All Locations') {
        filtered =
            filtered
                .where(
                  (apt) => (apt['location'] as String).contains(
                    _filters['location'].split(' ')[0],
                  ),
                )
                .toList();
      }

      if (_filters['dateRange'] != null) {
        final DateTimeRange range = _filters['dateRange'];
        filtered =
            filtered.where((apt) {
              final aptDate = DateTime.parse(apt['dateTime']);
              return aptDate.isAfter(range.start.subtract(Duration(days: 1))) &&
                  aptDate.isBefore(range.end.add(Duration(days: 1)));
            }).toList();
      }
    }

    // Sort appointments
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['dateTime']);
      final dateB = DateTime.parse(b['dateTime']);
      return _selectedSegment == 1
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    return filtered;
  }

  void _onSegmentChanged(int index) {
    setState(() {
      _selectedSegment = index;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: 80.h,
            child: AppointmentFilterWidget(
              currentFilters: _filters,
              onFiltersChanged: (filters) {
                setState(() {
                  _filters = filters;
                });
              },
            ),
          ),
    );
  }

  Future<void> _refreshAppointments() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToBookAppointment() {
    Navigator.pushNamed(context, AppRoutes.bookAppointmentScreen);
  }

  void _onAppointmentTap(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    _showAppointmentDetails(appointment, localizations);
  }

  void _onRescheduleAppointment(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    _showRescheduleDialog(appointment, localizations);
  }

  void _onCancelAppointment(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    _showCancelDialog(appointment, localizations);
  }

  void _onAddToCalendar(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations?.appointmentAddedToCalendar ??
              'Appointment added to calendar',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _onGetDirections(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations?.openingDirections ??
              'Opening directions to ${appointment['location']}',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onViewDetails(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    _showAppointmentDetails(appointment, localizations);
  }

  void _onContactOffice(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    _showContactDialog(appointment, localizations);
  }

  void _showAppointmentDetails(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              localizations?.appointmentDetails ?? 'Appointment Details',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${localizations?.doctor ?? 'Doctor'}: ${appointment['doctorName']}',
                ),
                Text(
                  '${localizations?.specialty ?? 'Specialty'}: ${appointment['specialty']}',
                ),
                Text(
                  '${localizations?.date ?? 'Date'}: ${_formatDateTime(appointment['dateTime'])}',
                ),
                Text(
                  '${localizations?.location ?? 'Location'}: ${appointment['location']}',
                ),
                Text(
                  '${localizations?.type ?? 'Type'}: ${appointment['type']}',
                ),
                Text(
                  '${localizations?.status ?? 'Status'}: ${appointment['status']}',
                ),
                if (appointment['notes'] != null)
                  Text(
                    '${localizations?.notes ?? 'Notes'}: ${appointment['notes']}',
                  ),
              ],
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

  void _showRescheduleDialog(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              localizations?.rescheduleAppointment ?? 'Reschedule Appointment',
            ),
            content: Text(
              'Would you like to reschedule your appointment with ${appointment['doctorName']}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations?.cancel ?? 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.bookAppointmentScreen);
                },
                child: Text('Reschedule'),
              ),
            ],
          ),
    );
  }

  void _showCancelDialog(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              localizations?.cancelAppointment ?? 'Cancel Appointment',
            ),
            content: Text(
              'Are you sure you want to cancel your appointment with ${appointment['doctorName']}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  localizations?.keepAppointment ?? 'Keep Appointment',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations?.appointmentCancelledSuccessfully ??
                            'Appointment cancelled successfully',
                      ),
                      backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text(
                  localizations?.cancelAppointment ?? 'Cancel Appointment',
                ),
              ),
            ],
          ),
    );
  }

  void _showContactDialog(
    Map<String, dynamic> appointment,
    AppLocalizations? localizations,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations?.contactOffice ?? 'Contact Office'),
            content: Text(
              'How would you like to contact the office for your appointment with ${appointment['doctorName']}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations?.cancel ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations?.callingOffice ?? 'Calling office...',
                      ),
                    ),
                  );
                },
                child: Text(localizations?.call ?? 'Call'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations?.openingEmail ?? 'Opening email...',
                      ),
                    ),
                  );
                },
                child: Text(localizations?.email ?? 'Email'),
              ),
            ],
          ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeStr);
      final String date = '${dateTime.month}/${dateTime.day}/${dateTime.year}';
      final String time =
          '${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
      return '$date at $time';
    } catch (e) {
      return dateTimeStr;
    }
  }
}
