import 'dart:ui';

import 'package:Sapptest/dbhelper.dart';
import 'package:Sapptest/period.dart';
import 'package:Sapptest/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'course.dart';


DBHelperPeriod dbperiods;
DBHelperCourse dbcourses;

List<Period> periods;
List<Course> courses;



SharedPref prefs;

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
    if (title.toLowerCase().compareTo(element.course.title.toLowerCase()) == 0) {
      result.add(element);

    }
  });

  return result;
}

void deleteCourse(Course course){
  periods.forEach((element) {
    if (course.title.toLowerCase().compareTo(element.course.title.toLowerCase()) == 0) {
      dbperiods.delete(element.id);
      //periods.remove(element);
      
    }   
  });

  dbcourses.delete(course.title);
  courses.remove(course);
   
}

bool upDirection, flag ;

Brightness brightness;

int id;

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