import 'package:Sapptest/course.dart';
import 'package:Sapptest/periodslot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'userdata.dart';
import 'dbhelper.dart';
import 'period.dart';
import 'periodInput.dart';
import 'courseinput.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool upDirection = true, flag = true;
  ScrollController _controller;

  @override
  void initState() {
    dbperiods = DBHelperPeriod();
    dbcourses = DBHelperCourse();

    dbperiods.deleteTable();
    dbcourses.deleteTable();

    //dbcourses.createTable();
    //dbperiods.createTable();

    periods = [];
    courses = [];

    refreshLists();

    _controller = ScrollController()
      ..addListener(() {
        upDirection =
            _controller.position.userScrollDirection == ScrollDirection.forward;

        // makes sure we don't call setState too much, but only when it is needed
        if (upDirection != flag) setState(() {});
        flag = upDirection;
      });

    //print(periods.toString());

    super.initState();
  }

  refreshLists() {
    setState(() {
      dbperiods.getPeriods().then((value) {
        if (value.isNotEmpty) {
          setState(() {
            periods = value;
          });
        }
      });
      dbcourses.getCourses().then((value) {
        if (value.isNotEmpty) {
          setState(() {
            courses = value;
          });
        }
      });
    });
  }

  Future navigateToPeriodPage(context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => PeriodInput()))
        .then((value) {
      refreshLists();
    });
  }

  Future navigateToCoursePage(context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CourseInput()))
        .then((value) {
      refreshLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MainPage')),
      body: PeriodList(),
      floatingActionButton: upDirection
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Add A Period'),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  FloatingActionButton(
                    heroTag: 'period',
                    onPressed: () {
                      navigateToPeriodPage(context);
                    },
                    child: Text('P',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Add A Course'),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  FloatingActionButton(
                    heroTag: 'course',
                    onPressed: () {
                      navigateToCoursePage(context);
                    },
                    child: Text('C',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ],
              ),
            ])
          : Container(),
    );
  }
}
