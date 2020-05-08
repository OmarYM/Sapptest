import 'dart:async';
import 'package:flutter/material.dart';

class Time extends StatefulWidget {
  Time({Key key}) : super(key: key);

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> with TickerProviderStateMixin {
  String _timeString;
  Timer timer;

  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    setState(() {
      _timeString =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    });
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
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }
}
