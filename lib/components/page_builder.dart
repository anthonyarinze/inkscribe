import 'package:flutter/material.dart';

class ZoomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ZoomPageRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const beginScale = 0.5; // Initial scale of the new page
            const endScale = 1.0; // Final scale of the new page
            var scaleAnimation = Tween<double>(begin: beginScale, end: endScale).animate(animation);

            return Transform.scale(
              scale: scaleAnimation.value,
              child: child,
            );
          },
        );
}
