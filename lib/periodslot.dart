import 'dart:async';

import 'PeriodInput.dart';
import 'mainPage.dart';
import 'userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PeriodInput(
            period: widget.period,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        )).then((value) {
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
            padding: EdgeInsets.only(bottom: 5, top: 12),
            child: Container(
              width: widget.isNext ? width * 0.7 : width,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: 20,
                    ),
              ),
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
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
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
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
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
                  left: selected ? -width * 0.125 : 0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
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

  Widget dayIndicator() {
    List<double> diameters = List.filled(7, 10);

    diameters[(widget.day - 1) % 7] = 25;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[0],
          height: diameters[0],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[1],
          height: diameters[1],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[2],
          height: diameters[2],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[3],
          height: diameters[3],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[4],
          height: diameters[4],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[5],
          height: diameters[5],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
        Container(
          margin: EdgeInsets.all(1),
          width: diameters[6],
          height: diameters[6],
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ],
    );
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 15,
        color: Colors.grey[750],
        borderRadius: BorderRadius.circular(10),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          itemBuilder: (context, index) {
            return index == 0
                ? dayIndicator()
                : index == 1
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getDayOfTheWeek((widget.day - 1) % 7),
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : currentPeriods.isEmpty
                        ? EmptyMessage()
                        : PeriodSlot(
                            period: currentPeriods[index - 2],
                            title: currentPeriods[index - 2].courseTitle,
                            subtitle: currentPeriods[index - 2].title,
                            index: index,
                            isNext: isnext(index - 2),
                            refresh: widget.refresh,
                          );
          },
          itemCount: currentPeriods.isEmpty ? 3 : currentPeriods.length + 2,
        ),
      ),
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
    coursePeriods = allPeriodsFromCourse(widget.course.id);
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
      coursePeriods = allPeriodsFromCourse(widget.course.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    //var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Hero(
            tag: 'coursetile' + widget.index.toString(),
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  widget.course.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            )),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
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
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Seems Empty, Try Adding Some Periods!',
        ),
      ),
    );
  }
}
