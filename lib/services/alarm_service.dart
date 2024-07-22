import 'dart:isolate';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:psle/services/api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AlarmService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ApiService apiService = ApiService();

  // 알람 초기화 설정
  Future<void> initializeNotifications() async {
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: darwinInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // 알람을 즉각적으로 보내는 함수
  Future<void> sendImmediateAlarm(int alarmId) async {
    var darwinPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChnnelSpecifics = NotificationDetails(
      iOS: darwinPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      alarmId,
      'PSLE',
      '검사할 시간입니다.',
      platformChnnelSpecifics,
      payload: alarmId.toString(),
    );
  }

  // 최근 기록을 검사하는 함수
  Future<bool> checkRecentLog() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    if (userId == null) return false;

    try {
      final recentLogTime = await apiService.getLastRecordDateTime(userId);
      final now = DateTime.now();
      if (recentLogTime != null &&
          now.difference(recentLogTime).inMinutes <= 20) {
        debugPrint("최근 20분 이내에 기록이 있습니다.");
        return true;
      } else {
        debugPrint("최근 20분 이내에 기록이 없습니다.");
        return false;
      }
    } catch (e) {
      debugPrint("Error checking recent log: $e");
      return false;
    }
  }

  Future<void> checkAndTriggerAlarm(int alarmId) async {
    debugPrint("checkAndTriggerAlarm 호출됨");
    final hasRecentLog = await checkRecentLog();
    if (!hasRecentLog) {
      debugPrint("알람을 보냅니다.");
      await sendImmediateAlarm(alarmId);
    } else {
      debugPrint("알람을 보내지 않습니다.");
    }
  }

  // 알람 체크를 예약하는 함수
  Future<void> scheduleCheckAlarm(DateTime alarmTime, int alarmId) async {
    final checkTime = tz.TZDateTime.from(alarmTime, tz.local);

    if (checkTime.isAfter(DateTime.now())) {
      Timer(checkTime.difference(DateTime.now()), () async {
        await checkAndTriggerAlarm(alarmId);
      });
    }
  }

  // 알람 동기화
  Future<void> syncAlarmTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final loginId = prefs.getString('loginId');
    final password = prefs.getString('password');
    if (loginId == null || password == null) return;

    try {
      final user = await apiService.postUser(loginId, password);
      final alarmTimes = user.alarmTimes?.map((timeString) {
            final timeParts = timeString.split(':');
            final now = DateTime.now();
            return DateTime(now.year, now.month, now.day,
                int.parse(timeParts[0]), int.parse(timeParts[1]));
          }).toList() ??
          [];
      for (var i = 0; i < alarmTimes.length; i++) {
        final alarmDateTime = alarmTimes[i];
        await scheduleCheckAlarm(alarmDateTime, i);
      }
    } catch (e) {
      debugPrint("Error syncing alarm times: $e");
    }
  }
}
