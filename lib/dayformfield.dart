import 'package:flutter/material.dart';

int _groupValue;

class DayFormField extends FormField<int> {

  

  DayFormField({
    Key key,
    FormFieldSetter<int> onSaved,
    FormFieldValidator<int> validator,
    int initialValue,
    bool autovalidate = false,
    @required BuildContext context,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<int> state) {

              double width = MediaQuery.of(context).size.width;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: width / 60),
                      ),
                      DayCheckBox(
                        state: key,
                        day: 0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                      ),
                      DayCheckBox(
                        state: key,
                        day: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                      ),
                      DayCheckBox(
                        state: key,
                        day: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                      ),
                      DayCheckBox(
                        state: key,
                        day: 3,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width / 20),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    DayCheckBox(
                      state: key,
                      day: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width / 20),
                    ),
                    DayCheckBox(
                      state: key,
                      day: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width / 20),
                    ),
                    DayCheckBox(
                      state: key,
                      day: 6,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width / 60),
                    ),
                  ]),
                  state.hasError
                        ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                                state.errorText,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        )
                        : Container()
                ],
              );
            });
}


class DayCheckBox extends StatefulWidget {
  final int day;
  final GlobalKey<FormFieldState> state;

  const DayCheckBox({
    Key key,
    this.day,
    this.state,
  }) : super(key: key);

  @override
  _DayCheckBoxState createState() => _DayCheckBoxState();
}

class _DayCheckBoxState extends State<DayCheckBox> {
  
  @override
  void initState() { 

    _groupValue = null;
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(children: [
      Radio(
        value: widget.day,
        groupValue: _groupValue,
        onChanged: (value) {

            setState(() {
              _groupValue = value;
              widget.state.currentState.didChange(value);
            });

        },
      ),
      Text(getDayOfTheWeek(widget.day), style: TextStyle(fontSize: 14)),
    ]);
  }

  String getDayOfTheWeek(int day) {
    switch (day) {
      case 0:
        return 'Monday';

      case 1:
        return 'Tuesday';

      case 2:
        return 'Wednesday';

      case 3:
        return 'Thursday';

      case 4:
        return 'Friday';

      case 5:
        return 'Saturday';

      case 6:
        return 'Sunday';

      default:
        return 'Invalid -getDayOfTheWeek Method-';
    }
  }
}