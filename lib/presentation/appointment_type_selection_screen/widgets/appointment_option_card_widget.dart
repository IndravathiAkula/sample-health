import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppointmentOptionCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String iconName;
  final Color accentColor;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? iconColor;
  final double? iconSize;

  const AppointmentOptionCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.iconName,
    required this.accentColor,
    required this.onTap,
    this.isEnabled = true,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  State<AppointmentOptionCardWidget> createState() =>
      _AppointmentOptionCardWidgetState();
}

class _AppointmentOptionCardWidgetState
    extends State<AppointmentOptionCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled) {
      setState(() => _isPressed = true);
      _scaleController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetAnimation();
  }

  void _handleTapCancel() {
    _resetAnimation();
  }

  void _resetAnimation() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isEnabled ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: widget.isEnabled
                    ? AppTheme.lightTheme.colorScheme.surface
                    : AppTheme.lightTheme.colorScheme.surface.withAlpha(153),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isPressed && widget.isEnabled
                      ? widget.accentColor
                      : widget.isEnabled
                          ? AppTheme.lightTheme.dividerColor
                          : AppTheme.lightTheme.dividerColor.withAlpha(128),
                  width: _isPressed && widget.isEnabled ? 2 : 1,
                ),
                boxShadow: widget.isEnabled
                    ? [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow
                              .withAlpha(20),
                          blurRadius: _isPressed ? 12 : 6,
                          offset: Offset(0, _isPressed ? 4 : 2),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon container
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: widget.isEnabled
                              ? widget.accentColor.withAlpha(38)
                              : widget.accentColor.withAlpha(13),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: widget.iconName,
                            color: widget.isEnabled
                                ? widget.accentColor
                                : widget.accentColor.withAlpha(102),
                            size: 8.w,
                          ),
                        ),
                      ),

                      Spacer(),

                      // Arrow icon
                      CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        color: widget.isEnabled
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withAlpha(102),
                        size: 20,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Title
                  Text(
                    widget.title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.isEnabled
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withAlpha(153),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Description
                  Text(
                    widget.description,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: widget.isEnabled
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withAlpha(128),
                      height: 1.4,
                    ),
                  ),

                  if (!widget.isEnabled) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.errorContainer
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.error
                                .withAlpha(179),
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "Currently unavailable",
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withAlpha(179),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
