import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'period.dart';
import 'time.dart';

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

class PeriodList extends StatelessWidget {
  final int day;
  const PeriodList({
    Key key,
    this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Period> currentPeriods = allFromDay((day - 1) % 7);

    return ListView.builder(
      itemBuilder: (context, index) {
        return index == 0
            ? 
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getDayOfTheWeek((day - 1) % 7), style: TextStyle(fontSize: 30),),
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
