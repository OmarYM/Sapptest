import 'userdata.dart';
import 'package:flutter/material.dart';

import 'grade.dart';

class GradeSlot extends StatefulWidget {
  final Grade grade;
  final Function refresh;
  GradeSlot({Key key, this.grade, this.refresh}) : super(key: key);

  @override
  _GradeSlotState createState() => _GradeSlotState();
}

class _GradeSlotState extends State<GradeSlot> with TickerProviderStateMixin {
  bool selected;
  final _gradeFormKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  final _weightFormKey = GlobalKey<FormFieldState>();
  bool deleted;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    selected = false;
    deleted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Grade newGrade = widget.grade;
    var width = MediaQuery.of(context).size.width;

    var slider = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            newGrade.title,
            style: TextStyle(fontSize: width / 20, fontWeight: FontWeight.bold),
          ),
          Row(children: [
            Text(
              'Grade: ' + newGrade.grade.toStringAsFixed(1) + '%',
              style: TextStyle(fontSize: width / 25),
            ),
            Expanded(child: Container()),
            IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(padding: EdgeInsets.all(8)),
                                    Text('Grade:'),
                                    TextFormField(
                                      key: _gradeFormKey,
                                      initialValue: newGrade.grade == 0 ? null : newGrade.grade.toString(),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter grade as a percentage',
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter a grade';
                                        } else if (!isNumeric(value)) {
                                          return 'This isn\'t a Number!';
                                        } else if (double.parse(value) > 100 ||
                                            double.parse(value) < 1) {
                                          return 'Number must be between 1 and 100';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    Text('Weight:'),
                                    TextFormField(
                                      key: _weightFormKey,
                                      initialValue: newGrade.weight.toString(),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter as a percentage',
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter a Number';
                                        } else if (!isNumeric(value)) {
                                          return 'This isn\'t a Number!';
                                        } else if (double.parse(value) > 100 ||
                                            double.parse(value) < 1) {
                                          return 'Number must be between 1 and 100';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    RaisedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          var grade = double.parse(
                                              _gradeFormKey.currentState.value);

                                          var weight = double.parse(
                                              _weightFormKey
                                                  .currentState.value);

                                          Grade updatedGrade = Grade(
                                              newGrade.id,
                                              grade,
                                              weight,
                                              newGrade.courseId,
                                              newGrade.title,
                                              widget.grade.order);

                                          grades.retainWhere((element) =>
                                              element.id != updatedGrade.id);

                                          grades.add(updatedGrade);

                                          dbGrades.update(updatedGrade);

                                          widget.refresh(updatedGrade, false);

                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('Ok'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                  ]),
                            ),
                          ));
                    },
                  );
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  grades.remove(widget.grade);
                  dbperiods.delete(widget.grade.id);
                  widget.refresh(widget.grade, true);
                }),
          ]),
          //Expanded(child: Container()),
          Row(
            children: [
              Text(
                'Weight: ' + newGrade.weight.toStringAsFixed(1) + '%',
                style: TextStyle(fontSize: width / 25),
              ),
            ],
          ),

          Padding(padding: EdgeInsets.all(8)),

          Text(
            'Contribution to Course: ' +
                (newGrade.grade * newGrade.weight / 100).toStringAsFixed(2) +
                '%',
            style: TextStyle(fontSize: width / 30),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 18,
        color: Colors.grey[800],
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: slider,
      ),
    );
  }
}
