import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationReminderCardWidget extends StatefulWidget {
  final List<Map<String, dynamic>> medications;
  final Function(int index, bool taken)? onMedicationToggle;

  const MedicationReminderCardWidget({
    super.key,
    required this.medications,
    this.onMedicationToggle,
  });

  @override
  State<MedicationReminderCardWidget> createState() =>
      _MedicationReminderCardWidgetState();
}

class _MedicationReminderCardWidgetState
    extends State<MedicationReminderCardWidget> {
  @override
  Widget build(BuildContext context) {
    final int totalMedications = widget.medications.length;
    final int takenMedications =
        widget.medications.where((med) => med['taken'] == true).length;
    final double progress =
        totalMedications > 0 ? takenMedications / totalMedications : 0.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'medication',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Today\'s Medications',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$takenMedications/$totalMedications',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              height: 1.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            widget.medications.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 12.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No medications for today',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.medications.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final medication = widget.medications[index];
                      final bool isTaken = medication['taken'] ?? false;

                      return Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: isTaken
                              ? AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isTaken
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.3)
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'local_pharmacy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 6.w,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    medication['name'] ?? 'Unknown Medication',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      decoration: isTaken
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isTaken
                                          ? AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Row(
                                    children: [
                                      Text(
                                        '${medication['dosage'] ?? '1 pill'} • ${medication['time'] ?? '9:00 AM'}',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isTaken,
                              onChanged: (bool? value) {
                                if (widget.onMedicationToggle != null) {
                                  widget.onMedicationToggle!(
                                      index, value ?? false);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
