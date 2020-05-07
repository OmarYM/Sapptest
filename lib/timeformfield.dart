
import 'package:flutter/material.dart';


class TimeFormField extends FormField<TimeOfDay> {
  TimeFormField({
    Key key,
    FormFieldSetter<TimeOfDay> onSaved,
    FormFieldValidator<TimeOfDay> validator,
    TimeOfDay initialValue,
    bool autovalidate = false,
    @required BuildContext context,
  }) : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<TimeOfDay> state) {

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        showTimePicker(initialTime: TimeOfDay.now(), context: context).then((time) { state.didChange(time);});
                      },
                      child: Text(state.value == null
                          ? 'Enter A Time'
                          : state.value.format(context)),
                      hoverColor: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey[700])),
                    ),
                  ]);
            });
}