import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('taskbud_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  //Future<void> scheduleNotification(DateTime notificationTime,
  Future<void> scheduleNotification(
      String notificationTitle, String notificationBody) async {
    var androidDetails = AndroidNotificationDetails('channelId', 'channelName',
        importance: Importance.high, priority: Priority.high);
    var iOSDetails = DarwinNotificationDetails();
    var platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // await FlutterLocalNotificationsPlugin().schedule(0, notificationTitle,
    //     notificationBody, notificationTime, platformDetails);

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.Location timeZone = tz.getLocation(timeZoneName);

    // Set up the notification schedule
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      timeZone,
      now.year,
      now.month,
      now.day,
      9,
      0,
    );

    await FlutterLocalNotificationsPlugin().zonedSchedule(
        0,
        notificationTitle,
        notificationBody,
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails('channelId', 'channelName',
                importance: Importance.max),
            iOS: DarwinNotificationDetails()),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
