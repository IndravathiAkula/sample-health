import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('hi', 'IN'),
    Locale('te', 'IN'),
  ];

  // Common strings
  String get appTitle;
  String get languageUpdated;
  String get personalDetailsUpdated;

  // Profile Screen
  String get profile;
  String get preferredLanguage;
  String get languageApplyInstantly;
  String get languageChangedSuccessfully;
  String get languageAppWillUpdateImmediately;

  // Dashboard
  String get dashboard;
  String get quickActions;
  String get recentActivity;
  String get upcomingAppointments;
  String get healthMetrics;
  String get medicationReminders;
  String get goodMorning;
  String get dashboardRefreshedSuccessfully;

  // Bottom Navigation
  String get appointments;
  String get records;
  String get payments;
  String get medications;

  // Common buttons
  String get save;
  String get cancel;
  String get edit;
  String get delete;
  String get add;
  String get close;
  String get loading;
  String get refresh;

  // Health Metrics
  String get healthMetricsLoggingComingSoon;
  String get joiningVideoCall;
  String get openingDirections;

  // Quick Actions
  String get bookAppointment;
  String get viewLabResults;
  String get refillPrescription;
  String get emergencyContacts;
  String get emergencyFertilityContactsComingSoon;

  // Appointments Screen
  String get myAppointments;
  String get upcoming;
  String get past;
  String get all;
  String get noUpcomingAppointments;
  String get noUpcomingAppointmentsSubtitle;
  String get noPastAppointments;
  String get noPastAppointmentsSubtitle;
  String get noAppointmentsFound;
  String get noAppointmentsFoundSubtitle;
  String get scheduleAppointment;
  String get scheduleFirstAppointment;
  String get scheduleYourFirstAppointment;
  String get loadingAppointments;
  String get appointmentDetails;
  String get rescheduleAppointment;
  String get cancelAppointment;
  String get contactOffice;
  String get keepAppointment;
  String get appointmentCancelledSuccessfully;
  String get appointmentAddedToCalendar;
  String get callingOffice;
  String get openingEmail;
  String get call;
  String get email;
  String get doctor;
  String get specialty;
  String get date;
  String get location;
  String get type;
  String get status;
  String get notes;

  // Login Screen
  String get emailAddress;
  String get password;
  String get signIn;
  String get forgotPassword;
  String get newFertilityPatient;
  String get register;
  String get biometricLogin;
  String get securePatientPortal;
  String get hipaaCompliant;
  String get encryptedDataTransfer;
  String get invalidEmail;
  String get passwordTooShort;
  String get patientIdNotFound;
  String get invalidPassword;
  String get passwordRecovery;
  String get passwordRecoveryMessage;
  String get contactSupport;
  String get newPatientRegistration;
  String get newPatientRegistrationMessage;
  String get visitPortal;

  // New OTP and MRN related strings
  String get invalidMrnMobile;
  String get otpMustBeSixDigits;
  String get otpMustBeNumeric;
  String get mrnMobileNotFound;
  String get invalidOtp;
  String get otpResend;
  String get otpResendMessage;
  String get mrnMobileNumber;
  String get enterMrnMobile;
  String get otp;
  String get enterOtp;
  String get verifyOtp;
  String get verifying;
  String get resendOtpQuestion;

  // Profile Screen Details
  String get personalDetails;
  String get name;
  String get phone;
  String get dateOfBirth;
  String get emergencyContact;
  String get addressManagement;
  String get home;
  String get addNewAddress;
  String get helpAndSupport;
  String get helpCenter;
  String get contactUs;
  String get privacyPolicy;
  String get termsOfService;
  String get aboutApp;
  String get version;
  String get profilePictureEditingComingSoon;

  // Medical Records
  String get medicalRecords;
  String get labResults;
  String get prescriptions;
  String get images;
  String get reports;
  String get searchRecords;
  String get filterByDate;
  String get sortBy;
  String get noRecordsFound;
  String get noRecordsFoundSubtitle;

  // Payments
  String get paymentsHistory;
  String get paymentMethods;
  String get totalAmount;
  String get paid;
  String get pending;
  String get failed;
  String get noPaymentsFound;
  String get noPaymentsFoundSubtitle;
  String get paymentSummary;
  String get consultationFee;
  String get serviceFee;
  String get taxProcessing;
  String get insuranceCoverage;
  String get yourInsuranceCovers;
  String get ofThisAppointment;

  // Notifications
  String get notifications;
  String get markAllAsRead;
  String get clearAll;
  String get noNotifications;
  String get noNotificationsSubtitle;
  String get appointmentReminder;
  String get medicationReminder;
  String get testResults;
  String get systemUpdate;

  // Error Messages
  String get somethingWentWrong;
  String get networkError;
  String get tryAgain;
  String get noInternetConnection;

  // Success Messages
  String get success;
  String get savedSuccessfully;
  String get updatedSuccessfully;
  String get deletedSuccessfully;

  // Time and Date
  String get today;
  String get yesterday;
  String get tomorrow;
  String get thisWeek;
  String get lastWeek;
  String get thisMonth;
  String get lastMonth;
  String get morning;
  String get afternoon;
  String get evening;
  String get night;

  // Medical Terms
  String get bloodPressure;
  String get heartRate;
  String get temperature;
  String get weight;
  String get height;
  String get glucose;
  String get cholesterol;
  String get oxygenSaturation;

  // Medication Tracker specific strings
  String get medicationTracker;
  String get myMedications;
  String get medicationHistory;
  String get exportLog;
  String get settings;
  String get todaysProgress;
  String get weeklyAdherence;
  String get currentPrescriptions;
  String get todaysSchedule;
  String get viewAll;
  String get medicationMarkedAsTaken;
  String get prescriptionMarkedAsTaken;
  String get setReminder;
  String get reminderFunctionality;
  String get reminderSetSuccessfully;
  String get requestRefill;
  String get refillRequestMessage;
  String get refillRequestSent;
  String get request;
  String get prescribingDoctor;
  String get dosageInstructions;
  String get refillInformation;
  String get nextRefill;
  String get daysRemaining;
  String get editDosage;
  String get dosageChangesRequireMedical;
  String get contactDoctor;
  String get discontinueMedication;
  String get discontinueMedicationConfirm;
  String get consultDoctorBeforeDiscontinuing;
  String get insightsView;
  String get calendarView;
  String get medicationManagement;
  String get exportLogFunctionality;
  String get trackerSettings;
  String get passwordStrengthWeak;
  String get passwordStrengthFair;
  String get passwordStrengthGood;
  String get passwordStrengthStrong;
  String get passwordStrength;
  String get fullScheduleView;

  // Common UI strings
  String get viewDetails;
  String get markAsTaken;
  String get reminderSet;
  String get refillRequested;
  String get discontinueConfirm;
  String get pleaseContact;
  String get wouldOpenHere;
  String get wouldBeImplementedHere;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'te'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'hi':
        return AppLocalizationsHi();
      case 'te':
        return AppLocalizationsTe();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// English localizations
