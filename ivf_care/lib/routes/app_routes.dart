import 'package:flutter/material.dart';
import '../presentation/payment_processing/payment_processing.dart';
import '../presentation/appointment_booking/appointment_booking.dart';
import '../presentation/medication_reminders/medication_reminders.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/medical_records/medical_records.dart';
import '../presentation/dashboard_home/dashboard_home.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String paymentProcessing = '/payment-processing';
  static const String appointmentBooking = '/appointment-booking';
  static const String medicationReminders = '/medication-reminders';
  static const String profileSettings = '/profile-settings';
  static const String medicalRecords = '/medical-records';
  static const String dashboardHome = '/dashboard-home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardHome(),
    paymentProcessing: (context) => const PaymentProcessing(),
    appointmentBooking: (context) => const AppointmentBooking(),
    medicationReminders: (context) => const MedicationReminders(),
    profileSettings: (context) => const ProfileSettings(),
    medicalRecords: (context) => const MedicalRecords(),
    dashboardHome: (context) => const DashboardHome(),
    // TODO: Add your other routes here
  };
}
