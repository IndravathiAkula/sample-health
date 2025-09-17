import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Request notification permissions
      if (!kIsWeb) {
        final status = await Permission.notification.request();
        if (!status.isGranted) {
          debugPrint('Notification permission denied');
          return;
        }
      }

      // Initialize platform-specific settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialize with callback for notification taps
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      _isInitialized = true;
      debugPrint('Notification service initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize notification service: $e');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _handleNotificationTap(data);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    // This would typically use a navigation service or global navigator
    debugPrint('Handle notification tap: $data');
    // TODO: Navigate to appropriate screen based on notification type
  }

  Future<void> scheduleMedicationReminder({
    required String medicationName,
    required DateTime scheduledTime,
    required String dosage,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      final id = medicationName.hashCode;
      final reminderTime = scheduledTime.subtract(const Duration(minutes: 15));

      if (reminderTime.isBefore(DateTime.now())) {
        debugPrint('Reminder time is in the past, skipping');
        return;
      }

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'medication_reminders',
        'Medication Reminders',
        channelDescription: 'Notifications for upcoming medication doses',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2E7D8F),
      );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      final payload = jsonEncode({
        'type': 'medication_reminder',
        'medicationName': medicationName,
        'dosage': dosage,
        'scheduledTime': scheduledTime.toIso8601String(),
      });

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Time for your medication in 15 minutes',
        '$medicationName ($dosage) is due at ${_formatTime(scheduledTime)}',
        tz.TZDateTime.from(reminderTime, tz.local),
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('Medication reminder scheduled for $reminderTime');
      await _saveNotificationToHistory(
        'Medication Reminder',
        '$medicationName ($dosage) is due at ${_formatTime(scheduledTime)}',
        'medication_reminder',
        payload,
      );
    } catch (e) {
      debugPrint('Failed to schedule medication reminder: $e');
    }
  }

  Future<void> scheduleMissedDoseNotification({
    required String medicationName,
    required DateTime scheduledTime,
    required String dosage,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      final id = (medicationName + '_missed').hashCode;
      final missedTime = scheduledTime.add(const Duration(minutes: 30));

      if (missedTime.isBefore(DateTime.now())) {
        debugPrint('Missed dose time is in the past, skipping');
        return;
      }

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'missed_medications',
        'Missed Medications',
        channelDescription: 'Notifications for missed medication doses',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFFF4A261),
      );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      final payload = jsonEncode({
        'type': 'missed_dose',
        'medicationName': medicationName,
        'dosage': dosage,
        'scheduledTime': scheduledTime.toIso8601String(),
      });

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Looks like you missed your dose — please take it as soon as possible',
        '$medicationName ($dosage) was due at ${_formatTime(scheduledTime)}',
        tz.TZDateTime.from(missedTime, tz.local),
        notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('Missed dose notification scheduled for $missedTime');
    } catch (e) {
      debugPrint('Failed to schedule missed dose notification: $e');
    }
  }

  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
    String type = 'general',
  }) async {
    if (!_isInitialized) await initialize();

    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'general_notifications',
        'General Notifications',
        channelDescription: 'General app notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF2E7D8F),
      );

      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      await _saveNotificationToHistory(title, body, type, payload);
    } catch (e) {
      debugPrint('Failed to show immediate notification: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) await initialize();
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) await initialize();
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _saveNotificationToHistory(
    String title,
    String body,
    String type,
    String? payload,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotificationHistory();

      final notification = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'body': body,
        'type': type,
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
        'payload': payload,
      };

      notifications.insert(0, notification);

      // Keep only the last 50 notifications
      if (notifications.length > 50) {
        notifications.removeRange(50, notifications.length);
      }

      await prefs.setString('notification_history', jsonEncode(notifications));
    } catch (e) {
      debugPrint('Failed to save notification to history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationData = prefs.getString('notification_history');

      if (notificationData != null) {
        final List<dynamic> decoded = jsonDecode(notificationData);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('Failed to get notification history: $e');
    }
    return [];
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotificationHistory();

      final index = notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        notifications[index]['isRead'] = true;
        await prefs.setString(
            'notification_history', jsonEncode(notifications));
      }
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = await getNotificationHistory();

      for (var notification in notifications) {
        notification['isRead'] = true;
      }

      await prefs.setString('notification_history', jsonEncode(notifications));
    } catch (e) {
      debugPrint('Failed to mark all notifications as read: $e');
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final notifications = await getNotificationHistory();
      return notifications.where((n) => !n['isRead']).length;
    } catch (e) {
      debugPrint('Failed to get unread notification count: $e');
      return 0;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
