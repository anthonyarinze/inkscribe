import 'package:flutter/material.dart';

PageRouteBuilder<dynamic> bookDetailsPageBuilder(Widget page) {
  return PageRouteBuilder<dynamic>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const Offset begin = Offset(0.0, 1.0); // Starting offset (bottom of the screen)
      const Offset end = Offset.zero; // Ending offset (top of the screen)
      const Curve curve = Curves.easeInOut; // Animation curve

      var tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
