import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressRingChart extends StatelessWidget {
  final double adherencePercentage;
  final int totalMedications;
  final int takenMedications;

  const ProgressRingChart({
    Key? key,
    required this.adherencePercentage,
    required this.totalMedications,
    required this.takenMedications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Today\'s Adherence',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 15.w,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: _getAdherenceColor(adherencePercentage),
                        value: adherencePercentage,
                        title: '',
                        radius: 4.w,
                        borderSide: BorderSide.none,
                      ),
                      PieChartSectionData(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        value: 100 - adherencePercentage,
                        title: '',
                        radius: 4.w,
                        borderSide: BorderSide.none,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${adherencePercentage.toInt()}%',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getAdherenceColor(adherencePercentage),
                      ),
                    ),
                    Text(
                      'Adherence',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Taken',
                takenMedications.toString(),
                AppTheme.accentLight,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildStatItem(
                'Remaining',
                (totalMedications - takenMedications).toString(),
                AppTheme.lightTheme.colorScheme.primary,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              _buildStatItem(
                'Total',
                totalMedications.toString(),
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getAdherenceColor(double percentage) {
    if (percentage >= 90) {
      return AppTheme.accentLight;
    } else if (percentage >= 70) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }
}
