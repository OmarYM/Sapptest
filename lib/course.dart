import 'package:flutter/material.dart';

class Course {
  String title = 'empty';
  String courseCode = '';
  String description = '';
  String id;

  Course({@required this.title, @required this.id, this.description, this.courseCode});

  Course.fromMap(Map<String, dynamic> json)
      : description = json['description'],
        courseCode = json['courseCode'],
        title = json['title'],
        id = json['id'];

  Map<String, dynamic> toMap() => {
        'description': description,
        'courseCode': courseCode,
        'title': title,
        'id': id,
      };

  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Course && other.title == title;
  }

  @override
  
  int get hashCode => title.hashCode;

}
