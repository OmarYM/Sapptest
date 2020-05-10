import 'package:Sapptest/mainPage.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'period.dart';


class PeriodSlot extends StatelessWidget {
  final int index;

  final Period period;

  PeriodSlot({
    Key key,
    @required this.period,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(index.toString());
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: Text(period.course.title)),
      ),
      subtitle: Column(
        children: [
          Center(child: Text(period.title)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(period.startTime.format(context)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(period.endTime.format(context)),
              )
            ],
          ),
          Divider(
            height: 15,
          ),
        ],
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

    currentPeriods =  allFromDay((widget.day - 1) % 7);
    currentPeriods.sort((a,b) => a.compareTo(b));
    
    
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
  @override
  Widget build(BuildContext context) {
     currentPeriods =  allFromDay((widget.day - 1) % 7);

    return ListView.builder(
      controller: _controller,
      itemBuilder: (context, index) {
        return index == 0
            ? 
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getDayOfTheWeek((widget.day - 1) % 7), style: TextStyle(fontSize: 30),),
                    ),
                  )
               
            : currentPeriods.isEmpty
                ? EmptyMessage()
                : PeriodSlot(
                    period: currentPeriods[index - 1],
                    index: index,
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
