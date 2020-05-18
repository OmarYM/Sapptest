import 'package:Sapptest/userdata.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final parentContext;
  SettingsPage({Key key, this.parentContext}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var state;

  @override
  void initState() {
    state = Theme.of(widget.parentContext).brightness == Brightness.light
        ? true
        : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Deletion',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
            ),
          ),
        ),
        Container(
          width: 150,
          child: FlatButton(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text('Delete All Periods'),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.black12,
                ),
              ),
              onPressed: () {
                dbperiods.deleteTable();
              }),
        ),
        Divider(),
      ]),
    );
  }
}