class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'Healthcare Connect';

  @override
  String get languageUpdated => 'Language updated';

  @override
  String get personalDetailsUpdated => 'Personal details updated successfully';

  @override
  String get profile => 'Profile';

  @override
  String get preferredLanguage => 'Preferred Language';

  @override
  String get languageApplyInstantly => 'Changes apply instantly across the app';

  @override
  String get languageChangedSuccessfully =>
      'Language changed successfully. The app will update immediately without restart.';

  @override
  String get languageAppWillUpdateImmediately =>
      'The app will update immediately without restart.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get healthMetrics => 'Health Metrics';

  @override
  String get medicationReminders => 'Medication Reminders';

  @override
  String get goodMorning => 'Good Morning,';

  @override
  String get dashboardRefreshedSuccessfully =>
      'Dashboard refreshed successfully';

  @override
  String get appointments => 'Appointments';

  @override
  String get records => 'Records';

  @override
  String get payments => 'Payments';

  @override
  String get medications => 'Medications';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get loading => 'Loading';

  @override
  String get refresh => 'Refresh';

  @override
  String get healthMetricsLoggingComingSoon =>
      'Health metrics logging coming soon';

  @override
  String get joiningVideoCall => 'Joining video call...';

  @override
  String get openingDirections => 'Opening directions...';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get viewLabResults => 'View Lab Results';

  @override
  String get refillPrescription => 'Refill Prescription';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get emergencyFertilityContactsComingSoon =>
      'Emergency fertility contacts feature coming soon';

  // Appointments Screen
  @override
  String get myAppointments => 'My Appointments';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get all => 'All';

  @override
  String get noUpcomingAppointments => 'No Upcoming Appointments';

  @override
  String get noUpcomingAppointmentsSubtitle =>
      'You don\'t have any upcoming appointments scheduled. Book your next appointment to stay on top of your health.';

  @override
  String get noPastAppointments => 'No Past Appointments';

  @override
  String get noPastAppointmentsSubtitle =>
      'You haven\'t had any appointments yet. Your appointment history will appear here after your visits.';

  @override
  String get noAppointmentsFound => 'No Appointments Found';

  @override
  String get noAppointmentsFoundSubtitle =>
      'Start your healthcare journey by scheduling your first appointment with one of our qualified doctors.';

  @override
  String get scheduleAppointment => 'Schedule Appointment';

  @override
  String get scheduleFirstAppointment => 'Schedule First Appointment';

  @override
  String get scheduleYourFirstAppointment => 'Schedule Your First Appointment';

  @override
  String get loadingAppointments => 'Loading appointments...';

  @override
  String get appointmentDetails => 'Appointment Details';

  @override
  String get rescheduleAppointment => 'Reschedule Appointment';

  @override
  String get cancelAppointment => 'Cancel Appointment';

  @override
  String get contactOffice => 'Contact Office';

  @override
  String get keepAppointment => 'Keep Appointment';

  @override
  String get appointmentCancelledSuccessfully =>
      'Appointment cancelled successfully';

  @override
  String get appointmentAddedToCalendar => 'Appointment added to calendar';

  @override
  String get callingOffice => 'Calling office...';

  @override
  String get openingEmail => 'Opening email...';

  @override
  String get call => 'Call';

  @override
  String get email => 'Email';

  @override
  String get doctor => 'Doctor';

  @override
  String get specialty => 'Specialty';

  @override
  String get date => 'Date';

  @override
  String get location => 'Location';

  @override
  String get type => 'Type';

  @override
  String get status => 'Status';

  @override
  String get notes => 'Notes';

  // Login Screen
  @override
  String get emailAddress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get newFertilityPatient => 'New Fertility Patient? ';

  @override
  String get register => 'Register';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get securePatientPortal => 'Secure Patient Portal';

  @override
  String get hipaaCompliant => 'HIPAA Compliant';

  @override
  String get encryptedDataTransfer => 'Encrypted Data Transfer';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get patientIdNotFound =>
      'Fertility patient ID not found. Please check your credentials or contact support.';

  @override
  String get invalidPassword =>
      'Invalid password. Please try again or reset your password.';

  @override
  String get passwordRecovery => 'Password Recovery';

  @override
  String get passwordRecoveryMessage =>
      'For security reasons, password recovery requires fertility clinic verification. Please contact your reproductive endocrinologist or call our secure support line at 1-800-FERTILITY.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get newPatientRegistration => 'New Patient Registration';

  @override
  String get newPatientRegistrationMessage =>
      'New fertility patient registration requires medical verification and insurance information. Please visit our IVF clinic registration portal or contact your reproductive endocrinologist to begin the secure enrollment process.';

  @override
  String get visitPortal => 'Visit Portal';

  // New OTP and MRN related strings
  @override
  String get invalidMrnMobile =>
      'Please enter a valid MRN (MRN12345) or 10-digit mobile number';

  @override
  String get otpMustBeSixDigits => 'OTP must be 6 digits';

  @override
  String get otpMustBeNumeric => 'OTP must contain only numbers';

  @override
  String get mrnMobileNotFound =>
      'MRN or mobile number not found. Please check your credentials or contact support.';

  @override
  String get invalidOtp =>
      'Invalid OTP. Please try again or request a new OTP.';

  @override
  String get otpResend => 'Resend OTP';

  @override
  String get otpResendMessage =>
      'A new OTP will be sent to your registered mobile number. For security reasons, OTP delivery requires verification through our healthcare system. Please contact support if you don\'t receive the OTP within 5 minutes.';

  @override
  String get mrnMobileNumber => 'MRN / Mobile Number';

  @override
  String get enterMrnMobile => 'Enter your MRN or mobile number';

  @override
  String get otp => 'OTP';

  @override
  String get enterOtp => 'Enter your OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get verifying => 'Verifying...';

  @override
  String get resendOtpQuestion => 'Resend OTP?';

  // Profile Screen Details
  @override
  String get personalDetails => 'Personal Details';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get addressManagement => 'Address Management';

  @override
  String get home => 'Home';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get profilePictureEditingComingSoon =>
      'Profile picture editing coming soon';

  // Medical Records
  @override
  String get medicalRecords => 'Medical Records';

  @override
  String get labResults => 'Lab Results';

  @override
  String get prescriptions => 'Prescriptions';

  @override
  String get images => 'Images';

  @override
  String get reports => 'Reports';

  @override
  String get searchRecords => 'Search Records';

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get sortBy => 'Sort By';

  @override
  String get noRecordsFound => 'No Records Found';

  @override
  String get noRecordsFoundSubtitle =>
      'No medical records available at this time.';

  // Payments
  @override
  String get paymentsHistory => 'Payments History';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get paid => 'Paid';

  @override
  String get pending => 'Pending';

  @override
  String get failed => 'Failed';

  @override
  String get noPaymentsFound => 'No Payments Found';

  @override
  String get noPaymentsFoundSubtitle =>
      'No payment history available at this time.';

  @override
  String get paymentSummary => 'Payment Summary';

  @override
  String get consultationFee => 'Consultation Fee';

  @override
  String get serviceFee => 'Service Fee';

  @override
  String get taxProcessing => 'Tax & Processing';

  @override
  String get insuranceCoverage => 'Insurance Coverage';

  @override
  String get yourInsuranceCovers => 'Your insurance covers';

  @override
  String get ofThisAppointment => 'of this appointment';

  // Notifications
  @override
  String get notifications => 'Notifications';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get noNotificationsSubtitle =>
      'You\'ll see notifications here when they arrive.';

  @override
  String get appointmentReminder => 'Appointment Reminder';

  @override
  String get medicationReminder => 'Medication Reminder';

  @override
  String get testResults => 'Test Results';

  @override
  String get systemUpdate => 'System Update';

  // Error Messages
  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get networkError => 'Network error occurred';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noInternetConnection => 'No internet connection';

  // Success Messages
  @override
  String get success => 'Success';

  @override
  String get savedSuccessfully => 'Saved successfully';

  @override
  String get updatedSuccessfully => 'Updated successfully';

  @override
  String get deletedSuccessfully => 'Deleted successfully';

  // Time and Date
  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get thisWeek => 'This Week';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get night => 'Night';

  // Medical Terms
  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get temperature => 'Temperature';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get glucose => 'Glucose';

  @override
  String get cholesterol => 'Cholesterol';

  @override
  String get oxygenSaturation => 'Oxygen Saturation';

  // Medication Tracker specific strings
  @override
  String get medicationTracker => 'Medication Tracker';

  @override
  String get myMedications => 'My Medications';

  @override
  String get medicationHistory => 'Medication History';

  @override
  String get exportLog => 'Export Log';

  @override
  String get settings => 'Settings';

  @override
  String get todaysProgress => 'Today\'s Progress';

  @override
  String get weeklyAdherence => 'Weekly Adherence';

  @override
  String get currentPrescriptions => 'Current Prescriptions';

  @override
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get viewAll => 'View All';

  @override
  String get medicationMarkedAsTaken => 'Medication marked as taken';

  @override
  String get prescriptionMarkedAsTaken => 'Prescription marked as taken';

  @override
  String get setReminder => 'Set Reminder';

  @override
  String get reminderFunctionality =>
      'Reminder functionality would be implemented here with notification scheduling.';

  @override
  String get reminderSetSuccessfully => 'Reminder set successfully';

  @override
  String get requestRefill => 'Request Refill';

  @override
  String get refillRequestMessage =>
      'Refill request would be sent to your pharmacy and healthcare provider.';

  @override
  String get refillRequestSent => 'Refill request sent';

  @override
  String get request => 'Request';

  @override
  String get prescribingDoctor => 'Prescribing Doctor';

  @override
  String get dosageInstructions => 'Dosage Instructions';

  @override
  String get refillInformation => 'Refill Information';

  @override
  String get nextRefill => 'Next Refill';

  @override
  String get daysRemaining => 'Days Remaining';

  @override
  String get editDosage => 'Edit Dosage';

  @override
  String get dosageChangesRequireMedical =>
      'Dosage changes require medical confirmation. Please consult with your healthcare provider.';

  @override
  String get contactDoctor => 'Contact Doctor';

  @override
  String get discontinueMedication => 'Discontinue Medication';

  @override
  String get discontinueMedicationConfirm =>
      'Are you sure you want to discontinue this medication? This action requires medical confirmation.';

  @override
  String get consultDoctorBeforeDiscontinuing =>
      'Please consult your doctor before discontinuing';

  @override
  String get insightsView => 'Insights view would open here';

  @override
  String get calendarView => 'Calendar view would open here';

  @override
  String get medicationManagement =>
      'Medication management is handled by your healthcare provider';

  @override
  String get exportLogFunctionality =>
      'Export log functionality would be implemented here';

  @override
  String get trackerSettings => 'Tracker settings would open here';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthFair => 'Fair';

  @override
  String get passwordStrengthGood => 'Good';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordStrength => 'Password Strength';

  @override
  String get fullScheduleView =>
      'Full medication schedule view would open here';

  // Common UI strings
  @override
  String get viewDetails => 'View Details';

  @override
  String get markAsTaken => 'Mark as Taken';

  @override
  String get reminderSet => 'Reminder Set';

  @override
  String get refillRequested => 'Refill Requested';

  @override
  String get discontinueConfirm => 'Discontinue Confirmation';

  @override
  String get pleaseContact => 'Please contact';

  @override
  String get wouldOpenHere => 'would open here';

  @override
  String get wouldBeImplementedHere => 'would be implemented here';
}

