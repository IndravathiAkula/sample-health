import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotificationCardWidget extends StatefulWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onDismiss;
  final VoidCallback onMarkAsRead;
  final VoidCallback onTap;
  final bool isLast;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    required this.onDismiss,
    required this.onMarkAsRead,
    required this.onTap,
    this.isLast = false,
  });

  @override
  State<NotificationCardWidget> createState() => _NotificationCardWidgetState();
}

class _NotificationCardWidgetState extends State<NotificationCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  Color _getNotificationColor() {
    final type = widget.notification['type'] as String;
    switch (type) {
      case 'medication_reminder':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'missed_dose':
        return const Color(0xFFF4A261); // Warm amber for missed doses
      case 'appointment':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'lab_result':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getNotificationIcon() {
    final type = widget.notification['type'] as String;
    switch (type) {
      case 'medication_reminder':
      case 'missed_dose':
        return Icons.medication_liquid;
      case 'appointment':
        return Icons.calendar_today;
      case 'lab_result':
        return Icons.assignment;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp() {
    final timestamp = DateTime.parse(widget.notification['timestamp']);
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM dd, h:mm a').format(timestamp);
    }
  }

  Widget _buildNotificationIndicator() {
    final isRead = widget.notification['isRead'] as bool;
    final color = _getNotificationColor();

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Icon(
        _getNotificationIcon(),
        color: color,
        size: 6.w,
      ),
    );
  }

  Widget _buildUnreadDot() {
    final isRead = widget.notification['isRead'] as bool;
    if (isRead) return const SizedBox.shrink();

    return Container(
      width: 2.w,
      height: 2.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(1.w),
      ),
    );
  }

  String _getEncouragingMessage() {
    final type = widget.notification['type'] as String;
    if (type == 'missed_dose') {
      final messages = [
        "Don't worry, you can still take your dose!",
        "It's okay, just take it when you can.",
        "No stress — you're doing great overall!",
        "Small slip-ups happen to everyone.",
      ];
      return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isRead = widget.notification['isRead'] as bool;
    final title = widget.notification['title'] as String;
    final body = widget.notification['body'] as String;
    final type = widget.notification['type'] as String;
    final encouragingMessage = _getEncouragingMessage();

    return Dismissible(
      key: Key(widget.notification['id']),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Swipe left - dismiss
          return true;
        } else if (direction == DismissDirection.startToEnd) {
          // Swipe right - mark as read
          widget.onMarkAsRead();
          return false;
        }
        return false;
      },
      onDismissed: (direction) {
        widget.onDismiss();
      },
      background: Container(
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            Icon(
              Icons.mark_email_read,
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Mark as Read',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Dismiss',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.clear,
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: () {
          HapticFeedback.selectionClick();
          if (!isRead) widget.onMarkAsRead();
          widget.onTap();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: !isRead
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIndicator(),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                    color: isRead
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildUnreadDot(),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            body,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isRead
                                  ? AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.8)
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (encouragingMessage.isNotEmpty) ...[
                            SizedBox(height: 1.h),
                            Text(
                              encouragingMessage,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: const Color(0xFFF4A261),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTimestamp(),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              if (type == 'medication_reminder' ||
                                  type == 'missed_dose')
                                Row(
                                  children: [
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                      size: 4.w,
                                    ),
                                    Text(
                                      'View Details',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
