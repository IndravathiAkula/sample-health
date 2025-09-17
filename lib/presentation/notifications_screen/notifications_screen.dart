import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../l10n/app_localizations.dart';
import '../../services/notification_service.dart';
import './widgets/empty_notifications_widget.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_section_header_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadNotifications();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() => _isLoading = true);

      final notifications = await _notificationService.getNotificationHistory();

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load notifications: $e'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() => _isRefreshing = true);

    // Add haptic feedback for iOS
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      HapticFeedback.lightImpact();
    }

    await _loadNotifications();

    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notifications refreshed'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllNotificationsAsRead();
      await _loadNotifications();

      if (mounted) {
        HapticFeedback.selectionClick();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('All notifications marked as read'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark notifications as read: $e'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _dismissNotification(String notificationId) async {
    try {
      // Remove from local list with animation
      setState(() {
        _notifications.removeWhere((n) => n['id'] == notificationId);
      });

      // Mark as read in storage
      await _notificationService.markNotificationAsRead(notificationId);

      HapticFeedback.lightImpact();
    } catch (e) {
      // Reload notifications on error
      await _loadNotifications();
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _notificationService.markNotificationAsRead(notificationId);

      // Update local state
      setState(() {
        final index =
            _notifications.indexWhere((n) => n['id'] == notificationId);
        if (index != -1) {
          _notifications[index]['isRead'] = true;
        }
      });

      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }

  void _navigateToMedicationDetails(Map<String, dynamic> notification) {
    // Navigate to medication tracker screen
    Navigator.pushNamed(
      context,
      AppRoutes.medicationTrackerScreen,
      arguments: notification['payload'],
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupNotificationsByTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final grouped = <String, List<Map<String, dynamic>>>{
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Earlier': [],
    };

    for (final notification in _notifications) {
      final timestamp = DateTime.parse(notification['timestamp']);
      final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

      if (date.isAtSameMomentAs(today)) {
        grouped['Today']!.add(notification);
      } else if (date.isAtSameMomentAs(yesterday)) {
        grouped['Yesterday']!.add(notification);
      } else if (date.isAfter(weekAgo)) {
        grouped['This Week']!.add(notification);
      } else {
        grouped['Earlier']!.add(notification);
      }
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations?.notifications ?? "Notifications"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          // Add Home button
          IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.mainNavigationScreen,
              (route) => false,
            ),
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Dashboard',
          ),
          // Keep existing mark all as read button
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(localizations?.markAllAsRead ?? "Mark all as read"),
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notifications.isEmpty
              ? const EmptyNotificationsWidget()
              : RefreshIndicator(
                  onRefresh: _refreshNotifications,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildNotificationsList(),
                  ),
                ),
    );
  }

  Widget _buildNotificationsList() {
    final groupedNotifications = _groupNotificationsByTime();

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: groupedNotifications.length,
      itemBuilder: (context, sectionIndex) {
        final sectionTitle = groupedNotifications.keys.elementAt(sectionIndex);
        final notifications = groupedNotifications[sectionTitle]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sectionIndex > 0) SizedBox(height: 3.h),
            NotificationSectionHeaderWidget(title: sectionTitle),
            SizedBox(height: 1.h),
            ...notifications.asMap().entries.map((entry) {
              final index = entry.key;
              final notification = entry.value;

              return Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: NotificationCardWidget(
                  notification: notification,
                  onDismiss: () => _dismissNotification(notification['id']),
                  onMarkAsRead: () => _markAsRead(notification['id']),
                  onTap: () => _navigateToMedicationDetails(notification),
                  isLast: index == notifications.length - 1,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
