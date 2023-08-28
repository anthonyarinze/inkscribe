import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inkscribe/components/page_builder.dart';
import 'package:inkscribe/pages/master.dart';

class SplashScreen extends StatefulWidget {
  final Color themeColor;

  const SplashScreen({
    super.key,
    required this.themeColor,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.push(context, ZoomPageRoute(page: const Master()));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeColor,
      body: Center(
        child: Container(
          height: 200.0,
          width: 200.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/splash.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