// Hindi localizations
class AppLocalizationsHi extends AppLocalizations {
  @override
  String get appTitle => 'हेल्थकेयर कनेक्ट';

  @override
  String get languageUpdated => 'भाषा अपडेट की गई';

  @override
  String get personalDetailsUpdated =>
      'व्यक्तिगत विवरण सफलतापूर्वक अपडेट किया गया';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get preferredLanguage => 'पसंदीदा भाषा';

  @override
  String get languageApplyInstantly =>
      'परिवर्तन तुरंत पूरे ऐप में लागू होते हैं';

  @override
  String get languageChangedSuccessfully =>
      'भाषा सफलतापूर्वक बदली गई। ऐप बिना रीस्टार्ट के तुरंत अपडेट हो जाएगा।';

  @override
  String get languageAppWillUpdateImmediately =>
      'ऐप बिना रीस्टार्ट के तुरंत अपडेट हो जाएगा।';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get quickActions => 'त्वरित क्रियाएं';

  @override
  String get recentActivity => 'हाल की गतिविधि';

  @override
  String get upcomingAppointments => 'आगामी अपॉइंटमेंट';

  @override
  String get healthMetrics => 'स्वास्थ्य मेट्रिक्स';

  @override
  String get medicationReminders => 'दवा रिमाइंडर';

  @override
  String get goodMorning => 'शुभ प्रभात,';

  @override
  String get dashboardRefreshedSuccessfully =>
      'डैशबोर्ड सफलतापूर्वक रिफ्रेश किया गया';

  @override
  String get appointments => 'अपॉइंटमेंट';

  @override
  String get records => 'रिकॉर्ड';

  @override
  String get payments => 'भुगतान';

  @override
  String get medications => 'दवाएं';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get add => 'जोड़ें';

  @override
  String get close => 'बंद करें';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get refresh => 'रिफ्रेश करें';

  @override
  String get healthMetricsLoggingComingSoon =>
      'स्वास्थ्य मेट्रिक्स लॉगिंग जल्द आ रहा है';

  @override
  String get joiningVideoCall => 'वीडियो कॉल में शामिल हो रहे हैं...';

  @override
  String get openingDirections => 'दिशा-निर्देश खोले जा रहे हैं...';

  @override
  String get bookAppointment => 'अपॉइंटमेंट बुक करें';

  @override
  String get viewLabResults => 'लैब परिणाम देखें';

  @override
  String get refillPrescription => 'प्रिस्क्रिप्शन रिफिल करें';

  @override
  String get emergencyContacts => 'आपातकालीन संपर्क';

  @override
  String get emergencyFertilityContactsComingSoon =>
      'आपातकालीन प्रजनन संपर्क सुविधा जल्द आ रहा है';

  // Appointments Screen
  @override
  String get myAppointments => 'मेरे अपॉइंटमेंट';

  @override
  String get upcoming => 'आगामी';

  @override
  String get past => 'पुराने';

  @override
  String get all => 'सभी';

  @override
  String get noUpcomingAppointments => 'कोई आगामी अपॉइंटमेंट नहीं';

  @override
  String get noUpcomingAppointmentsSubtitle =>
      'आपका कोई आगामी अपॉइंटमेंट नहीं है। अपने स्वास्थ्य का ध्यान रखने के लिए अपना अगला अपॉइंटमेंट बुक करें।';

  @override
  String get noPastAppointments => 'कोई पुराना अपॉइंटमेंट नहीं';

  @override
  String get noPastAppointmentsSubtitle =>
      'अभी तक आपका कोई अपॉइंटमेंट नहीं हुआ है। आपके विजिट के बाद आपका अपॉइंटमेंट इतिहास यहाँ दिखाई देगा।';

  @override
  String get noAppointmentsFound => 'कोई अपॉइंटमेंट नहीं मिला';

  @override
  String get noAppointmentsFoundSubtitle =>
      'हमारे योग्य डॉक्टरों के साथ अपना पहला अपॉइंटमेंट शेड्यूल करके अपनी स्वास्थ्य यात्रा शुरू करें।';

  @override
  String get scheduleAppointment => 'अपॉइंटमेंट शेड्यूल करें';

  @override
  String get scheduleFirstAppointment => 'पहला अपॉइंटमेंट शेड्यूल करें';

  @override
  String get scheduleYourFirstAppointment =>
      'अपना पहला अपॉइंटमेंट शेड्यूल करें';

