import 'userdata.dart';
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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 18,
            color: Colors.red[900],
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(child: Text('Delete All Periods', style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'This will all periods!',
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
                                dbperiods.emptyTable();
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
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 18,
            color: Colors.red[900],
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(child: Text('Delete All Classes', style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                onTap: () {
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

                                courses = [];
                                periods = [];

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
        ),
        Expanded(child: Container(),),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 18,
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(child: Text('About', style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset('graphics/icon/Icon_big.png', width: 100, height: 100,),
                    applicationName: 'Schedule Time',
                    applicationVersion: '0.1.0',
                    children: [Text('Developed by Omar Mohamud')]
                    
                  );
                }),
          ),
        ),
      ]),
    );
  }
}
