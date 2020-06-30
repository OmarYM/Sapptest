import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Function route;
  final String title;

  const AddButton({Key key, this.route, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.9,
      child: Material(
        color: Theme.of(context).primaryColor,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: SizedBox(
          width: width * 0.9,
          child: FlatButton(
            onPressed: () {
              route(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )),
      ),
    );
  }
}
