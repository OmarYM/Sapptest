import 'package:Sapptest/periodslot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'time.dart';
import 'userdata.dart';
import 'dbhelper.dart';
import 'periodInput.dart';
import 'courseinput.dart';
import 'package:infinity_page_view/infinity_page_view.dart';

ValueNotifier<bool> scrollCheck = ValueNotifier(true);

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  InfinityPageController page;
  int today;

  @override
  void initState() {
    today = DateTime.now().weekday;
    page = InfinityPageController(initialPage: 0);

    dbperiods = DBHelperPeriod();
    dbcourses = DBHelperCourse();

    dbperiods.deleteTable();
    dbcourses.deleteTable();

    //dbcourses.createTable();
    //dbperiods.createTable();

    periods = [];
    courses = [];

    refreshLists();

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
    return ValueListenableBuilder(
        valueListenable: scrollCheck,
        builder: (context, bool upDirection, Widget child) {
          return Scaffold(
            appBar: AppBar(title: Text('MainPage')),
            body: Column(
              children: [
                Time(),
                Expanded(
                  child: InfinityPageView(
                      controller: page,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return PeriodList(day: today + index);
                      }),
                ),
              ],
            ),
            floatingActionButton: AnimatedOpacity(
          opacity: upDirection ? 0 : 1,
          duration: Duration(milliseconds: 300),
          child: 
         Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonSubtitle(
                          title: 'Add A Period',
                        ),
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
                        ButtonSubtitle(
                          title: 'Add A Course',
                        ),
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
                  ]),
            ),
          );
        });
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }
}

class ButtonSubtitle extends StatelessWidget {
  final title;

  const ButtonSubtitle({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.black12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Stack(children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.black,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ]),
        ));
  }
}