  @override
  String get loadingAppointments => 'अपॉइंटमेंट लोड हो रहे हैं...';

  @override
  String get appointmentDetails => 'अपॉइंटमेंट विवरण';

  @override
  String get rescheduleAppointment => 'अपॉइंटमेंट रीशेड्यूल करें';

  @override
  String get cancelAppointment => 'अपॉइंटमेंट रद्द करें';

  @override
  String get contactOffice => 'ऑफिस से संपर्क करें';

  @override
  String get keepAppointment => 'अपॉइंटमेंट रखें';

  @override
  String get appointmentCancelledSuccessfully =>
      'अपॉइंटमेंट सफलतापूर्वक रद्द किया गया';

  @override
  String get appointmentAddedToCalendar => 'अपॉइंटमेंट कैलेंडर में जोड़ा गया';

  @override
  String get callingOffice => 'ऑफिस को कॉल कर रहे हैं...';

  @override
  String get openingEmail => 'ईमेल खोला जा रहा है...';

  @override
  String get call => 'कॉल करें';

  @override
  String get email => 'ईमेल';

  @override
  String get doctor => 'डॉक्टर';

  @override
  String get specialty => 'विशेषता';

  @override
  String get date => 'दिनांक';

  @override
  String get location => 'स्थान';

  @override
  String get type => 'प्रकार';

  @override
  String get status => 'स्थिति';

  @override
  String get notes => 'नोट्स';

  // Login Screen
  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get password => 'पासवर्ड';

  @override
  String get signIn => 'साइन इन';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get newFertilityPatient => 'नए प्रजनन मरीज़? ';

  @override
  String get register => 'रजिस्टर करें';

  @override
  String get biometricLogin => 'बायोमेट्रिक लॉगिन';

  @override
  String get securePatientPortal => 'सुरक्षित मरीज़ पोर्टल';

  @override
  String get hipaaCompliant => 'HIPAA अनुपालित';

  @override
  String get encryptedDataTransfer => 'एन्क्रिप्टेड डेटा ट्रांसफर';

  @override
  String get invalidEmail => 'कृपया एक वैध ईमेल पता दर्ज करें';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get patientIdNotFound =>
      'प्रजनन मरीज़ ID नहीं मिली। कृपया अपनी साख जांचें या सहायता से संपर्क करें।';

  @override
  String get invalidPassword =>
      'गलत पासवर्ड। कृपया फिर से कोशिश करें या अपना पासवर्ड रीसेट करें।';

  @override
  String get passwordRecovery => 'पासवर्ड रिकवरी';

  @override
  String get passwordRecoveryMessage =>
      'सुरक्षा कारणों से, पासवर्ड रिकवरी के लिए प्रजनन क्लिनिक सत्यापन आवश्यक है। कृपया अपने प्रजनन एंडोक्रिनोलॉजिस्ट से संपर्क करें या हमारी सुरक्षित सहायता लाइन 1-800-FERTILITY पर कॉल करें।';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get newPatientRegistration => 'नए मरीज़ का पंजीकरण';

  @override
  String get newPatientRegistrationMessage =>
      'नए प्रजनन मरीज़ पंजीकरण के लिए चिकित्सा सत्यापन और बीमा जानकारी की आवश्यकता है। कृपया हमारे IVF क्लिनिक पंजीकरण पोर्टल पर जाएं या सुरक्षित पंजीकरण प्रक्रिया शुरू करने के लिए अपने प्रजनन एंडोक्रिनोलॉजिस्ट से संपर्क करें।';

  @override
  String get visitPortal => 'पोर्टल पर जाएं';

  // New OTP and MRN related strings
  @override
  String get invalidMrnMobile =>
      'कृपया एक वैध MRN (MRN12345) या 10-अंकीय मोबाइल नंबर दर्ज करें';

  @override
  String get otpMustBeSixDigits => 'OTP 6 अंकों का होना चाहिए';

  @override
  String get otpMustBeNumeric => 'OTP में केवल संख्याएं होनी चाहिए';

  @override
  String get mrnMobileNotFound =>
      'MRN या मोबाइल नंबर नहीं मिला। कृपया अपनी साख जांचें या सहायता से संपर्क करें।';

  @override
  String get invalidOtp =>
      'गलत OTP। कृपया फिर से कोशिश करें या नया OTP मांगें।';

  @override
  String get otpResend => 'OTP फिर से भेजें';

  @override
  String get otpResendMessage =>
      'आपके पंजीकृत मोबाइल नंबर पर एक नया OTP भेजा जाएगा। सुरक्षा कारणों से, OTP डिलीवरी के लिए हमारे स्वास्थ्य प्रणाली के माध्यम से सत्यापन आवश्यक है। यदि आपको 5 मिनट के भीतर OTP नहीं मिलता है तो कृपया सहायता से संपर्क करें।';

  @override
  String get mrnMobileNumber => 'MRN / मोबाइल नंबर';

  @override
  String get enterMrnMobile => 'अपना MRN या मोबाइल नंबर दर्ज करें';

  @override
  String get otp => 'OTP';

  @override
  String get enterOtp => 'अपना OTP दर्ज करें';

  @override
  String get verifyOtp => 'OTP सत्यापित करें';

  @override
  String get verifying => 'सत्यापन कर रहे हैं...';

  @override
  String get resendOtpQuestion => 'OTP फिर से भेजें?';

  // Profile Screen Details
  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get name => 'नाम';

  @override
  String get phone => 'फोन';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get emergencyContact => 'आपातकालीन संपर्क';

  @override
  String get addressManagement => 'पता प्रबंधन';

  @override
  String get home => 'घर';

  @override
  String get addNewAddress => 'नया पता जोड़ें';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get helpCenter => 'सहायता केंद्र';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get version => 'संस्करण';

  @override
  String get profilePictureEditingComingSoon =>
      'प्रोफाइल फोटो एडिटिंग जल्द आ रहा है';

  // Medical Records
  @override
  String get medicalRecords => 'मेडिकल रिकॉर्ड';

  @override
  String get labResults => 'लैब परिणाम';

  @override
  String get prescriptions => 'प्रिस्क्रिप्शन';

  @override
  String get images => 'छवियां';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get searchRecords => 'रिकॉर्ड खोजें';

  @override
  String get filterByDate => 'दिनांक के अनुसार फिल्टर करें';

  @override
  String get sortBy => 'द्वारा क्रमबद्ध करें';

  @override
  String get noRecordsFound => 'कोई रिकॉर्ड नहीं मिला';

  @override
  String get noRecordsFoundSubtitle =>
      'इस समय आपका कोई मेडिकल रिकॉर्ड उपलब्ध नहीं है।';

  // Payments
  @override
  String get paymentsHistory => 'भुगतान इतिहास';

  @override
  String get paymentMethods => 'भुगतान के तरीके';

  @override
  String get totalAmount => 'कुल राशि';

  @override
  String get paid => 'भुगतान किया गया';

  @override
  String get pending => 'लंबित';

  @override
  String get failed => 'असफल';

  @override
  String get noPaymentsFound => 'कोई भुगतान नहीं मिला';

  @override
  String get noPaymentsFoundSubtitle =>
      'इस समय आपका कोई भुगतान इतिहास उपलब्ध नहीं है।';

  @override
  String get paymentSummary => 'भुगतान सारांश';

  @override
  String get consultationFee => 'परामर्श शुल्क';

  @override
  String get serviceFee => 'सेवा शुल्क';

  @override
  String get taxProcessing => 'कर और प्रसंस्करण';

  @override
  String get insuranceCoverage => 'बीमा कवरेज';

