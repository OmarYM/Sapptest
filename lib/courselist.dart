import 'course.dart';
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

  void callback(Period period) {
    setState(() {
      //print(coursePeriods[index].id);
      coursePeriods.remove(period);
    });
  }

  @override
  Widget build(BuildContext context) {
    coursePeriods = allPeriodsFromCourse(widget.course.id);

    if (isnext >= coursePeriods.length) {
      isnext = 0;
    }

    return ListView.builder(
      physics: BouncingScrollPhysics(),
        key: new Key('huh'),
        itemBuilder: (context, index) {
          return  coursePeriods.isEmpty
                  ? EmptyMessage()
                  : PeriodSlot(
                      index: index ,
                      period: coursePeriods[index ],
                      isNext: isnext == index ,
                      function: callback,
                    );
        },
        itemCount: coursePeriods.isEmpty ? 1 : coursePeriods.length,
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
  final Function function;
  final Period period;

  final isNext;

  PeriodSlot({
    Key key,
    @required this.period,
    this.index,
    this.isNext,
    this.function,
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
    var title = Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
            width: width * 0.6,
            child: Text(
              widget.period.title,
              textAlign: TextAlign.center,
            )),
      ),
    );

    var subtitle = Container(
      width: width * 0.6,
      child: Column(
        children: [
          Center(
              child: Text(
            getDayOfTheWeek(widget.period.day),
            textAlign: TextAlign.center,
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.period.startTime.format(context),
                  textAlign: TextAlign.center,
                ),
              ),
              Text('-'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.period.endTime.format(context),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Divider(
            height: 15,
            thickness: 2,
          ),
        ],
      ),
    );

    return AnimatedSize(
      curve: Curves.bounceOut,
      vsync: this,
      duration: Duration(milliseconds: 400),
      child: Container(
        height: deleted ? 0 : null,
        width: deleted ? 0 : null,
        child: Stack(children: [
          Opacity(
            opacity: 0,
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
              leading: widget.isNext
                  ? Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).accentColor,
                    )
                  : null,
              title: title,

              subtitle: subtitle,
            ),
          ),
          deleted
              ? Container()
              : ListTile(
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          dbperiods.delete(widget.period.id);
                          deleted = true;
                        });
                        widget.function(widget.period);
                      }),
                ),
          AnimatedPositioned(
            right: selected ? width * 0.2 : 0,
            //top: 50,
            duration: Duration(milliseconds: 500),
            curve: Curves.bounceOut,
            child: AnimatedContainer(
              curve: Curves.bounceOut,
              width: width,
              color:
                  //MediaQuery.of(context).platformBrightness == Brightness.light
                      //? Colors.grey[50]
                       Colors.grey[850],
              duration: Duration(milliseconds: 500),
              child: ListTile(
                //contentPadding: EdgeInsets.only(left: width*0.2),
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
                title: title,
                subtitle: subtitle,
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
    );
  }
}
