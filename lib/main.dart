import 'dart:io';

import 'package:flutter/services.dart';

import 'sharedPrefs.dart';
import 'timerservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dbhelper.dart';
import 'mainPage.dart';
import 'pagetransitions.dart';
import 'userdata.dart';
import 'package:firebase_admob/firebase_admob.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
  
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});

  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  final timerService = TimerService();
  runApp(
    TimerServiceProvider(
      // provide timer service to all widgets of your app
      service: timerService,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        title: 'Schedule Time',
        theme: ThemeData(
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
          //accentColor: Colors.red,
          tabBarTheme: TabBarTheme(labelPadding: EdgeInsets.zero),
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark(),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child:
                SplashScreen()) //MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

  void refreshLists() {
    dbperiods.getPeriods().then((value) {
      periods = value;

      dbcourses.getCourses().then((value) {
        courses = value;
        Navigator.pushReplacement(context,
            SlideBottomUpRoute(enterWidget: MainPage(), curve: Curves.ease));
      });
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 800), () {
      prefs = SharedPref();

      prefs.getId().then((value) => nid = value ?? 1);

      upDirection = true;
      flag = true;
      click = false;
      click1 = false;
      appear = true;
      disappear = true;

      dbperiods = DBHelperPeriod();
      dbcourses = DBHelperCourse();
      dbGrades = DBHelperGrades();

      periods = [];
      courses = [];
      dbGrades.getGrades().then((value) => grades = value);

      refreshLists();
    });

    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.ease))
              .animate(_controller),
          child: RotationTransition(
            turns: Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.bounceOut))
                .animate(_controller),
            child: Image.asset(
              'graphics/icon/Icon_big.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}

/*

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Container()],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add a Class',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TimeSlot extends StatelessWidget {
  final bool selected;
  final int day;
  final int slotNumber;
  final Function update;

  TimeSlot({
    this.selected,
    this.slotNumber,
    this.day,
    this.update,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DragTarget(
          builder: (context, approved, disapproved) {
            return Container();
          },
          onWillAccept: (data) {
            print('willaccept');
            return day == data[0];
          },
          onAccept: (data) {
            update(data[1], slotNumber);
          },
        ),
        Draggable(
          feedback: Container(),
          child: Container(
            height: 30,
            color: selected ? Colors.red : Colors.grey,
          ),
          childWhenDragging: Container(
            height: 30,
            color: Colors.blue,
          ),
          data: [day, slotNumber],
        ),
      ],
    );
  }
}

class SlotList extends StatefulWidget {
  final int day;

  SlotList({Key key, this.day}) : super(key: key);

  @override
  _SlotListState createState() => _SlotListState();
}

class _SlotListState extends State<SlotList> {
  List<bool> selection = List<bool>.filled(96, false);

  void update(int start, int end) {
    setState(() {
      print('updated');
      selection.fillRange(start, end, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, number) {
          return Column(children: [
            TimeSlot(
              selected: selection[number],
              day: widget.day,
              slotNumber: number,
              update: update,
            ),
            Divider()
          ]);
        },
        itemCount: 96,
      ),
    );
  }
}

*/
