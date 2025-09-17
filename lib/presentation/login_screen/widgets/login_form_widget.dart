import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../l10n/app_localizations.dart';

class LoginFormWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSignIn;
  final VoidCallback onForgotPassword;
  final String? emailError;
  final String? passwordError;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSignIn,
    required this.onForgotPassword,
    this.emailError,
    this.passwordError,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _isPasswordVisible = false;
  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_checkPasswordStrength);
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = widget.passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.grey;
      });
      return;
    }

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    setState(() {
      switch (strength) {
        case 0:
        case 1:
          _passwordStrength = 'Weak';
          _strengthColor = AppTheme.lightTheme.colorScheme.error;
          break;
        case 2:
          _passwordStrength = 'Fair';
          _strengthColor = AppTheme.warningLight;
          break;
        case 3:
          _passwordStrength = 'Good';
          _strengthColor = AppTheme.lightTheme.colorScheme.tertiary;
          break;
        case 4:
          _passwordStrength = 'Strong';
          _strengthColor = AppTheme.lightTheme.colorScheme.tertiary;
          break;
      }
    });
  }

  bool get _isFormValid {
    return widget.emailController.text.isNotEmpty &&
        widget.passwordController.text.isNotEmpty &&
        widget.emailError == null &&
        widget.passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MRN/Mobile Field
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.text,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText:
                  localizations?.mrnMobileNumber ?? 'MRN / Mobile Number',
              hintText: localizations?.enterMrnMobile ??
                  'Enter your MRN or mobile number',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'badge',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              errorText: widget.emailError,
            ),
          ),
          SizedBox(height: 2.h),

          // OTP Field
          TextFormField(
            controller: widget.passwordController,
            obscureText: !_isPasswordVisible,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              labelText: localizations?.otp ?? 'OTP',
              hintText: localizations?.enterOtp ?? 'Enter your OTP',
              counterText: '',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: widget.isLoading
                    ? null
                    : () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              errorText: widget.passwordError,
            ),
          ),

          // Password Strength Indicator
          if (_passwordStrength.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: _strengthColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${localizations?.passwordStrength ?? 'Password Strength'}: ${_getLocalizedPasswordStrength(localizations)}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _strengthColor,
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 2.h),

          // Resend OTP Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onForgotPassword,
              child: Text(
                localizations?.resendOtpQuestion ?? 'Resend OTP?',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isFormValid && !widget.isLoading) ? widget.onSignIn : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h), // responsive vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.isLoading
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Flexible(
                    child: Text(
                      localizations?.verifying ?? 'Verifying...',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp, // responsive text size
                      ),
                    ),
                  ),
                ],
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'login',
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      localizations?.verifyOtp ?? 'Verify OTP',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp, // responsive text size
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

  String _getLocalizedPasswordStrength(AppLocalizations? localizations) {
    if (localizations == null) return _passwordStrength;

    switch (_passwordStrength) {
      case 'Weak':
        return localizations.passwordStrengthWeak;
      case 'Fair':
        return localizations.passwordStrengthFair;
      case 'Good':
        return localizations.passwordStrengthGood;
      case 'Strong':
        return localizations.passwordStrengthStrong;
      default:
        return _passwordStrength;
    }
  }
}
