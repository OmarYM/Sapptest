import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';

class Period implements Comparable {
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);
  String courseId;
  int day;
  String id;
  int notification = -1;
  int notificationId;
  String title;

  Period(this.id, this.startTime, this.endTime, this.title, this.day,
      this.courseId, this.notification, this.notificationId);

  int get getPeriodLength {
    var result = toInt(endTime) - toInt(startTime);

    return result;
  }

  String get courseTitle {

    String result;

    courses.forEach((element) {
      if (element.id == courseId) {
        result = element.title;
      }
    });

    return result ?? '';
  }

  Period.fromMap(Map<String, dynamic> json)
      : startTime = fromInt(json['startTime']),
        endTime = fromInt(json['endTime']),
        day = json['day'],
        courseId = json['courseId'],
        id = json['id'],
        title = json['title'],
        notification = json['notification'],
        notificationId = json['notificationId'];

  Map<String, dynamic> toMap() => {
        'startTime': toInt(startTime),
        'endTime': toInt(endTime),
        'day': day,
        'courseId': courseId,
        'id': id,
        'title': title,
        'notification': notification,
        'notificationId': notificationId
      };

  int toInt(TimeOfDay t) {
    return t.hour * 60 + t.minute;
  }

  static TimeOfDay fromInt(int i) {
    int hour;
    int minute;

    if (i < 0) {
      int temp = i + 23 * 60 + 59;

      hour = temp ~/ 60;
      minute = temp % 60;
    } else {
      hour = i ~/ 60;
      minute = i % 60;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  String toString() {
    var sstr = startTime.toString();
    var estr = endTime.toString();
    var dstr = day.toString();
    var cstr = courseId.toString();

    var result =
        "startTime: $sstr\nendTime: $estr\nday: $dstr\ncourseId: $cstr\n";
    return result;
  }

  @override
  int compareTo(other) {
    if (other == null || this == null) {
      return null;
    } else if (this.day > other.day) {
      print(1);
      return 1;
    } else if (this.day < other.day) {
      print(2);

      return -1;
    } else {
      if (toInt(this.startTime) > toInt(this.startTime)) {
        print(3);

        return 1;
      } else if (toInt(this.startTime) < toInt(this.startTime)) {
        print(4);

        return -1;
      } else {
        if (toInt(this.endTime) > toInt(this.endTime)) {
          print(5);

          return 1;
        } else if (toInt(this.endTime) < toInt(this.endTime)) {
          print(6);

          return -1;
        } else {
          print(7);

          return 0;
        }
      }
    }
  }
}
