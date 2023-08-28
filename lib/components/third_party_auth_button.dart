import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThirdPartyAuthButton extends StatelessWidget {
  const ThirdPartyAuthButton({
    super.key,
    this.fontColor,
    required this.color,
    required this.text,
    required this.image,
  });

  final Color color;
  final String text;
  final String image;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            height: 30.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: color,
              image: DecorationImage(image: AssetImage(image)),
            ),
          ),
          // Divider
          Container(
            height: 60.0,
            width: 1.0,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: fontColor ?? Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
