import 'package:Sapptest/dbhelper.dart';
import 'package:Sapptest/period.dart';
import 'course.dart';
import 'package:flutter/material.dart';

DBHelperPeriod dbperiods;
DBHelperCourse dbcourses;

List<Period> periods;
List<Course> courses;

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

List<Period> allFromCourse(String title) {
  List<Period> result = [];

  periods.forEach((element) {
    if (title.toLowerCase().compareTo(element.title.toLowerCase()) == 0) {
      result.add(element);
    }
  });

  return result;
}
