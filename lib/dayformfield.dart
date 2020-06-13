import 'package:flutter/material.dart';

import 'userdata.dart';


class DayFormField extends FormField<List<int>> {

  DayFormField({
    Key key,
    FormFieldSetter<List<int>> onSaved,
    FormFieldValidator<List<int>> validator,
    List<int> initialValue,
    bool autovalidate = false,
    @required BuildContext context,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: [],
            autovalidate: autovalidate,
            builder: (FormFieldState<List<int>> state) {

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
  var checked;

  @override
  void initState() { 

    checked = false;
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(children: [
      Checkbox(
        value: checked,
        checkColor: Theme.of(context).primaryColor,
        onChanged: (value) {

          setState(() {
              checked = value;
            });

          if(value){
            var current = widget.state.currentState.value;
              current.add(widget.day);
              widget.state.currentState.didChange(current);
          } else {
            var current = widget.state.currentState.value;
              current.remove(widget.day);
              widget.state.currentState.didChange(current);
          }

          
            
        },
      ),
      Text(getDayOfTheWeek(widget.day), style: TextStyle(fontSize: 14)),
    ]);
  }

 
}