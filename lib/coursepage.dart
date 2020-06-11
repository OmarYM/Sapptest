import 'package:Sapptest/course.dart';
import 'package:Sapptest/periodslot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'period.dart';
import 'userdata.dart';

class CoursePage extends StatefulWidget {
  final Course course;
  final int index;
  final Function refreshLists;

  CoursePage({Key key, this.course, this.index, this.refreshLists})
      : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int totalHours = 0;
  int numberOfCourses = 0;

  Future navigateToCoursePeriodsPage(context) async {
    Navigator.push(
            context,
            PageTransition(
                child: CoursePeriodList(
                  course: widget.course,
                  index: widget.index,
                ),
                type: PageTransitionType.rightToLeftWithFade,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200)))
        .then((value) {
      widget.refreshLists();
    });
  }

  @override
  void initState() {
    super.initState();
    var coursePeriods = allFromCourse(widget.course.id);

    coursePeriods.forEach((element) {
      totalHours += element.getPeriodLength;
    });

    numberOfCourses = coursePeriods.length;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Hero(
              tag: 'coursetile' + widget.index.toString(),
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Container(
                      child: Text(
                        widget.course.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )),
          //iconTheme: //MediaQuery.of(context).platformBrightness == Brightness.light
          //IconThemeData(
          // color: Colors.black,
          //),
          //: null,
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'This will delete this course and all periods associated with it!',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          CupertinoButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text('Cancel', style: TextStyle(color: Theme.of(context).accentColor))),
                          CupertinoButton(
                              onPressed: () {
                                deleteCourse(widget.course);
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              },
                              child: Text('Delete', style: TextStyle(color: Theme.of(context).accentColor),))
                        ],
                      );
                    },
                  );
                })
          ],
          backgroundColor:
              //MediaQuery.of(context).platformBrightness == Brightness.light
              //  ? Colors.grey[50]
              Colors.grey[850],
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Number Of Classes: " + numberOfCourses.toString(),
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
                  "Length Of Classes: " +
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
            ListTile(
              title: Text('Classes'),
              onTap: () => navigateToCoursePeriodsPage(context),
            ),
            Divider(
              height: 0,
              thickness: 2,
            ),
            ListTile(
              title: Text('Grades'),
            ),
          ],
        )

        //CoursePeriodList(course: widget.course,)
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
          'Seems Empty, Try Adding Some Periods!',
        ),
      ),
    );
  }
}
