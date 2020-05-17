import 'package:Sapptest/course.dart';
import 'package:Sapptest/period.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
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

bool x = false;
Course _course;

class PeriodInput extends StatefulWidget {
  PeriodInput({Key key}) : super(key: key);

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
  @override
  void initState() {
    setState(() {
      _course = courses.isNotEmpty ? courses[0] : null;
    });

    super.initState();
  }

  Widget build(BuildContext context) {
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
          child: PeriodInputs(),
        ),
      ),
    );
  }
}

class PeriodInputs extends StatefulWidget {
  const PeriodInputs({
    Key key,
  }) : super(key: key);

  @override
  _PeriodInputsState createState() => _PeriodInputsState();
}

class _PeriodInputsState extends State<PeriodInputs> {
  void createSnackBar(BuildContext context) {
    final snackBar = new SnackBar(
      behavior: SnackBarBehavior.fixed,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownButtonFormField(
            key: _courseFormKey,
            isExpanded: true,
            value: _course != null ? _course : null,
            items: courses.map<DropdownMenuItem<Course>>((Course value) {
              return DropdownMenuItem<Course>(
                value: value,
                child: Text(value.title),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _course = newValue;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'You Have To Add A Course First';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 15.0, bottom: 15, left: 25, right: 25),
          child: TextFormField(
            key: _textFormKey,
            decoration: const InputDecoration(
              hintText: 'Enter Period Title',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please Enter A Title';
              }
              return null;
            },
          ),
        ),
        Center(
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
        ),
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
            padding: const EdgeInsets.only(right: 30.0),
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
                context: context,
                key: _startFormKey,
                validator: (value) {
                  if (value == null || _endFormKey.currentState.value == null) {
                    return 'Please Enter a Time';
                  } else if (_endFormKey != null &&
                      _endFormKey.currentState.value.hour * 10 +
                              _endFormKey.currentState.value.minute <
                          value.hour * 10 + value.minute) {
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
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
                  var title = _textFormKey.currentState.value;
                  var startTime = _startFormKey.currentState.value;
                  var endTime = _endFormKey.currentState.value;
                  var course = _courseFormKey.currentState.value;

                  _dayFormKey.currentState.value.forEach((day) {
                    Period period =
                        Period(id, startTime, endTime, title, day, course);

                    dbperiods.save(period);

                    id++;

                    prefs.saveId(id);
                  });

                  Navigator.pop(context);
                } else {
                  setState(() {});
                }
              },
              child: Text('Submit'),
            ),
          ),
        ),
      ],
    );
  }
}
