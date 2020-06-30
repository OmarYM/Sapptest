import 'dart:math';

import 'package:Sapptest/notifications.dart';
import 'package:Sapptest/shapes.dart';
import 'package:Sapptest/timerservice.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class StudyTimerPage extends StatefulWidget {
  StudyTimerPage({Key key}) : super(key: key);

  @override
  _StudyTimerPageState createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage>
    with SingleTickerProviderStateMixin {
  final _studyFormKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  final _breakFormKey = GlobalKey<FormFieldState>();
  var rand = (Random().nextDouble() + 1);
  int studyDuration = 25;
  int breakDuration = 5;
  bool isStudyTimer = true;
  bool started = false;
  TimerService timerService;
  AnimationController controller;
  Animation animation;

  double get currentsecond =>
      timerService?.currentDuration?.inSeconds?.toDouble() ?? 0;

  Future<void> vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  void initState() {
    prefs.getStudyDuration().then((value) => studyDuration = value ?? 25);
    prefs.getBreakDuration().then((value) => breakDuration = value ?? 5);
    isStudyTimer = true;
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    controller.repeat(reverse: true);

    controller.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var diameter = width * 0.7;
    var timeLeft = '0:00';

    timerService = TimerService.of(context);

    return AnimatedBuilder(
        animation: controller, // listen to ChangeNotifier
        builder: (context, child) {

          var position = controller.value * width / 150 +
                        diameter -
                        ((isStudyTimer
                                ? (currentsecond / (studyDuration * 60)) *
                                    (diameter * 1.14)
                                : (currentsecond / (breakDuration * 60)) *
                                    (diameter * 1.14)) ??
                            0);

          timeLeft = timer((isStudyTimer ? studyDuration : breakDuration )*60 - timerService.currentDuration.inSeconds);


          if (timerService.isRunning &&
              isStudyTimer &&
              timerService.currentDuration.inSeconds >= studyDuration * 60) {
            timerService.stop();
            vibrate();
          } else if (timerService.isRunning &&
              !isStudyTimer &&
              timerService.currentDuration.inSeconds >= breakDuration * 60) {
            timerService.stop();
            vibrate();
          }

          var clock = Center(
            child: ClipOval(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                    width: diameter,
                    height: diameter,
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.linear,
                    left: -width / 2 + controller.value * width / 10,
                    top: position > diameter-width/15 ? diameter-width/15 : position < -width/20 ? -width/10 : position,
                    child: Stack(
                      children: [
                        Container(
                          width: width * 2,
                          height: width * 2,
                          child: CustomPaint(
                            painter: CurvePainter(Colors.blue),
                          ),
                        ),
                        Positioned(
                          top: width / 10,
                          left: (-width / 3) * rand,
                          child: Container(
                            width: width * 2,
                            height: width * 2,
                            child: CustomPaint(
                              painter: CurvePainter(Colors.blue[400]),
                            ),
                          ),
                        ),
                        Positioned(
                          top: width / 5,
                          left: (-width / 2.5) * rand,
                          child: Container(
                            width: width * 2,
                            height: width * 2,
                            child: CustomPaint(
                              painter: CurvePainter(Colors.blue[300]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(padding: EdgeInsets.all(8)),
                                            Text('Study Duration in Minutes:'),
                                            TextFormField(
                                              key: _studyFormKey,
                                              initialValue:
                                                  studyDuration.toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter a Number';
                                                } else if (!isNumeric(value)) {
                                                  return 'This isn\'t a Number!';
                                                } else if (double.parse(value) > 9999 || double.parse(value) < 1) {
                                                  return 'Number must be between 1 and 9999';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            Padding(padding: EdgeInsets.all(8)),
                                            Text('Break Duration in Minutes:'),
                                            TextFormField(
                                              key: _breakFormKey,
                                              initialValue:
                                                  breakDuration.toString(),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter a Number';
                                                } else if (!isNumeric(value)) {
                                                  return 'This isn\'t a Number!';
                                                } else if (double.parse(value) > 9999 || double.parse(value) < 1) {
                                                  return 'Number must be between 1 and 9999';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            Padding(padding: EdgeInsets.all(8)),
                                            RaisedButton(
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  studyDuration = int.parse(
                                                      _studyFormKey
                                                          .currentState.value);
                                                  breakDuration = int.parse(
                                                      _breakFormKey
                                                          .currentState.value);

                                                  prefs.saveStudyDuration(
                                                      studyDuration);
                                                  prefs.saveBreakDuration(
                                                      breakDuration);

                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Ok'),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Padding(padding: EdgeInsets.all(8)),
                                          ]),
                                    ),
                                  ),
                                );
                              });
                        })
                  ],
                ),

                Text(timeLeft, style: TextStyle(fontSize: width/10, fontWeight: FontWeight.bold),),

                Padding(padding: EdgeInsets.only(top: 30)),
                clock,
                Padding(padding: EdgeInsets.only(top: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Container(), flex: 1),
                    RaisedButton(
                      onPressed: (!timerService.isRunning || timerService.currentDuration.inSeconds == 0)
                          ? () {
                              timerService.start();
                              displayTimerNotification(isStudyTimer,
                                  isStudyTimer ? studyDuration : breakDuration);
                            }
                          : timerService.reset,
                      child: Text((!timerService.isRunning && timerService.currentDuration.inSeconds == 0)
                          ? 'Start'
                          : 'Reset'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(child: Container()),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          isStudyTimer = !isStudyTimer;
                          timerService.reset();
                          timerService.start();
                          displayTimerNotification(isStudyTimer,
                              isStudyTimer ? studyDuration : breakDuration);
                        });
                      },
                      child: Text('Start ' +
                          (isStudyTimer ? 'Break Time' : 'Studying')),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    Flexible(child: Container(), flex: 1),
                  ],
                ),
              ],
            ),
          );
        });
  }

  String timer(int time){

    if(time != null && time > 0){

    var minutes = (time~/60).toString();
    var seconds = (time%60).toString().padLeft(2, '0');

    return minutes + ':' + seconds;

    } else {

      return '0:00';
    }

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
