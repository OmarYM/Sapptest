import 'dart:ui';

import 'dbhelper.dart';
import 'period.dart';
import 'sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'course.dart';
import 'grade.dart';

DBHelperPeriod dbperiods;
DBHelperCourse dbcourses;
DBHelperGrades dbGrades;

List<Period> periods;
List<Course> courses;
List<Grade> grades;

bool adspace;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
NotificationAppLaunchDetails notificationAppLaunchDetails;

bool isdark(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark;
}

Color oppositeAccent(BuildContext context) {
  return isdark(context) ? Colors.red[500] : Colors.tealAccent[200];
}

SharedPref prefs;

int nid;

bool courseCheck(String title) {
  bool result = false;

  courses.forEach((element) {
    if (element.title.toLowerCase().compareTo(title.toLowerCase()) == 0) {
      result = true;
      return;
    }
  });

  return result;
}

List<Period> allFromDay(int day) {
  List<Period> result = [];

  periods.forEach((element) {
    if (day == element.day) {
      result.add(element);
    }
  });

  return result;
}

List<Period> allPeriodsFromCourse(String id) {
  List<Period> result = [];

  periods.forEach((element) {
    if (id.compareTo(element.courseId) == 0) {
      result.add(element);
    }
  });

  return result;
}

List<Grade> allGradesFromCourse(String id) {
  List<Grade> result = [];

  grades.forEach((element) {
    if (id.compareTo(element.courseId) == 0) {
      result.add(element);
    }
  });

  return result;
}

void deleteCourse(Course course) {
  periods.forEach((element) {
    if (course.id.compareTo(element.courseId) == 0) {
      dbperiods.delete(element.id);
    }
  });

  dbcourses.delete(course.id);
}

String getCourseTitle(String id) {
  String result;

  courses.forEach((element) {
    if (element.id == id) {
      result = element.title;
    }
  });

  return result ?? '';
}

bool upDirection, flag;

Brightness brightness;

String getDayOfTheWeek(int day) {
  switch (day) {
    case 0:
      return 'Monday';

    case 1:
      return 'Tuesday';

    case 2:
      return 'Wednesday';

    case 3:
      return 'Thursday';

    case 4:
      return 'Friday';

    case 5:
      return 'Saturday';

    case 6:
      return 'Sunday';

    default:
      return 'Invalid -getDayOfTheWeek Method-';
  }
}
