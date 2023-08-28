import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';

class AuthFormTextField extends StatefulWidget {
  const AuthFormTextField({
    super.key,
    required this.onSaved,
    required this.hintText,
    required this.isPassword,
  });

  final Function(String?)? onSaved;
  final String hintText;
  final bool isPassword;

  @override
  State<AuthFormTextField> createState() => _AuthFormTextFieldState();
}

class _AuthFormTextFieldState extends State<AuthFormTextField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 60.0,
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: TextFormField(
          cursorHeight: 25.0,
          obscureText: !isVisible,
          onSaved: widget.onSaved,
          cursorColor: Palette.primePurple,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.roboto(fontSize: 16.0),
            contentPadding: const EdgeInsets.only(left: 16.0, top: 12.0),
            suffixIcon: Visibility(
              visible: widget.isPassword,
              child: widget.isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
