import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import '../appointments_list_screen/appointments_list_screen.dart';
import '../dashboard_screen/dashboard_screen.dart';
import '../medical_records_screen/medical_records_screen.dart';
import '../medication_tracker_screen/medication_tracker_screen.dart';
import '../payments_history_screen/payments_history_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int? initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = const [
    DashboardScreen(),
    AppointmentsListScreen(),
    MedicalRecordsScreen(),
    MedicationTrackerScreen(),
    PaymentsHistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null &&
        widget.initialIndex! >= 0 &&
        widget.initialIndex! < _screens.length) {
      _currentIndex = widget.initialIndex!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (index >= 0 && index < _screens.length) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onBottomNavTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
            unselectedItemColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            elevation: 0,
            selectedFontSize: 9.sp,
            unselectedFontSize: 8.sp,
            selectedLabelStyle: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
            ),
            items: [
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'dashboard',
                  color: _currentIndex == 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                label: localizations?.dashboard ?? 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'event',
                  color: _currentIndex == 1
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                label: localizations?.appointments ?? 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'folder',
                  color: _currentIndex == 2
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                label: localizations?.records ?? 'Records',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'local_pharmacy',
                  color: _currentIndex == 3
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                label: localizations?.medications ?? 'Medications',
              ),
              BottomNavigationBarItem(
                icon: CustomIconWidget(
                  iconName: 'payment',
                  color: _currentIndex == 4
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                label: localizations?.payments ?? 'Payments',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
