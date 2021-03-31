import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:diana/injection_container.dart' as di;

class LocalNotifications {
  static Future<void> initNotifications() async {
    final flutterLocalNotificationsPlugin =
        di.sl<FlutterLocalNotificationsPlugin>();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {});
  }
}