  @override
  String get yourInsuranceCovers => 'आपका बीमा कवर करता है';

  @override
  String get ofThisAppointment => 'इस अपॉइंटमेंट का';

  // Notifications
  @override
  String get notifications => 'सूचनाएं';

  @override
  String get markAllAsRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get clearAll => 'सभी साफ़ करें';

  @override
  String get noNotifications => 'कोई सूचना नहीं';

  @override
  String get noNotificationsSubtitle =>
      'जब सूचनाएं आएंगी तो आप उन्हें यहाँ देखेंगे।';

  @override
  String get appointmentReminder => 'अपॉइंटमेंट रिमाइंडर';

  @override
  String get medicationReminder => 'दवा रिमाइंडर';

  @override
  String get testResults => 'टेस्ट परिणाम';

  @override
  String get systemUpdate => 'सिस्टम अपडेट';

  // Error Messages
  @override
  String get somethingWentWrong => 'कुछ गलत हुआ';

  @override
  String get networkError => 'नेटवर्क त्रुटि हुई';

  @override
  String get tryAgain => 'फिर से कोशिश करें';

  @override
  String get noInternetConnection => 'कोई इंटरनेट कनेक्शन नहीं';

  // Success Messages
  @override
  String get success => 'सफलता';

  @override
  String get savedSuccessfully => 'सफलतापूर्वक सेव किया गया';

  @override
  String get updatedSuccessfully => 'सफलतापूर्वक अपडेट किया गया';

  @override
  String get deletedSuccessfully => 'सफलतापूर्वक डिलीट किया गया';

  // Time and Date
  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get tomorrow => 'कल';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get lastWeek => 'पिछला सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get lastMonth => 'पिछला महीना';

  @override
  String get morning => 'सुबह';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get evening => 'शाम';

  @override
  String get night => 'रात';

  // Medical Terms
  @override
  String get bloodPressure => 'रक्तचाप';

  @override
  String get heartRate => 'हृदय गति';

  @override
  String get temperature => 'तापमान';

  @override
  String get weight => 'वजन';

  @override
  String get height => 'ऊंचाई';

  @override
  String get glucose => 'ग्लूकोज';

  @override
  String get cholesterol => 'कोलेस्ट्रोल';

  @override
  String get oxygenSaturation => 'ऑक्सीजन संतृप्तता';

  // Medication Tracker specific strings
  @override
  String get medicationTracker => 'दवा ट्रैकर';

  @override
  String get myMedications => 'मेरी दवाएं';

  @override
  String get medicationHistory => 'दवा इतिहास';

  @override
  String get exportLog => 'लॉग निर्यात करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get todaysProgress => 'आज की प्रगति';

  @override
  String get weeklyAdherence => 'साप्ताहिक पालन';

  @override
  String get currentPrescriptions => 'वर्तमान प्रिस्क्रिप्शन';

  @override
  String get todaysSchedule => 'आज का शेड्यूल';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get medicationMarkedAsTaken =>
      'दवा को लिया गया के रूप में चिह्नित किया';

  @override
  String get prescriptionMarkedAsTaken =>
      'प्रिस्क्रिप्शन को लिया गया के रूप में चिह्नित किया';

  @override
  String get setReminder => 'रिमाइंडर सेट करें';

  @override
  String get reminderFunctionality =>
      'रिमाइंडर कार्यक्षमता इक्कड नोटिफिकेशन शेड्यूलिंग के साथ अमलु चेयबडुतुंदिं।';

  @override
  String get reminderSetSuccessfully => 'रिमाइंडर सफलतापूर्वक सेट किया गया';

  @override
  String get requestRefill => 'रिफिल का अनुरोध करें';

  @override
  String get refillRequestMessage =>
      'रिफिल का अनुरोध आपकी फार्मेसी और स्वास्थ्य सेवा प्रदाता को भेजा जाएगा।';

  @override
  String get refillRequestSent => 'रिफिल का अनुरोध भेजा गया';

  @override
  String get request => 'अनुरोध';

  @override
  String get prescribingDoctor => 'निर्धारित करने वाले डॉक्टर';

  @override
  String get dosageInstructions => 'खुराक निर्देश';

  @override
  String get refillInformation => 'रिफिल जानकारी';

  @override
  String get nextRefill => 'अगला रिफिल';

  @override
  String get daysRemaining => 'बचे दिन';

  @override
  String get editDosage => 'खुराक संपादित करें';

  @override
  String get dosageChangesRequireMedical =>
      'खुराक में बदलाव के लिए चिकित्सा पुष्टि की आवश्यकता है। कृपया अपने स्वास्थ्य सेवा प्रदाता से परामर्श करें।';

  @override
  String get contactDoctor => 'डॉक्टर से संपर्क करें';

  @override
  String get discontinueMedication => 'दवा बंद करें';

  @override
  String get discontinueMedicationConfirm =>
      'क्या आप वाकई इस दवा को बंद करना चाहते हैं? इस कार्य के लिए चिकित्सा पुष्टि की आवश्यकता है।';

  @override
  String get consultDoctorBeforeDiscontinuing =>
      'बंद करने से पहले कृपया अपने डॉक्टर से सलाह लें';

  @override
  String get insightsView => 'अंतर्दृष्टि दृश्य इक्कड खुलेगा';

  @override
  String get calendarView => 'कैलेंडर दृश्य इक्कड खुलेगा';

  @override
  String get medicationManagement =>
      'दवा प्रबंधन आपके स्वास्थ्य सेवा प्रदाता द्वारा संभाला जाता है';

  @override
  String get exportLogFunctionality =>
      'लॉग निर्यात कार्यक्षमता इक्कड अमलु चेयबडुतुंदिं';

  @override
  String get trackerSettings => 'ट्रैकर सेटिंग्स इक्कड खुलेंगी';

  @override
  String get passwordStrengthWeak => 'कमजोर';

  @override
  String get passwordStrengthFair => 'ठीक';

  @override
  String get passwordStrengthGood => 'अच्छा';

  @override
  String get passwordStrengthStrong => 'मजबूत';

  @override
  String get passwordStrength => 'पासवर्ड की ताकत';

  @override
  String get fullScheduleView => 'पूरा दवा शेड्यूल दृश्य इक्कड खुलेगा';

  // Common UI strings
  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get markAsTaken => 'लिया गया के रूप में चिह्नित करें';

  @override
  String get reminderSet => 'रिमाइंडर सेट किया गया';

  @override
  String get refillRequested => 'रिफिल का अनुरोध किया गया';

  @override
  String get discontinueConfirm => 'बंद करने की पुष्टि';

  @override
  String get pleaseContact => 'कृपया संपर्क करें';

  @override
  String get wouldOpenHere => 'इक्कड खुलेगा';

  @override
  String get wouldBeImplementedHere => 'इक्कड अमलु चेयबडुतुंदिं';
}

// Telugu localizations
class AppLocalizationsTe extends AppLocalizations {
  @override
  String get appTitle => 'హెల్త్‌కేర్ కనెక్ట్';

  @override
  String get languageUpdated => 'భాష అప్‌డేట్ చేయబడింది';

  @override
  String get personalDetailsUpdated =>
      'వ్యక్తిగత వివరాలు విజయవంతంగా అప్‌డేట్ చేయబడ్డాయి';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get preferredLanguage => 'ప్రాధాన్య భాష';

  @override
  String get languageApplyInstantly => 'మార్పులు వెంటనే యాప్ అంతటా వర్తిస్తాయి';

  @override
  String get languageChangedSuccessfully =>
      'భాష విజయవంతంగా మార్చబడింది. యాప్ రీస్టార్ట్ లేకుండా వెంటనే అప్‌డేట్ అవుతుంది.';

