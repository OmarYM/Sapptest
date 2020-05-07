import 'package:flutter/material.dart';



class Course{

  String title = 'empty';
  String courseCode = '';
  String description = '';

  Course({@required this.title, this.description, this.courseCode} );

  Course.fromMap(Map<String, dynamic> json)
      : description = json['description'],
        courseCode = json['courseCode'],
        title = json['title'];

  Map<String, dynamic> toMap() => {
        'description': description,
        'courseCode': courseCode,
        'title': title,
      };

}