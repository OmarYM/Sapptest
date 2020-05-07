import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
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

class PeriodList extends StatelessWidget {
  const PeriodList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Period> currentPeriods = allFromDay(DateTime.now().weekday - 1);

    return currentPeriods.isEmpty
        ? Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Seems Empty, Try Adding Some Periods!',
              ),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return PeriodSlot(
                period: currentPeriods[index],
                index: index,
              );
            },
            itemCount: currentPeriods.length,
          );
  }
}
