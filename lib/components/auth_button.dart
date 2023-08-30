import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/theme/palette.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    this.border,
    this.color,
    this.image,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final BoxBorder? border;
  final Color? color;
  final String text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: border,
          gradient: LinearGradient(
            colors: [
              Palette.primeBlue.withOpacity(0.4),
              Palette.primePurple,
            ],
          ),
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
