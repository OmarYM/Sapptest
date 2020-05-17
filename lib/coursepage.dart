import 'package:Sapptest/course.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'period.dart';
import 'userdata.dart';

class CoursePage extends StatefulWidget {
  final Course course;
  final int index;

  CoursePage({Key key, this.course, this.index}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<Period> coursePeriods;

  @override
  void initState() {
    coursePeriods = allFromCourse(widget.course.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    coursePeriods = allFromCourse(widget.course.title);

    return Scaffold(
      appBar: AppBar(
        iconTheme: MediaQuery.of(context).platformBrightness == Brightness.light
            ? IconThemeData(
                color: Colors.black,
              )
            : null,
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Are You Sure?',
                      ),
                      actions: [
                        CupertinoButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('No')),
                        CupertinoButton(
                            onPressed: () {
                              deleteCourse(widget.course);
                              int count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 2;
                              });
                            },
                            child: Text('Yes'))
                      ],
                    );
                  },
                );
              })
        ],
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[850],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0
              ? Hero(
                  tag: 'coursetile' + widget.index.toString(),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          widget.course.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ))
              : coursePeriods.isEmpty
                  ? EmptyMessage()
                  : PeriodSlot(period: coursePeriods[index - 1]);
        },
        itemCount: coursePeriods.isEmpty ? 2 : coursePeriods.length + 1,
      ),
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

class PeriodSlot extends StatefulWidget {
  final int index;

  final Period period;

  PeriodSlot({
    Key key,
    @required this.period,
    this.index,
  }) : super(key: key);

  @override
  _PeriodSlotState createState() => _PeriodSlotState();
}

class _PeriodSlotState extends State<PeriodSlot> with TickerProviderStateMixin {
  bool selected;
  bool deleted;

  @override
  void initState() {
    selected = false;
    deleted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //print(index.toString());
    return AnimatedSize(
      curve: Curves.bounceOut,
      vsync: this,
      duration: Duration(milliseconds: 400),
      child: Container(
        height: deleted ? 0 : null,
        width: deleted ? 0 : null,
        child: Stack(children: [
          deleted
              ? Container()
              : ListTile(
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          deleted = true;
                          periods.remove(widget.period);
                          dbperiods.delete(widget.period.id);
                        });
                      }),
                ),
          AnimatedContainer(
            curve: Curves.bounceOut,
            width: selected ? width * 0.8 : width,
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[850],
            //padding: EdgeInsets.only(right: selected ? 100 : 0),
            duration: Duration(milliseconds: 500),
            child: ListTile(
              onLongPress: () {
                setState(() {
                  selected = true;
                });
              },
              onTap: () {
                setState(() {
                  selected = false;
                });
              },
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(child: Text(widget.period.course.title)),
              ),
              subtitle: Column(
                children: [
                  Center(child: Text(widget.period.title)),
                  Center(child: Text(getDayOfTheWeek(widget.period.day))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.period.startTime.format(context)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.period.endTime.format(context)),
                      )
                    ],
                  ),
                  Divider(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
