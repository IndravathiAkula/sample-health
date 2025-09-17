import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import '../../services/localization_service.dart';
import './widgets/address_management_widget.dart';
import './widgets/help_support_widget.dart';
import './widgets/language_preference_widget.dart';
import './widgets/personal_details_widget.dart';
import './widgets/profile_header_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  String _selectedLanguage = 'English';
  Map<String, dynamic> _personalDetails = {};
  List<Map<String, dynamic>> _addresses = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _initializeData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? 'English';
      _personalDetails = {
        'name': prefs.getString('user_name') ?? 'Sarah Mitchell',
        'email': prefs.getString('user_email') ?? 'sarah.mitchell@email.com',
        'phone': prefs.getString('user_phone') ?? '+1 (555) 123-4567',
        'dob': prefs.getString('user_dob') ?? 'January 15, 1988',
        'emergencyContact':
            prefs.getString('emergency_contact') ?? '+1 (555) 987-6543',
      };
      _addresses = [
        {
          'id': '1',
          'type': 'Home',
          'address': '123 Healthcare Ave, Medical District, NY 10001',
          'isDefault': true,
        },
      ];
    });
  }

  Future<void> _updateLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);

    // Update the app locale through LocalizationService
    await LocalizationService().changeLocale(language);

    setState(() {
      _selectedLanguage = language;
    });

    if (mounted) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${localizations?.languageUpdated ?? 'Language updated'} to $language'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _updatePersonalDetails(Map<String, dynamic> details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', details['name']);
    await prefs.setString('user_email', details['email']);
    await prefs.setString('user_phone', details['phone']);
    await prefs.setString('user_dob', details['dob']);
    await prefs.setString('emergency_contact', details['emergencyContact']);

    setState(() {
      _personalDetails = details;
    });

    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.personalDetailsUpdated ??
            'Personal details updated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addAddress(Map<String, dynamic> address) {
    setState(() {
      address['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      _addresses.add(address);
    });
  }

  void _updateAddress(String id, Map<String, dynamic> address) {
    setState(() {
      final index = _addresses.indexWhere((addr) => addr['id'] == id);
      if (index != -1) {
        _addresses[index] = {...address, 'id': id};
      }
    });
  }

  void _deleteAddress(String id) {
    setState(() {
      _addresses.removeWhere((addr) => addr['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          // Add Home button
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
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_slideAnimation),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 20.h,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileHeaderWidget(
                    name: _personalDetails['name'] ?? 'Sarah Mitchell',
                    email:
                        _personalDetails['email'] ?? 'sarah.mitchell@email.com',
                    onEditTap: () {
                      // Handle profile picture editing
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              localizations?.profilePictureEditingComingSoon ??
                                  'Profile picture editing coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _slideAnimation,
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // Personal Details Section
                      PersonalDetailsWidget(
                        personalDetails: _personalDetails,
                        onUpdateDetails: _updatePersonalDetails,
                      ),

                      SizedBox(height: 2.h),

                      // Language Preference Section
                      LanguagePreferenceWidget(
                        selectedLanguage: _selectedLanguage,
                        onLanguageChange: _updateLanguage,
                      ),

                      SizedBox(height: 2.h),

                      // Address Management Section
                      AddressManagementWidget(
                        addresses: _addresses,
                        onAddAddress: _addAddress,
                        onUpdateAddress: _updateAddress,
                        onDeleteAddress: _deleteAddress,
                      ),

                      SizedBox(height: 2.h),

                      // Help & Support Section
                      HelpSupportWidget(),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
