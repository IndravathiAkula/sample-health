import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/consent_screen/consent_screen.dart';
import '../presentation/main_navigation_screen/main_navigation_screen.dart';
import '../presentation/book_appointment_screen/book_appointment_screen.dart';
import '../presentation/appointment_type_selection_screen/appointment_type_selection_screen.dart';
import '../presentation/home_appointment_screen/home_appointment_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/payment_screen/payment_screen.dart';
import '../presentation/payments_history_screen/payments_history_screen.dart';
import '../presentation/appointments_list_screen/appointments_list_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String consentScreen = '/consent-screen';
  static const String mainNavigationScreen = '/main-navigation-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String bookAppointmentScreen = '/book-appointment-screen';
  static const String medicalRecordsScreen = '/medical-records-screen';
  static const String appointmentsListScreen = '/appointments-list-screen';
  static const String medicationTrackerScreen = '/medication-tracker-screen';
  static const String appointmentTypeSelectionScreen =
      '/appointment-type-selection-screen';
  static const String homeAppointmentScreen = '/home-appointment-screen';
  static const String profileScreen = '/profile-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String paymentScreen = '/payment-screen';
  static const String paymentsHistoryScreen = '/payments-history-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    consentScreen: (context) => const ConsentScreen(),
    mainNavigationScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final initialIndex = args?['initialIndex'] as int? ?? 0;
      return MainNavigationScreen(initialIndex: initialIndex);
    },
    dashboardScreen: (context) => const MainNavigationScreen(initialIndex: 0),
    appointmentsListScreen: (context) => const AppointmentsListScreen(),
    medicalRecordsScreen: (context) =>
        const MainNavigationScreen(initialIndex: 2),
    medicationTrackerScreen: (context) =>
        const MainNavigationScreen(initialIndex: 3),
    paymentsHistoryScreen: (context) => const PaymentsHistoryScreen(),
    bookAppointmentScreen: (context) => BookAppointmentScreen(),
    appointmentTypeSelectionScreen: (context) =>
        AppointmentTypeSelectionScreen(),
    homeAppointmentScreen: (context) => HomeAppointmentScreen(),
    profileScreen: (context) => const ProfileScreen(),
    notificationsScreen: (context) => const NotificationsScreen(),
    paymentScreen: (context) => const PaymentScreen(),
    // TODO: Add your other routes here
  };
}
