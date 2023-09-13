import 'package:flutter/material.dart';

class SkeletonComment extends StatelessWidget {
  const SkeletonComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            spreadRadius: 3,
            offset: const Offset(2, 2),
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    );
  }
}
