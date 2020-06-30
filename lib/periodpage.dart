import 'package:Sapptest/PeriodInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'period.dart';
import 'userdata.dart';

class PeriodPage extends StatefulWidget {
  final int index;
  final Period period;
  PeriodPage({Key key, this.index, this.period}) : super(key: key);

  @override
  _PeriodPageState createState() => _PeriodPageState();
}

class _PeriodPageState extends State<PeriodPage> {
  var newPeriod;

  Future navigateToPeriodInputPage(context) async {
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

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ))
    ;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: MediaQuery.of(context).platformBrightness == Brightness.light
            ? IconThemeData(
                color: Colors.black,
              )
            : null,
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => navigateToPeriodInputPage(context)),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                          
                          periods.remove(widget.period);
                          dbperiods.delete(widget.period.id);
                          Navigator.pop(context);

                      }),
        ],
      ),
      body: ListView(children: [
        Hero(
            tag: widget.period.id,
            child: Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.period.courseTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )),
        Divider(
          thickness: 2,
        ),
      ]),
    );
  }
}
