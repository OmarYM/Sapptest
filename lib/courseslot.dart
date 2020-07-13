import 'course.dart';
import 'coursepage.dart';
import 'userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'mainPage.dart';

class CourseSlot extends StatelessWidget {
  final Course course;
  final Function function;
  final int index;
  CourseSlot({Key key, this.course, this.index, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 18,
          color: Colors.grey[800],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                onTap: () async {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CoursePage(
                          course: course,
                          index: index,
                          refreshLists: function,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      )).then((value) {
                    function();
                  });
                },
                contentPadding: EdgeInsets.all(0),
                //visualDensity: VisualDensity.compact,
                title: Center(
                    child: Text(
                  course.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
                subtitle: course.courseCode.isNotEmpty
                    ? Column(
                        children: [
                          Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                            course.courseCode,
                            textAlign: TextAlign.center,
                          ),
                              )),
                        ],
                      )
                    : null),
          ),
        ),
      ),
    );
  }
}

class CourseList extends StatefulWidget {
  final int day;
  final Function function;
  const CourseList({
    Key key,
    this.day,
    this.function,
  }) : super(key: key);

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  ScrollController _controller;
  int totalHours = 0;

  @override
  void initState() {
    periods.forEach((element) {
      totalHours += element.getPeriodLength;
    });

    _controller = ScrollController()
      ..addListener(() {
        upDirection =
            _controller.position.userScrollDirection == ScrollDirection.forward;

        // makes sure we don't call setState too much, but only when it is needed
        if (upDirection != flag) {
          flag = upDirection;
          scrollCheck.value = upDirection;
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      controller: _controller,
      itemBuilder: (context, index) {
        return index == 0
            ? Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Courses",
                    style: TextStyle(
                      fontSize: width / 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Number Of Courses: " + courses.length.toString(),
                      style: TextStyle(
                        fontSize: width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Length Of All Classes: " +
                          (totalHours / 60).toStringAsFixed(0) +
                          ":" +
                          (totalHours % 60).toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: width / 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 3,
                ),
              ])
            : courses.isEmpty
                ? EmptyMessage()
                : Hero(
                    tag: "coursetile$index",
                    child: Material(
                      type: MaterialType.transparency,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Material(
                            child: CourseSlot(
                              function: widget.function,
                              course: courses[index - 1],
                              index: index,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
      },
      itemCount: courses.isEmpty ? 2 : courses.length + 1,
    );
  }
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Seems Empty, Try Adding Some Courses!',
        ),
      ),
    );
  }
}
