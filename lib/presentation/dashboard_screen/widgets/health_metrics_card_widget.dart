import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthMetricsCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> healthMetrics;
  final VoidCallback? onLogNewReading;

  const HealthMetricsCardWidget({
    super.key,
    required this.healthMetrics,
    this.onLogNewReading,
  });

  @override
  Widget build(BuildContext context) {
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
                  iconName: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Health Metrics',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onLogNewReading,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text(
                    'Log Reading',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            healthMetrics.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'analytics',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 12.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No recent health metrics',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Tap "Log Reading" to add your vitals',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: healthMetrics.length,
                    itemBuilder: (context, index) {
                      final metric = healthMetrics[index];
                      final String type = metric['type'] ?? 'Unknown';
                      final String value = metric['value'] ?? '0';
                      final String unit = metric['unit'] ?? '';
                      final String trend = metric['trend'] ?? 'stable';
                      final String lastUpdated =
                          metric['lastUpdated'] ?? 'Never';

                      Color trendColor;
                      IconData trendIcon;

                      switch (trend.toLowerCase()) {
                        case 'up':
                          trendColor = AppTheme.lightTheme.colorScheme.error;
                          trendIcon = Icons.trending_up;
                          break;
                        case 'down':
                          trendColor = AppTheme.lightTheme.colorScheme.tertiary;
                          trendIcon = Icons.trending_down;
                          break;
                        default:
                          trendColor =
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant;
                          trendIcon = Icons.trending_flat;
                      }

                      return Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: _getMetricColor(type)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: _getMetricIcon(type),
                                    color: _getMetricColor(type),
                                    size: 4.w,
                                  ),
                                ),
                                const Spacer(),
                                CustomIconWidget(
                                  iconName: trendIcon.codePoint.toString(),
                                  color: trendColor,
                                  size: 4.w,
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              type,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    value,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: _getMetricColor(type),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  unit,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              lastUpdated,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
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

  Color _getMetricColor(String type) {
    switch (type.toLowerCase()) {
      case 'blood pressure':
      case 'bp':
        return AppTheme.lightTheme.colorScheme.error;
      case 'weight':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'glucose':
      case 'blood sugar':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'heart rate':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getMetricIcon(String type) {
    switch (type.toLowerCase()) {
      case 'blood pressure':
      case 'bp':
        return 'monitor_heart';
      case 'weight':
        return 'scale';
      case 'glucose':
      case 'blood sugar':
        return 'water_drop';
      case 'heart rate':
        return 'favorite';
      default:
        return 'analytics';
    }
  }
}
