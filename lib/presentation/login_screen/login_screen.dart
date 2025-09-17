import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/healthcare_header_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/security_indicators_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  // Mock credentials for testing (MRN/Mobile + OTP)
  final Map<String, String> _mockCredentials = {
    'MRN12345': '123456',
    '9876543210': '654321',
    'MRN67890': '987654',
    '1234567890': '111111',
  };

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateMrnMobile);
    _passwordController.addListener(_validateOtp);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateMrnMobile);
    _passwordController.removeListener(_validateOtp);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateMrnMobile() {
    final localizations = AppLocalizations.of(context);
    final input = _emailController.text.trim();
    setState(() {
      if (input.isEmpty) {
        _emailError = null;
      } else {
        // Check if it's a valid MRN (starts with MRN followed by digits) or mobile number (10 digits)
        bool isValidMRN = RegExp(r'^MRN\d{5,}$').hasMatch(input);
        bool isValidMobile = RegExp(r'^\d{10}$').hasMatch(input);

        if (!isValidMRN && !isValidMobile) {
          _emailError = localizations?.invalidMrnMobile ??
              'Please enter a valid MRN (MRN12345) or 10-digit mobile number';
        } else {
          _emailError = null;
        }
      }
    });
  }

  void _validateOtp() {
    final localizations = AppLocalizations.of(context);
    final otp = _passwordController.text;
    setState(() {
      if (otp.isEmpty) {
        _passwordError = null;
      } else if (otp.length != 6) {
        _passwordError =
            localizations?.otpMustBeSixDigits ?? 'OTP must be 6 digits';
      } else if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
        _passwordError =
            localizations?.otpMustBeNumeric ?? 'OTP must contain only numbers';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return;

    final mrnMobile = _emailController.text.trim();
    final otp = _passwordController.text;
    final localizations = AppLocalizations.of(context);

    // Clear previous errors
    setState(() {
      _generalError = null;
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_mockCredentials.containsKey(mrnMobile) &&
        _mockCredentials[mrnMobile] == otp) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      setState(() {
        _isLoading = false;
      });

      // Navigate to consent screen instead of dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/consent-screen');
      }
    } else {
      // Authentication failed
      setState(() {
        _isLoading = false;
        if (!_mockCredentials.containsKey(mrnMobile)) {
          _generalError = localizations?.mrnMobileNotFound ??
              'MRN or mobile number not found. Please check your credentials or contact support.';
        } else {
          _generalError = localizations?.invalidOtp ??
              'Invalid OTP. Please try again or request a new OTP.';
        }
      });

      // Show error feedback
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _handleBiometricAuth() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, assume biometric auth succeeds
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/consent-screen');
    }
  }

  void _handleForgotPassword() {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'sms',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(localizations?.otpResend ?? 'Resend OTP'),
          ],
        ),
        content: Text(
          localizations?.otpResendMessage ??
              'A new OTP will be sent to your registered mobile number. For security reasons, OTP delivery requires verification through our healthcare system. Please contact support if you don\'t receive the OTP within 5 minutes.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.contactSupport ?? 'Contact Support'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  void _handleRegister() {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'person_add',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              localizations?.newPatientRegistration ??
                  'New Patient Registration',
            ),
          ],
        ),
        content: Text(
          localizations?.newPatientRegistrationMessage ??
              'New fertility patient registration requires medical verification and insurance information. Please visit our IVF clinic registration portal or contact your reproductive endocrinologist to begin the secure enrollment process.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.visitPortal ?? 'Visit Portal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: 4.h),

                  // Healthcare Header
                  const HealthcareHeaderWidget(),

                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isLoading: _isLoading,
                    onSignIn: _handleSignIn,
                    onForgotPassword: _handleForgotPassword,
                    emailError: _emailError,
                    passwordError: _passwordError,
                  ),

                  // General Error Message
                  if (_generalError != null) ...[
                    SizedBox(height: 2.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error_outline',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _generalError!,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 3.h),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricPressed: _handleBiometricAuth,
                    isEnabled: !_isLoading,
                  ),

                  const Spacer(),

                  // Security Indicators
                  const SecurityIndicatorsWidget(),

                  SizedBox(height: 2.h),

                  // Register Link
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations?.newFertilityPatient ??
                              'New Fertility Patient? ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _handleRegister,
                          child: Text(
                            localizations?.register ?? 'Register',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
