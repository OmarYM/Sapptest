import 'package:Sapptest/userdata.dart';
import 'package:flutter/cupertino.dart';
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
                dbperiods.emptyTable();
              }),
        ),
        Divider(),
        Container(
          width: 150,
          child: FlatButton(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text('Delete All Classes'),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.black12,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'This will delete all courses and all periods!',
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        CupertinoButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor))),
                        CupertinoButton(
                            onPressed: () {
                              courses.forEach((element) {
                                deleteCourse(element);
                              });

                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ))
                      ],
                    );
                  },
                );
              }),
        ),
        Divider(),
      ]),
    );
  }
}
