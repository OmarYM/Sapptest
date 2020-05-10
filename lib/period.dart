import 'dart:convert';

import 'package:Sapptest/course.dart';
import 'package:flutter/material.dart';

class Period implements Comparable{
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

  @override
  int compareTo(other){


    if(other == null || this == null){
      return null;
    }

     else if(this.day > other.day){
       print(1);
      return 1;

    } else if(this.day < other.day){
      print(2);

      return -1;
    
    } else {
      if(toInt(this.startTime) > toInt(this.startTime) ){
        print(3);

        return 1;

      } else if(toInt(this.startTime) < toInt(this.startTime)){
        print(4);

        return -1;

      } else {
        if(toInt(this.endTime) > toInt(this.endTime) ){
          print(5);

        return 1;

      } else if(toInt(this.endTime) < toInt(this.endTime)){
        print(6);

        return -1;

      } else{
        print(7);

        return 0;
      }

      }
    }

  }
}
