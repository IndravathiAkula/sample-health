import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/consent_action_buttons_widget.dart';
import './widgets/consent_content_widget.dart';
import './widgets/consent_header_widget.dart';
import './widgets/consent_toggle_widget.dart';
import './widgets/privacy_links_widget.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _hasScrolledToEnd = false;
  bool _consentGiven = false;
  bool _isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasScrolledToEnd) {
        setState(() {
          _hasScrolledToEnd = true;
        });
      }
    }
  }

  void _handleConsentToggle(bool value) {
    setState(() {
      _consentGiven = value;
    });

    if (value) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _handleContinue() async {
    if (!_consentGiven || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate consent logging delay
    await Future.delayed(const Duration(seconds: 1));

    // Store consent timestamp (in real app, this would be sent to backend)
    HapticFeedback.lightImpact();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard-screen');
    }
  }

  void _handleCancel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              color: AppTheme.ovalGreen,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Exit Application'),
          ],
        ),
        content: const Text(
          'You cannot proceed without providing consent for data collection. This is required for your healthcare services. Would you like to exit the application?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const ConsentHeaderWidget(),

            // Main Content - Scrollable
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Consent Content
                    const ConsentContentWidget(),

                    SizedBox(height: 3.h),

                    // Consent Toggle
                    ConsentToggleWidget(
                      isEnabled: _hasScrolledToEnd,
                      value: _consentGiven,
                      onChanged: _handleConsentToggle,
                    ),

                    SizedBox(height: 2.h),

                    // Privacy Links
                    const PrivacyLinksWidget(),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Action Buttons
            ConsentActionButtonsWidget(
              isConsentGiven: _consentGiven,
              isLoading: _isLoading,
              onContinue: _handleContinue,
              onCancel: _handleCancel,
            ),
          ],
        ),
      ),
    );
  }
}
