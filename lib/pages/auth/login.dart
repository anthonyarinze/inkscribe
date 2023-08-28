import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/auth_button.dart';
import '../../components/auth_form_texfield.dart';
import '../../components/page_builder.dart';
import '../../components/third_party_auth_button.dart';
import '../../theme/palette.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _email;
  String? _password;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      //Do something with formdata;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text(
                  "InkScribe",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25.0,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthFormTextField(
                      hintText: 'Email',
                      onSaved: (newValue) => _email = newValue,
                      isPassword: false,
                    ),
                    AuthFormTextField(
                      hintText: 'Password',
                      onSaved: (newValue) => _password = newValue,
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AuthButton(
                        hasImage: false,
                        text: 'Login',
                        onPressed: () {
                          FormState? formState = _formKey.currentState;
                          if (formState!.validate()) {
                            //DO something with form data
                          } else {
                            // Display error message to user;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 2.0,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    const Text('or'),
                    Container(
                      height: 2.0,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ThirdPartyAuthButton(
                  color: Colors.white,
                  text: 'Sign Up with Google',
                  image: 'assets/google.png',
                ),
              ),
              const ThirdPartyAuthButton(
                color: Color(0xFF5c6bc0),
                text: 'Login with Discord',
                image: 'assets/discord2.png',
                fontColor: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New to ",
                    style: GoogleFonts.roboto(
                      fontSize: 17.0,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "InkScribe?",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 17.0,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      ZoomPageRoute(page: const Login()),
                    ),
                    child: Text(
                      "Log in",
                      style: GoogleFonts.roboto(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
