import 'package:flutter/material.dart';

class SkeletonBookCard extends StatelessWidget {
  const SkeletonBookCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      width: 180.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
