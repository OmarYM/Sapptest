import 'dart:convert';

import 'package:Sapptest/course.dart';
import 'package:flutter/material.dart';

class Period {
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);
  Course course = Course(title: '') ;
  int day;
  String title;

  Period(this.startTime, this.endTime, this.title, this.day, this.course);

  Period.fromMap(Map<String, dynamic> json)
      : startTime = fromInt(json['startTime']),
        endTime = fromInt(json['endTime']),
        day = json['day'],
        course = Course.fromMap(jsonDecode(json['course'])),
        title = json['title'];

  Map<String, dynamic> toMap() => {
        'startTime': toInt(startTime),
        'endTime': toInt(endTime),
        'day': day,
        'course': jsonEncode(course.toMap()),
        'title': title,
      };


      int toInt(TimeOfDay t){
        return t.hour*100+t.minute;
      }

      static TimeOfDay fromInt(int i){

        int hour = i~/100;
        int minute = i%100;
        
        return TimeOfDay(hour: hour, minute: minute);
      }

      @override
  String toString() {

    var sstr = startTime.toString();
    var estr = endTime.toString();
    var dstr = day.toString();
    var cstr = course.title;
    
    var result = "startTime: $sstr\nendTime: $estr\nday: $dstr\ncourse: $cstr\n";
    return result;
  }
}
