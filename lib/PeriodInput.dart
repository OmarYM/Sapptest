import 'course.dart';
import 'notifications.dart';
import 'period.dart';
import 'userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'courseinput.dart';
import 'dayformfield.dart';
import 'timeformfield.dart';

//TimeOfDay start;
//TimeOfDay end;

String err = '';
final _formKey = GlobalKey<FormState>();
final _startFormKey = GlobalKey<FormFieldState>();
final _endFormKey = GlobalKey<FormFieldState>();
final _dayFormKey = GlobalKey<FormFieldState>();
final _textFormKey = GlobalKey<FormFieldState>();
final _courseFormKey = GlobalKey<FormFieldState>();
final _notificationFormKey = GlobalKey<FormFieldState>();
final _notificationFormKey2 = GlobalKey<FormFieldState>();
final _typeFormKey = GlobalKey<FormFieldState>();

bool x = false;
Course _course;
int _notification;
int _notification2;
String _type;
String _type2;
bool _other1;
bool _other2;

class PeriodInput extends StatefulWidget {
  final Period period;

  PeriodInput({Key key, this.period}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _PeriodInputState createState() => _PeriodInputState();
}

class _PeriodInputState extends State<PeriodInput> {
  Widget build(BuildContext context) {
    String initialId;
    Course initialCourse;
    int initialNotification;
    int initialNotificationId;
    String initialType;
    TimeOfDay initialStartTime;
    TimeOfDay initialEndTime;
    int initialDay;

    if (widget.period != null) {
      initialId = widget.period.id;
      initialType = widget.period.title;
      initialNotification = widget.period.notification;
      initialNotificationId = widget.period.notificationId;
      initialCourse =
          courses.firstWhere((element) => element.id == widget.period.courseId);
      initialStartTime = widget.period.startTime;
      initialEndTime = widget.period.endTime;
      initialDay = widget.period.day;
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the PeriodInput object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add A Period'),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: PeriodInputs(
              initialCourse: initialCourse,
              initialType: initialType,
              initialDay: initialDay,
              initialId: initialId,
              initialNotification: initialNotification,
              initialStartTime: initialStartTime,
              initialEndTime: initialEndTime,
              initialNotificationId: initialNotificationId),
        ),
      ),
    );
  }
}

class PeriodInputs extends StatefulWidget {
  final String initialId;

  final Course initialCourse;
  final int initialNotification;
  final int initialNotificationId;
  final String initialType;
  final TimeOfDay initialStartTime;
  final TimeOfDay initialEndTime;
  final int initialDay;

  const PeriodInputs({
    Key key,
    this.initialCourse,
    this.initialNotification,
    this.initialType,
    this.initialStartTime,
    this.initialEndTime,
    this.initialId,
    this.initialDay,
    this.initialNotificationId,
  }) : super(key: key);

  @override
  _PeriodInputsState createState() => _PeriodInputsState();
}

class _PeriodInputsState extends State<PeriodInputs> {
  void createSnackBar(BuildContext context) {
    final snackBar = new SnackBar(
      duration: Duration(seconds: 999),
      content: new Text('Seems like there are no courses.'),
      action: SnackBarAction(
          label: 'Add A Course',
          onPressed: () => navigateToCoursePage(context)),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    if (courses.isEmpty) {
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Future navigateToCoursePage(context) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => CourseInput()))
        .then((value) {
      refreshList();
    });
  }