  @override
  String get languageAppWillUpdateImmediately =>
      'యాప్ రీస్టార్ట్ లేకుండా వెంటనే అప్‌డేట్ అవుతుంది.';

  @override
  String get dashboard => 'డ్యాష్‌బోర్డ్';

  @override
  String get quickActions => 'త్వరిత చర్యలు';

  @override
  String get recentActivity => 'ఇటీవలి కార్యకలాపాలు';

  @override
  String get upcomingAppointments => 'రాబోయే అపాయింట్‌మెంట్‌లు';

  @override
  String get healthMetrics => 'ఆరోగ్య కొలమానలు';

  @override
  String get medicationReminders => 'మందుల రిమైండర్‌లు';

  @override
  String get goodMorning => 'శుభోదయం,';

  @override
  String get dashboardRefreshedSuccessfully =>
      'డ్యాష్‌బోర్డ్ విజయవంతంగా రిఫ్రెష్ చేయబడింది';

  @override
  String get appointments => 'అపాయింట్‌మెంట్‌లు';

  @override
  String get records => 'రికార్డ్‌లు';

  @override
  String get payments => 'చెల్లింపులు';

  @override
  String get medications => 'మందులు';

  @override
  String get save => 'సేవ్ చేయండి';

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get edit => 'ఎడిట్ చేయండి';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get add => 'జోడించండి';

  @override
  String get close => 'మూసివేయండి';

  @override
  String get loading => 'లోడ్ అవుతోంది';

  @override
  String get refresh => 'రిఫ్రెష్ చేయండి';

  @override
  String get healthMetricsLoggingComingSoon =>
      'ఆరోగ్య కొలమానల లాగింగ్ త్వరలో వస్తుంది';

  @override
  String get joiningVideoCall => 'వీడియో కాల్‌లో చేరుతోంది...';

  @override
  String get openingDirections => 'దిశలను తెరుస్తోంది...';

  @override
  String get bookAppointment => 'అపాయింట్ బుక్ చేయండి';

  @override
  String get viewLabResults => 'ల్యాబ్ ఫలితాలను చూడండి';

  @override
  String get refillPrescription => 'ప్రిస్క్రిప్షన్ రీఫిల్ చేయండి';

  @override
  String get emergencyContacts => 'అత్యవసర పరిచయాలు';

  @override
  String get emergencyFertilityContactsComingSoon =>
      'అత్యవసర సంతానోత్పత్తి సంపర్కాల లక్షణం త్వరలో వస్తుంది';

  // Appointments Screen
  @override
  String get myAppointments => 'నా అపాయింట్‌మెంట్‌లు';

  @override
  String get upcoming => 'రాబోయేవి';

  @override
  String get past => 'గతంలోవి';

  @override
  String get all => 'అన్నీ';

  @override
  String get noUpcomingAppointments => 'రాబోయే అపాయింట్‌మెంట్‌లు లేవు';

  @override
  String get noUpcomingAppointmentsSubtitle =>
      'మీకు షెడ్యూల్ చేసిన రాబోయే అపాయింట్‌మెంట్‌లు లేవు. మీ ఆరోగ్యం మీద దృష్టి ఉంచడానికి మీ తదుపరి అపాయింట్ బుక్ చేయండి.';

  @override
  String get noPastAppointments => 'గత అపాయింట్‌మెంట్‌లు లేవు';

  @override
  String get noPastAppointmentsSubtitle =>
      'మీకు ఇంకా ఎలాంటి అపాయింట్‌మెంట్‌లు లేవు. మీ సందర్శనల తర్వాత మీ అపాయింట్‌మెంట్ చరిత్ర ఇక్కడ కనిపిస్తుంది.';

  @override
  String get noAppointmentsFound => 'అపాయింట్‌మెంట్‌లు కనుగొనబడలేదు';

  @override
  String get noAppointmentsFoundSubtitle =>
      'మా అర్హత కలిగిన వైద్యులతో మీ మొదటి అపాయింట్ షెడ్యూల్ చేయడం ద్వారా మీ ఆరోగ్య యాత్రను ప్రారంభించండి.';

  @override
  String get scheduleAppointment => 'అపాయింట్‌మెంట్ షెడ్యూల్ చేయండి';

  @override
  String get scheduleFirstAppointment => 'మొదటి అపాయింట్‌మెంట్ షెడ్యూల్ చేయండి';

  @override
  String get scheduleYourFirstAppointment =>
      'మీ మొదటి అపాయింట్‌మెంట్ షెడ్యూల్ చేయండి';

  @override
  String get loadingAppointments => 'అపాయింట్‌మెంట్‌లు లోడ్ అవుతున్నాయి...';

  @override
  String get appointmentDetails => 'అపాయింట్‌మెంట్ వివరాలు';

  @override
  String get rescheduleAppointment => 'అపాయింట్‌మెంట్ రీషెడ్యూల్ చేయండి';

  @override
  String get cancelAppointment => 'అపాయింట్‌మెంట్ రద్దు చేయండి';

  @override
  String get contactOffice => 'ఆఫీసు సంప్రదించండి';

  @override
  String get keepAppointment => 'అపాయింట్‌మెంట్ ఉంచండి';

  @override
  String get appointmentCancelledSuccessfully =>
      'అపాయింట్‌మెంట్ విజయవంతంగా రద్దు చేయబడింది';

  @override
  String get appointmentAddedToCalendar =>
      'అపాయింట్‌మెంట్ క్యాలెండర్‌కు జోడించబడింది';

  @override
  String get callingOffice => 'ఆఫీసుకు కాల్ చేస్తోంది...';

  @override
  String get openingEmail => 'ఇమెయిల్ తెరుస్తోంది...';

  @override
  String get call => 'కాల్ చేయండి';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get doctor => 'డాక్టర్';

  @override
  String get specialty => 'ప్రత్యేకత';

  @override
  String get date => 'తేదీ';

  @override
  String get location => 'స్థానం';

  @override
  String get type => 'రకం';

  @override
  String get status => 'స్థితి';

  @override
  String get notes => 'గమనికలు';

  // Login Screen
  @override
  String get emailAddress => 'ఇమెయిల్ చిరునామా';

  @override
  String get password => 'పాస్వర్డ్';

  @override
  String get signIn => 'సైన్ ఇన్';

  @override
  String get forgotPassword => 'పాస్వర్డ్ మర్చిపోయారా?';

  @override
  String get newFertilityPatient => 'కొత్త సంతానోత్పత్తి రోగి? ';

  @override
  String get register => 'నమోదు చేయండి';

  @override
  String get biometricLogin => 'బయోమెట్రిక్ లాగిన్';

  @override
  String get securePatientPortal => 'సురక్షిత రోగి పోర్టల్';

  @override
  String get hipaaCompliant => 'HIPAA అనుకూలత';

  @override
  String get encryptedDataTransfer => 'ఎన్క్రిప్టెడ్ డేటా బదిలీ';

  @override
  String get invalidEmail =>
      'దయచేసి చెల్లుబాటు అయ్యే ఇమెయిల్ చిరునామాను నమోదు చేయండి';

  @override
  String get passwordTooShort => 'పాస్వర్డ్ కనీసం 6 అక్షరాలు ఉండాలి';

  @override
  String get patientIdNotFound =>
      'సంతానోత్పత్తి రోగి ID కనుగొనబడలేదు. దయచేసి మీ ప్రమాణాలను తనిఖీ చేయండి లేదా మద్దతును సంప్రదించండి.';

