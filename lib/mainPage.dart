import 'package:Sapptest/PeriodInput.dart';
import 'package:Sapptest/addbutton.dart';
import 'package:Sapptest/pagetransitions.dart';
import 'package:Sapptest/period.dart';
import 'package:Sapptest/periodslot.dart';
import 'package:Sapptest/settingsPage.dart';
import 'package:Sapptest/sharedPrefs.dart';
import 'package:Sapptest/studytimerpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'courseslot.dart';
import 'time.dart';
import 'userdata.dart';
import 'dbhelper.dart';
import 'courseinput.dart';
import 'package:infinity_page_view/infinity_page_view.dart';

ValueNotifier<bool> scrollCheck = ValueNotifier(true);
bool click;
bool click1;
bool appear;
bool disappear;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  InfinityPageController page;
  int today;

  @override
  void initState() {
    prefs = SharedPref();

    prefs.getId().then((value) => nid = value ?? 1);

    upDirection = true;
    flag = true;
    click = false;
    click1 = false;
    appear = true;
    disappear = true;

    today = DateTime.now().weekday;
    page = InfinityPageController(initialPage: 0);

    dbperiods = DBHelperPeriod();
    dbcourses = DBHelperCourse();
    dbGrades = DBHelperGrades();

    periods = [];
    courses = [];
    dbGrades.getGrades().then((value) => grades = value);

    refreshLists();

    super.initState();
  }

  void refreshLists() {
    dbperiods.getPeriods().then((value) {
      if (value != null) {
        setState(() {
          periods = value;
        });
      }
    });
    dbcourses.getCourses().then((value) {
      if (value != null) {
        setState(() {
          courses = value;
        });
      }
    });
  }

  Future navigateToSettingsPage(context) async {
    Navigator.push(
            context,
            SlideRightLeftRoute(
                enterWidget: SettingsPage(), curve: Curves.ease))
        .then((value) {
      refreshLists();
    });
  }

  Future navigateToPeriodInputPage(context) async {
    Navigator.push(context,
            SlideRightLeftRoute(enterWidget: PeriodInput(), curve: Curves.ease))
        .then((value) {
      refreshLists();
    });
  }

  Future navigateToCourseInputPage(context) async {
    Navigator.push(context,
            SlideRightLeftRoute(enterWidget: CourseInput(), curve: Curves.ease))
        .then((value) {
      refreshLists();
    });
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Time(),
                            Divider(
                              thickness: 3,
                              height: 0,
                            ),
                          ],
                        ),
                        Expanded(
                          child: InfinityPageView(
                              controller: page,
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                return PeriodList(
                                  day: today + index,
                                  refresh: refreshLists,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: CourseList(
                            function: refreshLists,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(child: StudyTimerPage()),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: AddButton(
                                  route: navigateToCourseInputPage,
                                  title: 'Course',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: AddButton(
                                  route: navigateToPeriodInputPage,
                                  title: 'Period',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: AddButton(
                                  route: navigateToSettingsPage,
                                  title: 'Settings',
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: 0,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: TabBar(
                        labelColor: Colors.grey[50],
                        labelPadding: EdgeInsets.zero,
                        tabs: [
                          Tab(
                              icon: Icon(
                            Icons.home,
                          )),
                          Tab(
                              icon: Icon(
                            Icons.school,
                          )),
                          Tab(
                              icon: Icon(
                            Icons.timer,
                          )),
                          Tab(
                              icon: Icon(
                            Icons.add,
                          )),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }
}