  refreshList() {
    dbcourses.getCourses().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          courses = value;
          _course = courses.isEmpty ? null : courses[0];
        });
      }
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((_) => createSnackBar(context));
    List<int> notificationArray = [-1, 15, 30, 60, 120];
    List<String> typeArray = ['Tutorial', 'Lab', 'Lecture'];
    _course = widget.initialCourse;
    _other1 = false;
    _other2 = false;

    if (!notificationArray.contains(widget.initialNotification) &&
        widget.initialNotification != null) {
      _notification2 = widget.initialNotification;
      _notification = -2;
      _other2 = true;
    } else {
      _notification = widget.initialNotification;
    }

    if (!typeArray.contains(widget.initialType) && widget.initialType != null) {
      _type2 = widget.initialType;
      _type = 'Other';
      _other1 = true;
    } else {
      _type = widget.initialType;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).copyWith().size.width;

    var notificationDropdownMenu = DropdownButtonFormField(
        key: _notificationFormKey,
        isExpanded: true,
        hint: Text("Choose a Time "),
        value: _notification != null ? _notification : null,
        items: [
          DropdownMenuItem(
            child: Text(
              'No Notification',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: -1,
          ),
          DropdownMenuItem(
            child: Text(
              '15 Minutes Before',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 15,
          ),
          DropdownMenuItem(
            child: Text(
              '30 Minutes Before',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 30,
          ),
          DropdownMenuItem(
            child: Text(
              '1 Hour Before',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 60,
          ),
          DropdownMenuItem(
            child: Text(
              '2 Hours Before',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 120,
          ),
          DropdownMenuItem(
            child: Text(
              'Custom (Enter Minutes Before Period Time)',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: -2,
          ),
        ],
        onChanged: (value) {
          setState(() {
            _notification = value;
            if (value == -2) {
              _other2 = true;
            } else {
              _other2 = false;
            }
          });
        },
        validator: (value) {
          if (value == null) {
            return 'You Have To Choose A Time First!';
          }
          return null;
        });

    var typeDropdownMenu = DropdownButtonFormField(
        key: _typeFormKey,
        isExpanded: true,
        hint: Text("Choose a Period Type"),
        value: _type != null ? _type : null,
        items: [
          DropdownMenuItem(
            child: Text(
              'Lecture',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 'Lecture',
          ),
          DropdownMenuItem(
            child: Text(
              'Lab',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 'Lab',
          ),
          DropdownMenuItem(
            child: Text(
              'Tutorial',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: 'Tutorial',
          ),
          DropdownMenuItem(
            child: Text(
              'Other',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            value: "Other",
          ),
        ],
        onChanged: (value) {
          setState(() {
            _type = value;
            if (value == 'Other') {
              _other1 = true;
            } else {
              _other1 = false;
            }
          });
        },
        validator: (value) {
          if (value == null) {
            return 'You Have To Choose A Type First!';
          }
          return null;
        });

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
          child: Text(
            'Course:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
          child: DropdownButtonFormField(
            key: _courseFormKey,
            isExpanded: true,
            hint: Text("Select"),
            value: _course != null ? _course : null,
            items: courses.map<DropdownMenuItem<Course>>((Course value) {
              return DropdownMenuItem<Course>(
                value: value,
                child: Container(
                    child: Text(
                  value.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                )),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _course = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'You Have To Choose A Course First!';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
          child: Text(
            'Period Type:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: typeDropdownMenu,
          ),
          _other1
              ? Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15.0, left: 8, right: 8),
                  child: TextFormField(
                    initialValue: _type2,
                    key: _textFormKey,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter Period Type',
                    ),
                    validator: (value) {
                      if (value.isEmpty &&
                          _typeFormKey.currentState.value == "Other") {
                        return 'Please Enter A Type';
                      }
                      return null;
                    },
                  ),
                )
              : Container(),
        ]),
        widget.initialId == null
            ? Center(
                child: DayFormField(
                  key: _dayFormKey,
                  context: context,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select One Day';
                    } else {
                      return null;
                    }
                  },
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.all(15),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Start Time',
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text(
              'End Time',
              textAlign: TextAlign.left,
            ),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TimeFormField(
                initialValue: widget.initialStartTime,
                context: context,
                key: _startFormKey,
                validator: (value) {
                  if (value == null || _endFormKey.currentState.value == null) {
                    return 'Please Enter a Time';
                  } else if (_endFormKey != null &&
                      _endFormKey.currentState.value.hour * 100 +
                              _endFormKey.currentState.value.minute <
                          value.hour * 100 + value.minute) {
                    return 'Start Time Must Be Earlier Than End Time';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ]),
          Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TimeFormField(
                initialValue: widget.initialEndTime,
                context: context,
                key: _endFormKey,
              ),
            ),
          ]),
        ]),
        _startFormKey.currentState != null
            ? _startFormKey.currentState.hasError
                ? Center(
                    child: Text(
                      _startFormKey.currentState.errorText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Container()
            : Container(),
        Padding(
          padding: EdgeInsets.only(bottom: 25),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8),
          child: Column(children: [
            Text(
              'When Should you get a Notification?',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: notificationDropdownMenu,
            ),
            _other2
                ? TextFormField(
                    key: _notificationFormKey2,
                    initialValue: _notification2?.toString(),
                    decoration: const InputDecoration(
                      hintText: 'Put the amount of time in Minutes',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if ((value == null || value.isEmpty) && _other2) {
                        return 'Please Enter A TIme';
                      } else if (int.parse(value) >= 24 * 60 && _other2) {
                        return 'Value should be less than 1440   (Max 1 day)';
                      } else if (int.parse(value) <= 0 && _other2) {
                        return 'Value should be greater than 0';
                      } else {
                        return null;
                      }
                    },
                  )
                : Container(),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Container(
              width: width * 0.8,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 15,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (widget.initialId != null &&
                      _formKey.currentState.validate()) {
                    var title = _other1
                        ? _textFormKey.currentState.value
                        : _typeFormKey.currentState.value;
                    var startTime = _startFormKey.currentState.value;
                    var endTime = _endFormKey.currentState.value;
                    var course = _courseFormKey.currentState.value;
                    var day = widget.initialDay;
                    var notification = _other2
                        ? int.parse(_notificationFormKey2.currentState.value)
                        : _notificationFormKey.currentState.value;
                    var id = widget.initialId;
                    var nid = widget.initialNotificationId;

                    Period period = Period(id, startTime, endTime, title, day,
                        course.id, notification, nid);

                    if (notification != -1) {
                      int total = startTime.hour * 60 + startTime.minute;
                      var day = period.day;

                      total -= notification;

                      if (total < 0) {
                        total += 23 * 60 + 59;
                        day = (day - 1) % 7;
                      }

                      scheduleWeeklyNotification(
                          total ~/ 60, (total % 60), period, day);
                    } else {
                      deleteNotification(nid);
                    }

                    dbperiods.update(period);
                    periods.insert(
                        periods
                            .indexWhere((element) => element.id == period.id),
                        period);

                    Navigator.pop(context);
                  } else if (_formKey.currentState.validate()) {
                    // Process data.
                    var title = _other1
                        ? _textFormKey.currentState.value
                        : _typeFormKey.currentState.value;
                    TimeOfDay startTime = _startFormKey.currentState.value;
                    TimeOfDay endTime = _endFormKey.currentState.value;
                    var course = _courseFormKey.currentState.value;
                    var notification = _other2
                        ? int.parse(_notificationFormKey2.currentState.value)
                        : _notificationFormKey.currentState.value;

                    _dayFormKey.currentState.value.forEach((day) {
                      var id = Uuid().v1();

                      Period period = Period(id, startTime, endTime, title, day,
                          course.id, notification, nid);

                      nid++;
                      prefs.saveId(nid);

                      if (notification != -1) {
                        int total = startTime.hour * 60 + startTime.minute;
                        var day = period.day;

                        total -= notification;

                        if (total < 0) {
                          total += 23 * 60 + 59;
                          day = (day - 1) % 7;
                        }

                        scheduleWeeklyNotification(
                            total ~/ 60, (total % 60), period, day);
                      }

                      dbperiods.save(period);
                    });

                    Navigator.pop(context);
                  } else {
                    setState(() {});
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Submit',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