  @override
  String get invalidPassword =>
      'చెల్లని పాస్వర్డ్. దయచేసి మళ్లీ ప్రయత్నించండి లేదా మీ పాస్వర్డ్‌ను రీసెట్ చేయండి.';

  @override
  String get passwordRecovery => 'పాస్వర్డ్ పునరుద్ధరణ';

  @override
  String get passwordRecoveryMessage =>
      'భద్రతా కారణాల వల్ల, పాస్వర్డ్ పునరుద్ధరణకు సంతానోత్పత్తి క్లినిక్ ధృవీకరణ అవసరం. దయచేసి మీ రిప్రొడక్టివ్ ఎండోక్రినోలజిస్ట్‌ను సంప్రదించండి లేదా మా సురక్షిత మద్దతు లైన్ 1-800-FERTILITY కు కాల్ చేయండి.';

  @override
  String get contactSupport => 'మద్దతును సంప్రదించండి';

  @override
  String get newPatientRegistration => 'కొత్త రోగి నమోదు';

  @override
  String get newPatientRegistrationMessage =>
      'కొత్త సంతానోత్పత్తి రోగి నమోదుకు వైద్య ధృవీకరణ మరియు భీమా సమాచారం అవసరం. దయచేసి మా IVF క్లినిక్ నమోదు పోర్టల్‌ను సందర్శించండి లేదా సురక్షిత నమోదు ప్రక్రియను ప్రారంభించడానికి మీ రిప్రొడక్టివ్ ఎండోక్రినోలజిస్ట్‌ను సంప్రదించండి.';

  @override
  String get visitPortal => 'పోర్టల్‌ను సందర్శించండి';

  // New OTP and MRN related strings
  @override
  String get invalidMrnMobile =>
      'దయచేసి చెల్లుబాటు అయ్యే MRN (MRN12345) లేదా 10-అంకెల మొబైల్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get otpMustBeSixDigits => 'OTP 6 అంకెలు ఉండాలి';

  @override
  String get otpMustBeNumeric => 'OTP లో సంఖ్యలు మాత్రమే ఉండాలి';

  @override
  String get mrnMobileNotFound =>
      'MRN లేదా మొబైల్ నంబర్ కనుగొనబడలేదు. దయచేసి మీ ప్రమాణాలను తనిఖీ చేయండి లేదా మద్దతును సంప్రదించండి.';

  @override
  String get invalidOtp =>
      'చెల్లని OTP. దయచేసి మళ్లీ ప్రయత్నించండి లేదా కొత్త OTP అభ్యర్థించండి.';

  @override
  String get otpResend => 'OTP మళ్లీ పంపండి';

  @override
  String get otpResendMessage =>
      'మీ నమోదిత మొబైల్ నంబర్‌కు కొత్త OTP పంపబడుతుంది. భద్రతా కారణాల వల్ల, OTP డెలీవరీకి మా ఆరోగ్య వ్యవస్థ ద్వారా ధృవీకరణ అవసరం. మీకు 5 నిమిషాలలో OTP అందకపోతే దయచేసి మద్దతును సంప్రదించండి.';

  @override
  String get mrnMobileNumber => 'MRN / మొబైల్ నంబర్';

  @override
  String get enterMrnMobile => 'మీ MRN లేదా మొబైల్ నంబర్‌ను నమోదు చేయండి';

  @override
  String get otp => 'OTP';

  @override
  String get enterOtp => 'మీ OTP నమోదు చేయండి';

  @override
  String get verifyOtp => 'OTP ధృవీకరించండి';

  @override
  String get verifying => 'ధృవీకరిస్తోంది...';

  @override
  String get resendOtpQuestion => 'OTP మళ్లీ పంపాలా?';

  // Profile Screen Details
  @override
  String get personalDetails => 'వ్యక్తిగత వివరాలు';

  @override
  String get name => 'పేరు';

  @override
  String get phone => 'ఫోన్';

  @override
  String get dateOfBirth => 'పుట్టిన తేదీ';

  @override
  String get emergencyContact => 'అత్యవసర సంపర్కం';

  @override
  String get addressManagement => 'చిరునామా నిర్వహణ';

  @override
  String get home => 'ఇల్లు';

  @override
  String get addNewAddress => 'కొత్త చిరునామా జోడించండి';

  @override
  String get helpAndSupport => 'సహాయం మరియు మద్దతు';

  @override
  String get helpCenter => 'సహాయ కేంద్రం';

  @override
  String get contactUs => 'మాను సంప్రదించండి';

  @override
  String get privacyPolicy => 'గోప్యతా విధానం';

  @override
  String get termsOfService => 'సేవా నిబంధనలు';

  @override
  String get aboutApp => 'యాప్ గురించి';

  @override
  String get version => 'సంస్కరణ';

  @override
  String get profilePictureEditingComingSoon =>
      'ప్రొఫైల్ చిత్రం ఎడిటింగ్ త్వరలో వస్తుంది';

  // Medical Records
  @override
  String get medicalRecords => 'వైద్య రికార్డులు';

  @override
  String get labResults => 'ల్యాబ్ ఫలితాలు';

  @override
  String get prescriptions => 'ప్రిస్క్రిప్షన్లు';

  @override
  String get images => 'చిత్రాలు';

  @override
  String get reports => 'నివేదికలు';

  @override
  String get searchRecords => 'రికార్డులను వెతకండి';

  @override
  String get filterByDate => 'తేదీ ద్వారా ఫిల్టర్ చేయండి';

  @override
  String get sortBy => 'దీని ద్వారా క్రమబద్ధీకరించండి';

  @override
  String get noRecordsFound => 'రికార్డులు కనుగొనబడలేదు';

  @override
  String get noRecordsFoundSubtitle =>
      'ఈ సమయంలో వైద్య రికార్డులు అందుబాటులో లేవు.';

  // Payments
  @override
  String get paymentsHistory => 'చెల్లింపుల చరిత్ర';

  @override
  String get paymentMethods => 'చెల్లింపు పద్ధతులు';

  @override
  String get totalAmount => 'మొత్తం మొత్తం';

  @override
  String get paid => 'చెల్లించబడింది';

  @override
  String get pending => 'వేచి ఉంది';

  @override
  String get failed => 'విఫలమైంది';

  @override
  String get noPaymentsFound => 'చెల్లింపులు కనుగొనబడలేదు';

  @override
  String get noPaymentsFoundSubtitle =>
      'ఈ సమయంలో చెల్లింపుల చరిత్ర అందుబాటులో లేదు.';

  @override
  String get paymentSummary => 'చెల్లింపు సారాంశం';

  @override
  String get consultationFee => 'సంప్రదింపు రుసుము';

  @override
  String get serviceFee => 'సేవా రుసుము';

  @override
  String get taxProcessing => 'పన్ను మరియు ప్రాసెసింగ్';

  @override
  String get insuranceCoverage => 'భీమా కవరేజ్';

  @override
  String get yourInsuranceCovers => 'మీ భీమా కవర్ చేస్తుంది';

  @override
  String get ofThisAppointment => 'ఈ అపాయింట్‌మెంట్‌కు';

  // Notifications
  @override
  String get notifications => 'నోటిఫికేషన్లు';

  @override
  String get markAllAsRead => 'అన్నింటినీ చదివినట్లు గుర్తించండి';

  @override
  String get clearAll => 'అన్నింటినీ క్లియర్ చేయండి';

  @override
  String get noNotifications => 'నోటిఫికేషన్లు లేవు';

  @override
  String get noNotificationsSubtitle =>
      'అవి వచ్చినప్పుడు మీరు ఇక్కడ నోటిఫికేషన్లను చూస్తారు.';

