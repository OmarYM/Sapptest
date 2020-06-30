import 'package:Sapptest/userdata.dart';

class Grade  {
  String title;
  String courseId;
  int order;
  String id;
  double grade = 0;
  double weight;

  Grade(this.id, this.grade, this.weight, 
      this.courseId, this.title, this.order);


  String get courseTitle {

    String result;

    courses.forEach((element) {
      if (element.id == courseId) {
        result = element.title;
      }
    });

    return result ?? '';
  }

  Grade.fromMap(Map<String, dynamic> json)
      : order = json['orderO'],
        courseId = json['courseId'],
        id = json['id'],
        grade = json['grade'],
        weight = json['weight'],
        title = json['title'];

  Map<String, dynamic> toMap() => {
        'orderO': order,
        'courseId': courseId,
        'id': id,
        'grade': grade,
        'weight': weight,
        'title': title
      };

}
