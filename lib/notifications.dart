import 'package:Sapptest/period.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> scheduleWeeklyNotification(
    int hour, int minute, Period period, int day) async {
      //print(hour.toString() + ":" + minute.toString()+" day" + day.toString());
  var time = Time(hour, minute, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      period.id,
      period.title + ' ' + period.courseTitle,
      'Weekly notification for a' +
          period.title +
          ' for ' +
          period.courseTitle,
          importance: Importance.Max,
          priority: Priority.High
          );
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
