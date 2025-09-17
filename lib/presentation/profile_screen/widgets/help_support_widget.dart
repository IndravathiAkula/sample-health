import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class HelpSupportWidget extends StatefulWidget {
  const HelpSupportWidget({super.key});

  @override
  State<HelpSupportWidget> createState() => _HelpSupportWidgetState();
}

class _HelpSupportWidgetState extends State<HelpSupportWidget> {
  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Account & Profile',
      'isExpanded': false,
      'faqs': [
        {
          'question': 'How do I update my personal information?',
          'answer':
              'Go to the Personal Details section and tap the edit icon to modify your information.',
        },
        {
          'question': 'Can I change my registered email address?',
          'answer':
              'Yes, you can update your email in the Personal Details section. A verification email will be sent to your new address.',
        },
      ],
    },
    {
      'title': 'Appointments & Scheduling',
      'isExpanded': false,
      'faqs': [
        {
          'question': 'How do I book a new appointment?',
          'answer':
              'Use the "Book Appointment" option from the dashboard or visit the Appointments section.',
        },
        {
          'question': 'Can I reschedule my appointment?',
          'answer':
              'Yes, you can reschedule up to 24 hours before your appointment time through the app.',
        },
      ],
    },
    {
      'title': 'Medical Records & Reports',
      'isExpanded': false,
      'faqs': [
        {
          'question': 'How do I access my lab results?',
          'answer':
              'Lab results are available in the Medical Records section once processed by our laboratory.',
        },
        {
          'question': 'Can I share my reports with other doctors?',
          'answer':
              'Yes, you can export and share your medical reports securely through the app.',
        },
      ],
    },
    {
      'title': 'Technical Support',
      'isExpanded': false,
      'faqs': [
        {
          'question': 'The app is not working properly. What should I do?',
          'answer':
              'Try closing and reopening the app. If issues persist, contact our support team.',
        },
        {
          'question': 'How do I update the app?',
          'answer':
              'Visit your device\'s app store and check for updates. Enable automatic updates for the best experience.',
        },
      ],
    },
  ];

  Future<void> _makePhoneCall() async {
    const String phoneNumber = 'tel:+1-555-123-4567';
    final Uri phoneUri = Uri.parse(phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not make phone call'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error making phone call'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _navigateToHospital() async {
    const String mapsUrl =
        'https://www.google.com/maps/place/Achala+IT+Solutions+Pvt.Ltd/@17.4433954,78.3957799,17z/data=!3m1!4b1!4m6!3m5!1s0x3bcb91f482a59235:0x809a5c43f39a0b3e!8m2!3d17.4433954!4d78.3983548!16s%2Fg%2F11qt3ytb8m?entry=ttu&g_ep=EgoyMDI1MDgxMC4wIKXMDSoASAFQAw%3D%3D';
    final Uri mapsUri = Uri.parse(mapsUrl);

    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open maps'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error opening maps'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _openChatSupport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildChatSupportModal(),
    );
  }

  Widget _buildChatSupportModal() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'chat',
                    size: 6.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat Support',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'We\'re here to help you',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Mock chat messages
                  Expanded(
                    child: ListView(
                      children: [
                        _buildChatMessage(
                          message:
                              'Hello! How can I assist you today with your healthcare needs?',
                          isSupport: true,
                          time: '10:30 AM',
                        ),
                        _buildChatMessage(
                          message:
                              'Hi, I need help with scheduling my appointment.',
                          isSupport: false,
                          time: '10:32 AM',
                        ),
                        _buildChatMessage(
                          message:
                              'I\'d be happy to help you with appointment scheduling. What type of appointment would you like to book?',
                          isSupport: true,
                          time: '10:33 AM',
                        ),
                      ],
                    ),
                  ),

                  // Chat input
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'send',
                            size: 5.w,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

  Widget _buildChatMessage({
    required String message,
    required bool isSupport,
    required String time,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment:
            isSupport ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isSupport) ...[
            CircleAvatar(
              radius: 4.w,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'support_agent',
                size: 4.w,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isSupport
                    ? AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSupport
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    time,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSupport
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : Colors.white.withValues(alpha: 0.7),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'help',
                  size: 6.w,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Help & Support',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Quick Support Actions
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _openChatSupport,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'chat',
                          size: 8.w,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Chat with Support',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: GestureDetector(
                  onTap: _makePhoneCall,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'phone',
                          size: 8.w,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Call Us',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Navigate to Hospital Button
          Container(
            width: double.infinity,
            child: GestureDetector(
              onTap: _navigateToHospital,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      size: 6.w,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Navigate to Hospital',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // FAQ Section
          Text(
            'Frequently Asked Questions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          ..._faqCategories
              .map((category) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme
                          .lightTheme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          category['title'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: (category['faqs'] as List)
                            .map<Widget>(
                              (faq) => Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(3.w),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 1.w),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      faq['question'],
                                      style: AppTheme
                                          .lightTheme.textTheme.labelLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      faq['answer'],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ))
              .toList(),

          SizedBox(height: 2.h),

          // Contact Information
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need More Help?',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Support Hours: Monday - Friday, 8:00 AM - 8:00 PM\nPhone: +1 (555) 123-4567\nEmail: support@healthcareconnect.com',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
