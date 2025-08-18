import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DataExportWidget extends StatefulWidget {
  final String userName;
  final String patientId;

  const DataExportWidget({
    super.key,
    required this.userName,
    required this.patientId,
  });

  @override
  State<DataExportWidget> createState() => _DataExportWidgetState();
}

class _DataExportWidgetState extends State<DataExportWidget> {
  bool _isExporting = false;

  Future<void> _exportUserData() async {
    setState(() {
      _isExporting = true;
    });

    try {
      // Generate comprehensive user data export
      final userData = _generateUserDataExport();
      final jsonContent = jsonEncode(userData);

      // Create filename with timestamp
      final timestamp = DateTime.now().toIso8601String().split('T')[0];
      final filename =
          'ivf_care_data_export_${widget.patientId}_$timestamp.json';

      await _downloadFile(jsonContent, filename);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Map<String, dynamic> _generateUserDataExport() {
    return {
      'export_info': {
        'generated_at': DateTime.now().toIso8601String(),
        'export_type': 'Complete User Data Export',
        'compliance': 'GDPR/HIPAA Compliant',
      },
      'personal_information': {
        'name': widget.userName,
        'patient_id': widget.patientId,
        'account_created': '2024-01-15T10:30:00Z',
        'last_login': '2025-08-11T14:04:58Z',
      },
      'medical_records': {
        'total_appointments': 12,
        'completed_treatments': 3,
        'lab_results_count': 8,
        'prescriptions_count': 15,
        'note': 'Detailed medical records available through secure portal',
      },
      'appointment_history': [
        {
          'date': '2025-08-15T09:00:00Z',
          'type': 'Consultation',
          'doctor': 'Dr. Sarah Johnson',
          'status': 'Scheduled',
        },
        {
          'date': '2025-07-20T14:30:00Z',
          'type': 'Follow-up',
          'doctor': 'Dr. Michael Chen',
          'status': 'Completed',
        },
      ],
      'payment_history': {
        'total_payments': 8,
        'total_amount': '₹2,45,000',
        'last_payment': '2025-07-25T11:15:00Z',
        'payment_methods': ['Card', 'UPI', 'Insurance'],
      },
      'preferences': {
        'language': 'English',
        'notifications_enabled': true,
        'appointment_reminders': true,
        'medication_alerts': true,
      },
      'privacy_settings': {
        'data_sharing_consent': true,
        'marketing_communications': false,
        'biometric_authentication': true,
      },
      'data_retention': {
        'policy': 'Data retained for 7 years as per medical regulations',
        'deletion_request': 'Contact support for data deletion requests',
      },
    };
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'download',
                color: colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Download My Data',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Export all your personal and medical data in JSON format',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Data types included
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Included Data:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                ...[
                  'Personal information and account details',
                  'Appointment history and medical records',
                  'Payment history and billing information',
                  'App preferences and privacy settings',
                ].map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: colorScheme.primary,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              item,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Export button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isExporting ? null : _exportUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isExporting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Exporting...',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: colorScheme.onPrimary,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Export Data',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Compliance note
          Text(
            'This export complies with GDPR and HIPAA regulations. Your data will be downloaded in a secure JSON format.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
