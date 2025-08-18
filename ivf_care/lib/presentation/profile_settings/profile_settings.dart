import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/accessibility_controls_widget.dart';
import './widgets/data_export_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_tile_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  int _currentBottomIndex = 4; // Profile tab active

  // User data
  final String _userName = "Sarah Johnson";
  final String _patientId = "IVF2024001";
  final String? _avatarUrl =
      "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face";

  // Settings state
  String _selectedLanguage = 'en';
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  double _fontSize = 16.0;
  bool _highContrast = false;
  bool _screenReaderEnabled = false;
  bool _appointmentReminders = true;
  bool _medicationAlerts = true;
  bool _promotionalCommunications = false;
  bool _showLanguageSelector = false;
  bool _showAccessibilityControls = false;
  bool _showNotificationPreferences = false;

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });
  }

  void _showEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit profile functionality coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSecuritySettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSecurityBottomSheet(),
    );
  }

  void _showTwoFactorSetup() {
    showDialog(
      context: context,
      builder: (context) => _buildTwoFactorDialog(),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => _buildLogoutDialog(),
    );
  }

  void _performLogout() {
    // Clear user session and navigate to login
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  Widget _buildSecurityBottomSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Security Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),

          // Security options
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4.w),
              children: [
                SettingsTileWidget(
                  title: 'Biometric Authentication',
                  subtitle: _biometricEnabled ? 'Enabled' : 'Disabled',
                  iconName: 'fingerprint',
                  showArrow: false,
                  trailingWidget: Switch(
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                SettingsTileWidget(
                  title: 'Two-Factor Authentication',
                  subtitle: _twoFactorEnabled ? 'Enabled' : 'Not configured',
                  iconName: 'security',
                  onTap: () {
                    Navigator.pop(context);
                    _showTwoFactorSetup();
                  },
                ),
                SizedBox(height: 2.h),
                SettingsTileWidget(
                  title: 'Change Password',
                  subtitle: 'Last changed 30 days ago',
                  iconName: 'lock',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Password change functionality coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                SizedBox(height: 2.h),
                SettingsTileWidget(
                  title: 'Active Sessions',
                  subtitle: '2 active sessions',
                  iconName: 'devices',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Session management coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'security',
            color: colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Text(
            'Two-Factor Authentication',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enhance your account security by enabling two-factor authentication.',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'qr_code',
                  color: colorScheme.primary,
                  size: 8.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Scan QR code with your authenticator app',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _twoFactorEnabled = !_twoFactorEnabled;
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_twoFactorEnabled
                    ? '2FA enabled successfully'
                    : '2FA disabled'),
                backgroundColor: colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(_twoFactorEnabled ? 'Disable' : 'Enable'),
        ),
      ],
    );
  }

  Widget _buildLogoutDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'logout',
            color: colorScheme.error,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Text(
            'Logout',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to logout? You will need to authenticate again to access your account.',
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _performLogout();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          child: Text('Logout'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header with profile info
            Container(
              padding: EdgeInsets.all(4.w),
              child: ProfileHeaderWidget(
                userName: _userName,
                patientId: _patientId,
                avatarUrl: _avatarUrl,
                onEditPressed: _showEditProfile,
              ),
            ),

            // Settings content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    // Personal Information Section
                    SettingsSectionWidget(
                      title: 'Personal Information',
                      children: [
                        SettingsTileWidget(
                          title: 'Contact Details',
                          subtitle: 'Phone, email, address',
                          iconName: 'contact_phone',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Contact details editing coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        SettingsTileWidget(
                          title: 'Emergency Contacts',
                          subtitle: '2 contacts added',
                          iconName: 'emergency',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Emergency contacts management coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        SettingsTileWidget(
                          title: 'Medical History',
                          subtitle: 'Update medical information',
                          iconName: 'medical_information',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Medical history update coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // Security Settings Section
                    SettingsSectionWidget(
                      title: 'Security Settings',
                      children: [
                        SettingsTileWidget(
                          title: 'Biometric Authentication',
                          subtitle: _biometricEnabled ? 'Enabled' : 'Disabled',
                          iconName: 'fingerprint',
                          showArrow: false,
                          trailingWidget: Switch(
                            value: _biometricEnabled,
                            onChanged: (value) {
                              setState(() {
                                _biometricEnabled = value;
                              });
                            },
                            activeColor: colorScheme.primary,
                          ),
                        ),
                        SettingsTileWidget(
                          title: 'Security Settings',
                          subtitle: 'Password, 2FA, sessions',
                          iconName: 'security',
                          onTap: _showSecuritySettings,
                        ),
                        SettingsTileWidget(
                          title: 'Privacy Controls',
                          subtitle: 'Data sharing preferences',
                          iconName: 'privacy_tip',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Privacy controls coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // Preferences Section
                    SettingsSectionWidget(
                      title: 'Preferences',
                      children: [
                        SettingsTileWidget(
                          title: 'Language',
                          subtitle: _selectedLanguage == 'en'
                              ? 'English'
                              : _selectedLanguage == 'hi'
                                  ? 'Hindi'
                                  : 'Telugu',
                          iconName: 'language',
                          onTap: () {
                            setState(() {
                              _showLanguageSelector = !_showLanguageSelector;
                            });
                          },
                        ),
                        if (_showLanguageSelector) ...[
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: LanguageSelectorWidget(
                              selectedLanguage: _selectedLanguage,
                              onLanguageChanged: (language) {
                                setState(() {
                                  _selectedLanguage = language;
                                  _showLanguageSelector = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Language updated successfully'),
                                    backgroundColor: colorScheme.primary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                        SettingsTileWidget(
                          title: 'Accessibility',
                          subtitle: 'Font size, contrast, screen reader',
                          iconName: 'accessibility',
                          onTap: () {
                            setState(() {
                              _showAccessibilityControls =
                                  !_showAccessibilityControls;
                            });
                          },
                        ),
                        if (_showAccessibilityControls) ...[
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: AccessibilityControlsWidget(
                              fontSize: _fontSize,
                              highContrast: _highContrast,
                              screenReaderEnabled: _screenReaderEnabled,
                              onFontSizeChanged: (size) {
                                setState(() {
                                  _fontSize = size;
                                });
                              },
                              onHighContrastChanged: (enabled) {
                                setState(() {
                                  _highContrast = enabled;
                                });
                              },
                              onScreenReaderChanged: (enabled) {
                                setState(() {
                                  _screenReaderEnabled = enabled;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                        SettingsTileWidget(
                          title: 'Notifications',
                          subtitle: 'Manage notification preferences',
                          iconName: 'notifications',
                          onTap: () {
                            setState(() {
                              _showNotificationPreferences =
                                  !_showNotificationPreferences;
                            });
                          },
                        ),
                        if (_showNotificationPreferences) ...[
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: NotificationPreferencesWidget(
                              appointmentReminders: _appointmentReminders,
                              medicationAlerts: _medicationAlerts,
                              promotionalCommunications:
                                  _promotionalCommunications,
                              onAppointmentRemindersChanged: (enabled) {
                                setState(() {
                                  _appointmentReminders = enabled;
                                });
                              },
                              onMedicationAlertsChanged: (enabled) {
                                setState(() {
                                  _medicationAlerts = enabled;
                                });
                              },
                              onPromotionalCommunicationsChanged: (enabled) {
                                setState(() {
                                  _promotionalCommunications = enabled;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ],
                    ),

                    // Data & Privacy Section
                    SettingsSectionWidget(
                      title: 'Data & Privacy',
                      children: [
                        SettingsTileWidget(
                          title: 'Privacy Policy',
                          subtitle: 'View our privacy policy',
                          iconName: 'policy',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Privacy policy viewer coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        SettingsTileWidget(
                          title: 'Terms of Service',
                          subtitle: 'View terms and conditions',
                          iconName: 'description',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Terms of service viewer coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // Data Export Section
                    SizedBox(height: 2.h),
                    DataExportWidget(
                      userName: _userName,
                      patientId: _patientId,
                    ),

                    // Payments Section
                    SettingsSectionWidget(
                      title: 'Payments',
                      children: [
                        SettingsTileWidget(
                          title: 'Payment History & Methods',
                          subtitle: 'View and manage your payment details',
                          iconName: 'payment',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.paymentProcessing);
                          },
                        ),
                        // SettingsTileWidget(
                        //   title: 'Billing Information',
                        //   subtitle: 'Update billing address and info',
                        //   iconName: 'credit_card',
                        //   onTap: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Text('Billing information update coming soon'),
                        //         behavior: SnackBarBehavior.floating,
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),

                    // Support Section
                    SettingsSectionWidget(
                      title: 'Support',
                      children: [
                        SettingsTileWidget(
                          title: 'Help & FAQ',
                          subtitle: 'Get answers to common questions',
                          iconName: 'help',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Help center coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        SettingsTileWidget(
                          title: 'Contact Support',
                          subtitle: 'Get help from our team',
                          iconName: 'support_agent',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Support contact coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        SettingsTileWidget(
                          title: 'App Version',
                          subtitle: 'v1.0.0 (Build 100)',
                          iconName: 'info',
                          showArrow: false,
                        ),
                      ],
                    ),

                    // Logout Section
                    SizedBox(height: 3.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ElevatedButton(
                        onPressed: _showLogoutConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'logout',
                              color: colorScheme.onError,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Logout',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onError,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