  @override
  String get appointmentReminder => 'అపాయింట్‌మెంట్ రిమైండర్';

  @override
  String get medicationReminder => 'మందుల రిమైండర్';

  @override
  String get testResults => 'పరీక్ష ఫలితాలు';

  @override
  String get systemUpdate => 'సిస్టమ్ అప్‌డేట్';

  // Error Messages
  @override
  String get somethingWentWrong => 'ఏదో తప్పు జరిగింది';

  @override
  String get networkError => 'నెట్‌వర్క్ లోపం జరిగింది';

  @override
  String get tryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get noInternetConnection => 'ఇంటర్నెట్ కనెక్షన్ లేదు';

  // Success Messages
  @override
  String get success => 'విజయం';

  @override
  String get savedSuccessfully => 'విజయవంతంగా సేవ్ చేయబడింది';

  @override
  String get updatedSuccessfully => 'విజయవంతంగా అప్‌డేట్ చేయబడింది';

  @override
  String get deletedSuccessfully => 'విజయవంతంగా తొలగించబడింది';

  // Time and Date
  @override
  String get today => 'ఈరోజు';

  @override
  String get yesterday => 'నిన్న';

  @override
  String get tomorrow => 'రేపు';

  @override
  String get thisWeek => 'ఈ వారం';

  @override
  String get lastWeek => 'గత వారం';

  @override
  String get thisMonth => 'ఈ నెల';

  @override
  String get lastMonth => 'గత నెల';

  @override
  String get morning => 'ఉదయం';

  @override
  String get afternoon => 'మధ్యాహ్నం';

  @override
  String get evening => 'సాయంత్రం';

  @override
  String get night => 'రాత్రి';

  // Medical Terms
  @override
  String get bloodPressure => 'రక్తపోటు';

  @override
  String get heartRate => 'గుండె చప్పుడు';

  @override
  String get temperature => 'ఉష్ణోగ్రత';

  @override
  String get weight => 'బరువు';

  @override
  String get height => 'ఎత్తు';

  @override
  String get glucose => 'గ్లూకోజ్';

  @override
  String get cholesterol => 'కొలెస్ట్రోల్';

  @override
  String get oxygenSaturation => 'ఆక్సిజన్ సంతృప్తత';

  // Medication Tracker specific strings
  @override
  String get medicationTracker => 'మందుల ట్రాకర్';

  @override
  String get myMedications => 'నా మందులు';

  @override
  String get medicationHistory => 'మందుల చరిత్ర';

  @override
  String get exportLog => 'లాగ్ ఎగుమతి చేయండి';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get todaysProgress => 'ఈరోజు పురోగతి';

  @override
  String get weeklyAdherence => 'వారపు అనుసరణ';

  @override
  String get currentPrescriptions => 'ప్రస్తుత ప్రిస్క్రిప్షన్లు';

  @override
  String get todaysSchedule => 'ఈరోజు షెడ్యూల్';

  @override
  String get viewAll => 'అన్నీ చూడండి';

  @override
  String get medicationMarkedAsTaken => 'మందు తీసుకున్నట్లు గుర్తించబడింది';

  @override
  String get prescriptionMarkedAsTaken =>
      'ప్రిస్క్రిప్షన్ తీసుకున్నట్లు గుర్తించబడింది';

  @override
  String get setReminder => 'రిమైండర్ సెట్ చేయండి';

  @override
  String get reminderFunctionality =>
      'రిమైండర్ ఫంక్షనాలిటీ ఇక్కడ నోటిఫికేషన్ షెడ్యూలింగ్‌తో అమలు చేయబడుతుంది.';

  @override
  String get reminderSetSuccessfully => 'రిమైండర్ విజయవంతంగా సెట్ చేయబడింది';

  @override
  String get requestRefill => 'రీఫిల్ అభ్యర్థించండి';

  @override
  String get refillRequestMessage =>
      'రీఫిల్ అభ్యర్థన మీ ఫార్మసీ మరియు హెల్త్‌కేర్ ప్రొవైడర్‌కు పంపబడుతుంది.';

  @override
  String get refillRequestSent => 'రీఫిల్ అభ్యర్థన పంపబడింది';

  @override
  String get request => 'అభ్యర్థన';

  @override
  String get prescribingDoctor => 'ప్రిస్క్రిప్షన్ చేసిన డాక్టర్';

  @override
  String get dosageInstructions => 'డోసేజ్ సూచనలు';

  @override
  String get refillInformation => 'రీఫిల్ సమాచారం';

  @override
  String get nextRefill => 'తదుపరి రీఫిల్';

  @override
  String get daysRemaining => 'మిగిలిన రోజులు';

  @override
  String get editDosage => 'డోసేజ్ ఎడిట్ చేయండి';

  @override
  String get dosageChangesRequireMedical =>
      'డోసేజ్ మార్పులకు వైద్య నిర్ధారణ అవసరం. దయచేసి మీ హెల్త్‌కేర్ ప్రొవైడర్‌ను సంప్రదించండి.';

  @override
  String get contactDoctor => 'డాక్టర్‌ను సంప్రదించండి';

  @override
  String get discontinueMedication => 'మందు నిలిపివేయండి';

  @override
  String get discontinueMedicationConfirm =>
      'మీరు నిజంగా ఈ మందును నిలిపివేయాలనుకుంటున్నారా? ఈ చర్యకు వైద్య నిర్ధారణ అవసరం.';

  @override
  String get consultDoctorBeforeDiscontinuing =>
      'నిలిపివేయడానికి ముందు దయచేసి మీ డాక్టర్‌ను సంప్రదించండి';

  @override
  String get insightsView => 'అంతర్దృష్టి వీక్షణ ఇక్కడ తెరుచుకుంటుంది';

  @override
  String get calendarView => 'క్యాలెండర్ వీక్షణ ఇక్కడ తెరుచుకుంటుంది';

  @override
  String get medicationManagement =>
      'మందుల నిర్వహణ మీ హెల్త్‌కేర్ ప్రొవైడర్ చేత నిర్వహించబడుతుంది';

  @override
  String get exportLogFunctionality =>
      'ఎగుమతి లాగ్ ఫంక్షనాలిటీ ఇక్కడ అమలు చేయబడుతుంది';

  @override
  String get trackerSettings => 'ట్రాకర్ సెట్టింగ్‌లు ఇక్కడ తెరుచుకుంటుంది';

  @override
  String get passwordStrengthWeak => 'బలహీన';

  @override
  String get passwordStrengthFair => 'సరైన';

  @override
  String get passwordStrengthGood => 'మంచి';

  @override
  String get passwordStrengthStrong => 'బలమైన';

  @override
  String get passwordStrength => 'పాస్వర్డ్ బలం';

  @override
  String get fullScheduleView =>
      'పూర్తి మందుల షెడ్యూల్ వీక్షణ ఇక్కడ తెరుచుకుంటుంది';

  // Common UI strings
  @override
  String get viewDetails => 'వివరాలు చూడండి';

  @override
  String get markAsTaken => 'తీసుకున్నట్లు గుర్తించండి';

  @override
  String get reminderSet => 'రిమైండర్ సెట్ చేయబడింది';

  @override
  String get refillRequested => 'రీఫిల్ అభ్యర్థించబడింది';

  @override
  String get discontinueConfirm => 'నిలిపివేత నిర్ధారణ';

  @override
  String get pleaseContact => 'దయచేసి సంప్రదించండి';

  @override
  String get wouldOpenHere => 'ఇక్కడ తెరుచుకుంటుంది';

  @override
  String get wouldBeImplementedHere => 'ఇక్కడ అమలు చేయబడుతుంది';
}
