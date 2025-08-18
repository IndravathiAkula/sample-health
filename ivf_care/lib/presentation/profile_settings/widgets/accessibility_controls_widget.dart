import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AccessibilityControlsWidget extends StatelessWidget {
  final double fontSize;
  final bool highContrast;
  final bool screenReaderEnabled;
  final Function(double) onFontSizeChanged;
  final Function(bool) onHighContrastChanged;
  final Function(bool) onScreenReaderChanged;

  const AccessibilityControlsWidget({
    super.key,
    required this.fontSize,
    required this.highContrast,
    required this.screenReaderEnabled,
    required this.onFontSizeChanged,
    required this.onHighContrastChanged,
    required this.onScreenReaderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Font Size Adjustment
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'text_fields',
                      color: colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Font Size',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      'A',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 6,
                        onChanged: onFontSizeChanged,
                        activeColor: colorScheme.primary,
                        inactiveColor:
                            colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    Text(
                      'A',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Current size: ${fontSize.toInt()}sp',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),

          // High Contrast Toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'contrast',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'High Contrast',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Improves text readability',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: highContrast,
                  onChanged: onHighContrastChanged,
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),

          // Screen Reader Toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'accessibility',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Screen Reader Support',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Enhanced voice navigation',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: screenReaderEnabled,
                  onChanged: onScreenReaderChanged,
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
