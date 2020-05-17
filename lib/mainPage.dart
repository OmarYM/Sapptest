import 'package:Sapptest/periodslot.dart';
import 'package:Sapptest/settingsPage.dart';
import 'package:Sapptest/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'courseslot.dart';
import 'time.dart';
import 'userdata.dart';
import 'dbhelper.dart';
import 'periodInput.dart';
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

    //dbperiods.deleteTable();
    //dbcourses.deleteTable();

    //dbcourses.createTable();
    //dbperiods.createTable();

    prefs.getId().then((value) => id = value ?? 0);

    periods = [];
    courses = [];

    refreshLists();

    //print(periods.toString());

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
            MaterialPageRoute(
                builder: (context) => SettingsPage(parentContext: context)))
        .then((value) {
      refreshLists();
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          //title: Text('MainPage'),
          leading: Container(),
          actions: [
            IconButton(
                icon: Icon(Icons.dehaze),
                onPressed: () {
                  _openDrawer();
                }),
            Flexible(
              fit: FlexFit.loose,
              child: TabBar(tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.school))
              ]),
            ),
          ],
        ),
        drawer: Drawer(
          child: Scaffold(
            appBar: AppBar(
              
            ),
                      body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text('This is the Drawer'),
                RaisedButton(
                  onPressed: _closeDrawer,
                  child: const Text('Close Drawer'),
                ),
                Expanded(child: Container()),
                Divider(height: 5),
                Center(
            child: FlatButton(
            onPressed: () {
              navigateToSettingsPage(context);
            },
            child: Text('Settings'))),
            Divider(height: 5),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
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
            Column(children: [
              Expanded(
                child: CourseList(),
              )
            ]),
          ],
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: scrollCheck,
          builder: (context, bool upDirection, Widget child) {
            if (appear != upDirection) {
              Future.delayed(Duration(milliseconds: 0), () {
                setState(() {
                  Future.delayed(Duration(milliseconds: 200), () {
                    appear = upDirection;
                  });

                  if (click & !upDirection) {
                    click = false;
                    click1 = false;
                  }
                });
              });
            }

            return Stack(alignment: Alignment.bottomRight, children: [
              DoubleButton(
                function: refreshLists,
              ),
              AnimatedContainer(
                margin: EdgeInsets.only(
                  bottom: appear ? 0 : 22,
                  right: appear ? 0 : 30,
                ),
                alignment: Alignment.center,
                duration: Duration(milliseconds: 300),
                width: appear ? 60 : 0,
                height: appear ? 60 : 0,
                child: FloatingActionButton(
                  heroTag: 'add',
                  onPressed: () {
                    setState(() {
                      if (click1) {
                        click1 = !click1;
                      } else {
                        click = !click;
                        disappear = false;
                      }
                    });
                  },
                  child: Stack(children: [
                    Text(
                      '+',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      "+",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                ),
              ),
            ]);
          },
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

class DoubleButton extends StatefulWidget {
  final Function function;
  const DoubleButton({
    Key key,
    this.function,
  }) : super(key: key);

  @override
  _DoubleButtonState createState() => _DoubleButtonState();
}

class _DoubleButtonState extends State<DoubleButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        AnimatedPositioned(
            bottom: click & upDirection ? 125 : 7,
            right: 6,
            duration: Duration(milliseconds: 300),
            onEnd: () {
              setState(() {
                if (click) {
                  click1 = click;
                } else {
                  disappear = true;
                }
              });
            },
            curve: Curves.bounceInOut,
            child: Opacity(
                opacity: disappear ? 0 : 1,
                child: AddButton(
                  title: 'Add Period',
                  function: widget.function,
                  icon: 'P',
                  tag: 'period',
                ))),
        AnimatedPositioned(
            bottom: click1 & upDirection ? 70 : 7,
            right: 6,
            duration: Duration(milliseconds: 300),
            onEnd: () {
              setState(() {
                if (!click1) {
                  click = click1;
                }
                if (appear && !upDirection) {
                  appear = upDirection;
                }
              });
            },
            curve: Curves.bounceInOut,
            child: Opacity(
                opacity: disappear ? 0 : 1,
                child: AddButton(
                  title: 'Add Course',
                  function: widget.function,
                  icon: 'C',
                  tag: 'course',
                ))),
      ],
    );
  }
}

class AddButton extends StatelessWidget {
  final title, tag, function, icon;

  const AddButton({
    Key key,
    this.title,
    this.tag,
    this.function,
    this.icon,
  }) : super(key: key);

  Future navigateToPeriodPage(context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => PeriodInput()))
        .then((value) {
      function();
    });
  }

  Future navigateToCoursePage(context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CourseInput()))
        .then((value) {
      function();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedOpacity(
          opacity: click1 & upDirection ? 1 : 0,
          duration: Duration(milliseconds: 100),
          child: ButtonSubtitle(
            title: title,
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 8)),
        FloatingActionButton(
          mini: true,
          heroTag: tag,
          onPressed: () {
            if (icon == 'P') {
              navigateToPeriodPage(context);
            } else {
              navigateToCoursePage(context);
            }
          },
          child: Stack(children: [
            Text(
              icon,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.black,
              ),
            ),
            Text(
              icon,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
            ),
          ]),
        ),
      ],
    );
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
          //color: Colors.black12,
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
