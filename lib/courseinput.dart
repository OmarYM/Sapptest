import 'package:Sapptest/course.dart';
import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//TimeOfDay start;
//TimeOfDay end;

String err = '';
final _formCourseKey = GlobalKey<FormState>();
final _titleFormKey = GlobalKey<FormFieldState>();
final _descriptionFormKey = GlobalKey<FormFieldState>();
final _codeFormKey = GlobalKey<FormFieldState>();

class CourseInput extends StatefulWidget {
  CourseInput({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _CourseInputState createState() => _CourseInputState();
}

class _CourseInputState extends State<CourseInput> {
  @override
  void initState() {
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
        // Here we take the value from the CourseInput object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add A Course'),
      ),
      body: Form(
        key: _formCourseKey,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  left: 25,
                ),
                child: Text(
                  'Course Title',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 15, left: 25, right: 25),
                child: TextFormField(
                  key: _titleFormKey,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Enter Course Title',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter A Title';
                    } else if(courseCheck(value)){
                      return 'Course already Exists';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  left: 25,
                ),
                child: Text(
                  'Course Code',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15, left: 25, right: 25),
                child: TextFormField(
                  key: _codeFormKey,
                  decoration: const InputDecoration(
                    hintText: '(optional)',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  left: 25,
                ),
                child: Text(
                  'Description',
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15, left: 25, right: 25),
                child: TextFormField(
                  key: _descriptionFormKey,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: '(optional)',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: RaisedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formCourseKey.currentState.validate()) {
                        // Process data.
                        var title = _titleFormKey.currentState.value;
                        var code = _codeFormKey.currentState.value;
                        var desc = _descriptionFormKey.currentState.value;
                        var id = Uuid().v1();

                        Course course = Course(
                            id: id, title: title, courseCode: code, description: desc);

                        dbcourses.save(course);

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
