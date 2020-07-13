import 'period.dart';
import 'userdata.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> scheduleWeeklyNotification(
    int hour, int minute, Period period, int day) async {
  //print(hour.toString() + ":" + minute.toString()+" day" + day.toString());
  var time = Time(hour, minute, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      period.id,
      period.title + ' ' + period.courseTitle,
      'Weekly notification for a' + period.title + ' for ' + period.courseTitle,
      importance: Importance.Max,
      priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      period.notificationId,
      '${period.title} Soon!',
      '${period.title} coming up for ${period.courseTitle}',
      Day((((day + 1) % 7) + 1)),
      time,
      platformChannelSpecifics);
}

Future<void> deleteNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

displayTimerNotification(bool isStudyTimer, int minutes) async {

  var scheduledNotificationDateTime = DateTime.now().add(Duration(minutes: minutes));
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Timer', 'Study Timer', 'Study/Break Timer Notification',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      isStudyTimer ? 'Study Timer' : 'Break Timer',
      isStudyTimer
          ? 'Study Timer is over! Start Your Break!'
          : 'Break Timer is Over! Start Studying!',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true);
}
