import 'dart:async';

import 'package:Sapptest/PeriodInput.dart';
import 'package:Sapptest/mainPage.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'course.dart';
import 'period.dart';

class PeriodSlot extends StatefulWidget {
  final int index;
  final String title;
  final String subtitle;
  final Period period;
  final bool isNext;
  final Function refresh;

  PeriodSlot({
    Key key,
    @required this.period,
    this.index,
    this.isNext,
    this.refresh,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  _PeriodSlotState createState() => _PeriodSlotState();
}

class _PeriodSlotState extends State<PeriodSlot> with TickerProviderStateMixin {
  bool selected;
  bool deleted;

  Future navigateToPeriodPage(context) async {
    Navigator.push(
            context,
            PageTransition(
                child: PeriodInput(
                  period: widget.period,
                ),
                type: PageTransitionType.rightToLeftWithFade,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200)))
        .then((value) {
      widget.refresh();
      setState(() {
        selected = false;
      });
    });
  }

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
    var times = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              widget.period.startTime.format(context),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.period.endTime.format(context),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );

    var periodTitle = Container(
      width: width * 0.6,
      child: Column(
        children: [
          Center(
              child: Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4.copyWith(
                  fontSize: 15,
                ),
          )),
          times,
        ],
      ),
    );

    var courseTitle = Column(children: [
      Center(
        child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Container(
              width: widget.isNext ? width * 0.7 : width,
              child: Center(
                  child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                
                      fontSize: 20,
                    ),
              )),
            )),
      ),
      periodTitle,
    ]);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 18,
        color: Colors.grey[800],
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: InkWell(
          onLongPress: () {
            setState(() {
              selected = !selected;
            });
          },
          onTap: () {
            setState(() {
              selected = false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSize(
              curve: Curves.bounceOut,
              vsync: this,
              duration: Duration(milliseconds: 400),
              child: Container(
                color: Colors.red[850],
                height: deleted ? 0 : null,
                width: deleted ? 0 : null,
                child: Stack(children: [
                  Opacity(
                    opacity: 0,
                    child: ListTile(
                      leading: widget.isNext
                          ? Container(
                              width: 20,
                              child: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).accentColor,
                              ),
                            )
                          : null,
                      title: courseTitle,
                    ),
                  ),
                  deleted
                      ? Container()
                      : Positioned(
                          //left: double.infinity,
                          right: 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            //color: Colors.red[800],
                            padding: EdgeInsets.only(left: 25.0),
                            width: selected ? width * 0.4 : 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                          ),
                                          onPressed: () {
                                            navigateToPeriodPage(context);
                                          }),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            deleted = true;
                                            periods.remove(widget.period);
                                            dbperiods.delete(widget.period.id);
                                            widget.refresh();
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  AnimatedPositioned(
                    right: selected ? width * 0.125 : 0,
                    //top: 50,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.bounceOut,
                    child: Ink(
                      color: Colors.grey[800],
                      child: AnimatedContainer(
                        curve: Curves.bounceOut,
                        width: width,
                        duration: Duration(milliseconds: 500),
                        child: ListTile(
                          //contentPadding: EdgeInsets.only(left: width*0.2),
                          title: courseTitle,
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    curve: Curves.bounceOut,
                    top: 20,
                    right: selected ? width * 1 : width * 0.8,
                    width: width * 0.2,
                    child: widget.isNext
                        ? Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).accentColor,
                          )
                        : Container(),
                    duration: Duration(milliseconds: 490),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PeriodList extends StatefulWidget {
  final int day;
  final Function refresh;

  const PeriodList({
    Key key,
    this.day,
    this.refresh,
  }) : super(key: key);

  @override
  _PeriodListState createState() => _PeriodListState();
}

class _PeriodListState extends State<PeriodList> {
  ScrollController _controller;
  List<Period> currentPeriods;
  Timer timer;

  @override
  void initState() {
    currentPeriods = allFromDay((widget.day - 1) % 7);
    int i = 0;
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (i > 0) {
        setState(() {});
      }
    });

    i++;

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

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  bool isnext(index) {
    if (widget.day % 7 != DateTime.now().weekday % 7) {
      return false;
    } else if (index == 0) {
      if (toDouble(currentPeriods[0].startTime) > toDouble(TimeOfDay.now())) {
        return true;
      }
    } else {
      if (toDouble(currentPeriods[index].startTime) >
              toDouble(TimeOfDay.now()) &&
          toDouble(currentPeriods[index - 1].startTime) <
              toDouble(TimeOfDay.now())) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    currentPeriods = allFromDay((widget.day - 1) % 7);

    return ListView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        return index == 0
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getDayOfTheWeek((widget.day - 1) % 7),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : currentPeriods.isEmpty
                ? EmptyMessage()
                : PeriodSlot(
                    period: currentPeriods[index - 1],
                    title: currentPeriods[index - 1].courseTitle,
                    subtitle: currentPeriods[index - 1].title,
                    index: index,
                    isNext: isnext(index - 1),
                    refresh: widget.refresh,
                  );
      },
      itemCount: currentPeriods.isEmpty ? 2 : currentPeriods.length + 1,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class CoursePeriodList extends StatefulWidget {
  final Course course;
  final int index;

  const CoursePeriodList({
    Key key,
    this.course,
    this.index,
  }) : super(key: key);

  @override
  _CoursePeriodListState createState() => _CoursePeriodListState();
}

class _CoursePeriodListState extends State<CoursePeriodList> {
  List<Period> coursePeriods;
  var notChecked;
  var passedthrough;
  int isnext;

  @override
  void initState() {
    coursePeriods = allFromCourse(widget.course.id);
    isnext = -1;
    notChecked = true;
    passthrough();

    super.initState();
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  int isNext(int index) {
    if (notChecked) {
      if (coursePeriods[index].day + 1 == DateTime.now().weekday) {
        if (index == 0) {
          if (toDouble(coursePeriods[0].startTime) >
              toDouble(TimeOfDay.now())) {
            notChecked = false;
          }
        } else {
          if (toDouble(coursePeriods[index].startTime) >
                  toDouble(TimeOfDay.now()) &&
              toDouble(coursePeriods[index - 1].startTime) <
                  toDouble(TimeOfDay.now())) {
            notChecked = false;

            return index;
          }
        }
      } else if (coursePeriods[index].day + 1 > DateTime.now().weekday) {
        notChecked = false;

        return index;
      } else if (coursePeriods[index].day + 1 <= DateTime.now().weekday &&
          passedthrough) {
        notChecked = false;

        return index;
      }
    }
    return -1;
  }

  void passthrough() {
    passedthrough = false;
    for (var i = 0; i < coursePeriods.length; i++) {
      var result = isNext(i);
      isnext = result == -1 ? isnext : result;
    }

    passedthrough = true;
    if (notChecked) {
      for (var i = 0; i < coursePeriods.length; i++) {
        var result = isNext(i);
        isnext = result == -1 ? isnext : result;
      }
    }
  }

  void callback() {
    setState(() {
      coursePeriods = allFromCourse(widget.course.id);
    });
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
              child: Container(
                child: Text(
                  widget.course.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ),
      body: ListView.builder(
        key: new Key('huh'),
        itemBuilder: (context, index) {
          return coursePeriods.isEmpty
              ? EmptyMessage()
              : PeriodSlot(
                  index: index,
                  title: coursePeriods[index].title,
                  subtitle: getDayOfTheWeek(coursePeriods[index].day),
                  period: coursePeriods[index],
                  isNext: isnext == index,
                  refresh: callback,
                );
        },
        itemCount: coursePeriods.isEmpty ? 1 : coursePeriods.length,
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
