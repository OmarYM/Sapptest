import 'gradeSlot.dart';
import 'userdata.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'course.dart';
import 'grade.dart';

class GradesPage extends StatefulWidget {
  final index;
  final Course course;

  GradesPage({Key key, this.index, this.course}) : super(key: key);

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradesPage> {
  List<Grade> courseGrades = [];
  final _titleFormKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  final _weightFormKey = GlobalKey<FormFieldState>();
  List<charts.Series<double, num>> series;
  List<double> gradesTotal = [];
  double totalGrade;
  double totalWeight;
  final _gradeFormKey = GlobalKey<FormFieldState>();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    super.initState();
    totalGrade = 0;
    totalWeight = 0;
    courseGrades = allGradesFromCourse(widget.course.id);
    gradesTotal = getGrades();

    series = [
      charts.Series(
          id: "grades",
          data: gradesTotal,
          domainFn: (double grade, _) => _,
          measureFn: (double grade, _) => grade,
          colorFn: (double grade, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue))
    ];
  }

  List<double> getGrades() {
    List<double> result = [0];
    double total = 0;
    totalWeight = 0;

    for (int i = 0; i < courseGrades.length; i++) {
      double temp = courseGrades[i].grade * courseGrades[i].weight / 100;
      total += temp;

      totalWeight += courseGrades[i].weight;

      result.add(total);
    }

    totalGrade = result[result.length - 1];

    return result;
  }

  refresh(Grade grade, bool delete) {
    setState(() {
      if (delete) {
        courseGrades.removeWhere((element) => element.id == grade.id);
      } else {
        int index =
            courseGrades.indexWhere((element) => element.id == grade.id);
        courseGrades.removeAt(index);
        courseGrades.insert(index, grade);
      }

      gradesTotal = getGrades();

      series = [
        charts.Series(
            id: "grades",
            data: gradesTotal,
            domainFn: (double grade, _) => _,
            measureFn: (double grade, _) => grade,
            colorFn: (double grade, _) =>
                charts.ColorUtil.fromDartColor(Colors.blue))
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Hero(
              tag: 'coursetile' + widget.index.toString(),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    widget.course.title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return index == 0
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Material(
                        elevation: 15,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Theme.of(context).dividerColor,
                        child: Column(
                          children: [
                            Text('Grades Chart',
                                style: TextStyle(
                                    fontSize: width / 15,
                                    fontWeight: FontWeight.bold)),
                            Container(
                                padding: EdgeInsets.all(8),
                                width: width,
                                height: 350,
                                child: charts.LineChart(
                                  series,
                                  animate: true,
                                  primaryMeasureAxis: new charts
                                          .NumericAxisSpec(
                                      renderSpec: new charts
                                              .GridlineRendererSpec(

                                          // Tick and Label styling here.
                                          labelStyle: new charts.TextStyleSpec(
                                              fontSize: 18, // size in Pts.
                                              color:
                                                  charts.MaterialPalette.white),

                                          // Change the line colors to match text color.
                                          lineStyle: new charts.LineStyleSpec(
                                              color: charts
                                                  .MaterialPalette.white))),
                                )),
                          ],
                        )),
                  )
                : index == 1
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          elevation: 15,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(8)),
                                                  Text('Title:'),
                                                  TextFormField(
                                                    key: _titleFormKey,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Enter a Title',
                                                    ),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Enter a Title';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(8)),
                                                  Text('Grade:'),
                                                  TextFormField(
                                                    key: _gradeFormKey,
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Enter grade as a percentage',
                                                    ),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Enter a grade';
                                                      } else if (!isNumeric(
                                                          value)) {
                                                        return 'This isn\'t a Number!';
                                                      } else if (double.parse(
                                                                  value) >
                                                              100 ||
                                                          double.parse(value) <
                                                              1) {
                                                        return 'Number must be between 1 and 100';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(8)),
                                                  Text('Weight:'),
                                                  TextFormField(
                                                    key: _weightFormKey,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Enter as a percentage',
                                                    ),
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Enter a Number';
                                                      } else if (!isNumeric(
                                                          value)) {
                                                        return 'This isn\'t a Number!';
                                                      } else if (double.parse(
                                                                  value) >
                                                              100 ||
                                                          double.parse(value) <
                                                              1) {
                                                        return 'Number must be between 1 and 100';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(8)),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        var title =
                                                            _titleFormKey
                                                                .currentState
                                                                .value;
                                                        var grade = double
                                                            .parse(_gradeFormKey
                                                                .currentState
                                                                .value);
                                                        var weight =
                                                            double.parse(
                                                                _weightFormKey
                                                                    .currentState
                                                                    .value);

                                                        var id = Uuid().v1();

                                                        Grade newGrade = Grade(
                                                            id,
                                                            grade,
                                                            weight,
                                                            widget.course.id,
                                                            title,
                                                            DateTime.now()
                                                                .millisecondsSinceEpoch);

                                                        grades.add(newGrade);

                                                        dbGrades.save(newGrade);

                                                        setState(() {
                                                          courseGrades
                                                              .add(newGrade);

                                                          gradesTotal =
                                                              getGrades();

                                                          series = [
                                                            charts.Series(
                                                                id: "grades",
                                                                data:
                                                                    gradesTotal,
                                                                domainFn:
                                                                    (double grade,
                                                                            _) =>
                                                                        _,
                                                                measureFn:
                                                                    (double grade,
                                                                            _) =>
                                                                        grade,
                                                                colorFn: (double
                                                                            grade,
                                                                        _) =>
                                                                    charts.ColorUtil
                                                                        .fromDartColor(
                                                                            Colors.blue))
                                                          ];
                                                        });

                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text('Ok'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(8)),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      )
                    : index == 2
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total Grade: " +
                                        totalGrade.toStringAsFixed(5) +
                                        "%",
                                    style: TextStyle(
                                      fontSize: width / 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total Weight: " +
                                        totalWeight.toStringAsFixed(5) +
                                        "%",
                                    style: TextStyle(
                                      fontSize: width / 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(thickness: 2),
                            ],
                          )
                        : courseGrades.isEmpty
                            ? Container(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Seems Empty, Try Adding Some Grades!',
                                  ),
                                ),
                              )
                            : GradeSlot(
                                grade: courseGrades[index - 3],
                                refresh: refresh);
          },
          itemCount: courseGrades.isEmpty
              ? courseGrades.length + 4
              : courseGrades.length + 3,
        ));
  }
}
