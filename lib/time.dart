import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time extends StatefulWidget {
  Time({Key key}) : super(key: key);

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> with TickerProviderStateMixin {
  String _timeString;
  Timer timer;
  int i;

  @override
  void initState() {
    i = 0;

    _timeString = DateFormat.jms().format(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    i++;
    super.initState();
  }

  void _getCurrentTime() {
    if(i>0){
    setState(() {
      _timeString =
          _timeString = DateFormat.jms().format(DateTime.now());
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_timeString, style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold,),),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
