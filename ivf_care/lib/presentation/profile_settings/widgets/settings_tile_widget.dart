import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconName;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool showArrow;
  final Color? titleColor;
  final Color? subtitleColor;

  const SettingsTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.iconName,
    this.leadingWidget,
    this.trailingWidget,
    this.onTap,
    this.showArrow = true,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            // Leading icon or widget
            if (leadingWidget != null)
              leadingWidget!
            else if (iconName != null)
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName!,
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),

            if (leadingWidget != null || iconName != null) SizedBox(width: 3.w),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: titleColor ?? colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subtitleColor ??
                            colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget or arrow
            if (trailingWidget != null)
              trailingWidget!
            else if (showArrow && onTap != null)
              CustomIconWidget(
                iconName: 'chevron_right',
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }
}
