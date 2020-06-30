import 'package:flutter/material.dart';

class SlideBottomUpRoute extends PageRouteBuilder {
  SlideBottomUpRoute(
    {@required this.enterWidget,
      @required this.curve, 
      RouteSettings settings})
      : super(
          transitionDuration: const Duration(milliseconds: 350),
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
           transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
        );

  final Widget enterWidget;
  final Curve curve;
}

class SlideRightLeftRoute extends PageRouteBuilder {
  SlideRightLeftRoute( 
      {@required this.enterWidget,
      @required this.curve, 
      RouteSettings settings})
      : super(
          transitionDuration: const Duration(milliseconds: 350),
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;

      var tween1 = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var tween2 = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInQuad));

      return animation.status == AnimationStatus.reverse ? SlideTransition(
        position: animation.drive(tween2),
        child: child,
      ) : SlideTransition(
        position: animation.drive(tween1),
        child: child,
      );
    },
        );

  final Widget enterWidget;
  final Curve curve;
}