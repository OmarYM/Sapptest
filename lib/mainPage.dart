import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';

import 'PeriodInput.dart';
import 'addbutton.dart';
import 'pagetransitions.dart';
import 'periodslot.dart';
import 'settingsPage.dart';
import 'studytimerpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'courseslot.dart';
import 'time.dart';
import 'userdata.dart';
import 'courseinput.dart';
import 'package:infinity_page_view/infinity_page_view.dart';

ValueNotifier<bool> scrollCheck = ValueNotifier(true);
bool click;
bool click1;
bool appear;
bool disappear;
Timer timer;
int i;

MobileAdTargetingInfo targetingInfo;
BannerAd myBanner;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  InfinityPageController page;
  int today;

  @override
  void initState() {
    i = 0;
    adspace = false;

    timer = Timer.periodic(Duration(seconds: 40), (Timer t) => _getAd());
    i++;

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['Education', 'Schedule', 'University', 'Learn'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      // or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );

    myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    myBanner.load();

    today = DateTime.now().weekday;
    page = InfinityPageController(initialPage: 0);
    super.initState();
  }

  void _getAd() {
    if (i > 0) {
      if (myBanner == null) {
        myBanner = BannerAd(
          // Replace the testAdUnitId with an ad unit id from the AdMob dash.
          // https://developers.google.com/admob/android/test-ads
          // https://developers.google.com/admob/ios/test-ads
          adUnitId: BannerAd.testAdUnitId,
          size: AdSize.smartBanner,
          targetingInfo: targetingInfo,
          listener: (MobileAdEvent event) {
            print("BannerAd event is $event");
          },
        );

        myBanner
          // typically this happens well before the ad is shown
          ..load()
          ..show(
            anchorType: AnchorType.bottom,
          );
        print("open");

        setState(() {
          adspace = true;
        });
      } else {
        Future.delayed(Duration(seconds: 20), () {

          if(i > 1) {
      myBanner?.dispose(); 
          }
          myBanner = null;
          print("close");
          setState(() {
            adspace = false;
          });
        });

        i++;
      }
    }
  }

  void refreshLists() {
    dbperiods.getPeriods().then((value) {
      if (value != null) {
        setState(() {
          periods = value;
        });
      }
    });
    dbcourses.getCourses().then((value) {
      if (value != null) {
        setState(() {
          courses = value;
        });
      }
    });
  }

  Future navigateToSettingsPage(context) async {
    Navigator.push(
            context,
            SlideRightLeftRoute(
                enterWidget: SettingsPage(), curve: Curves.ease))
        .then((value) {
      refreshLists();
    });
  }

  Future navigateToPeriodInputPage(context) async {
    Navigator.push(context,
            SlideRightLeftRoute(enterWidget: PeriodInput(), curve: Curves.ease))
        .then((value) {
      refreshLists();
    });
  }

  Future navigateToCourseInputPage(context) async {
    Navigator.push(context,
            SlideRightLeftRoute(enterWidget: CourseInput(), curve: Curves.ease))
        .then((value) {
      refreshLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Time(),
                            Divider(
                              thickness: 3,
                              height: 0,
                            ),
                          ],
                        ),
                        Expanded(
                          child: InfinityPageView(
                              controller: page,
                              itemCount: 7,
                              itemBuilder: (context, index) {
                                return PeriodList(
                                  day: today + index,
                                  refresh: refreshLists,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: CourseList(
                            function: refreshLists,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(child: StudyTimerPage()),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: AddButton(
                                route: navigateToCourseInputPage,
                                title: '+ Course',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: AddButton(
                                route: navigateToPeriodInputPage,
                                title: '+ Period',
                              ),
                            ),
                            Expanded(child: Container()),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: AddButton(
                                route: navigateToSettingsPage,
                                title: 'Settings',
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
              height: 0,
            ),
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).copyWith().size.width,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: TabBar(
                          labelColor: Colors.grey[50],
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            Tab(
                                icon: Icon(
                              Icons.home,
                            )),
                            Tab(
                                icon: Icon(
                              Icons.school,
                            )),
                            Tab(
                                icon: Icon(
                              Icons.timer,
                            )),
                            Tab(
                                icon: Icon(
                              Icons.add,
                            )),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.only(bottom: adspace ? 60 : 0))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    page.dispose();
    myBanner.dispose();
    super.dispose();
  }
}
