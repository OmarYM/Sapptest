import 'package:Sapptest/mainPage.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'period.dart';

class PeriodSlot extends StatefulWidget {
  final int index;
  final Period period;
  final bool isNext;

  PeriodSlot({
    Key key,
    @required this.period,
    this.index,
    this.isNext,
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
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                      child: Text(
                    widget.period.course.title,
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              subtitle: Column(
                children: [
                  Center(
                      child: Text(
                    widget.period.title,
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
                  ),
                ],
              ),
            ),
          ),
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
          AnimatedPositioned(
            right: selected ? width * 0.2 : 0,
            //top: 50,
            duration: Duration(milliseconds: 500),
            curve: Curves.bounceOut,
            child: AnimatedContainer(
              curve: Curves.bounceOut,
              width: width,
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.grey[50]
                      : Colors.grey[850],
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
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        width: width * 0.6,
                        child: Text(
                          widget.period.course.title,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                subtitle: Container(
                  width: width * 0.6,
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        widget.period.title,
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
    );
  }
}

class PeriodList extends StatefulWidget {
  final int day;
  const PeriodList({
    Key key,
    this.day,
  }) : super(key: key);

  @override
  _PeriodListState createState() => _PeriodListState();
}

class _PeriodListState extends State<PeriodList> {
  ScrollController _controller;
  List<Period> currentPeriods;

  @override
  void initState() {
    currentPeriods = allFromDay((widget.day - 1) % 7);

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
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              )
            : currentPeriods.isEmpty
                ? EmptyMessage()
                : PeriodSlot(
                    period: currentPeriods[index - 1],
                    index: index,
                    isNext: isnext(index - 1),
                  );
      },
      itemCount: currentPeriods.isEmpty ? 2 : currentPeriods.length + 1,
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
