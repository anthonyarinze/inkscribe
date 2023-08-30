import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/palette.dart';

class AuthFormTextField extends StatefulWidget {
  const AuthFormTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.textEditingController,
  });

  final String hintText;
  final bool isPassword;
  final TextEditingController textEditingController;

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
          cursorColor: Palette.primePurple,
          controller: widget.textEditingController,
          obscureText: !isVisible && widget.isPassword,
          validator: (value) {
            if (widget.hintText == 'Username') {
              if (value == null || value.isEmpty) {
                return 'Username cannot be empty';
              }
            } else if (widget.hintText == 'Email') {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Invalid email address';
              }
            } else if (widget.hintText == 'Password') {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              if (!value.contains(RegExp(r'[A-Z]'))) {
                return 'Password must contain at least one capital letter';
              }
              if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                return 'Password must contain at least one symbol';
              }
            }
            return null;
          },
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
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
