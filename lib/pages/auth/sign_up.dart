import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/components/auth_button.dart';
import 'package:inkscribe/components/page_builder.dart';
import 'package:inkscribe/components/third_party_auth_button.dart';
import 'package:inkscribe/pages/auth/login.dart';
import 'package:inkscribe/theme/palette.dart';

import '../../components/auth_form_texfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      hintText: 'Username',
                      onSaved: (newValue) => _username = newValue,
                      isPassword: false,
                    ),
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
                        text: 'Sign Up',
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
                text: 'Sign Up with Discord',
                image: 'assets/discord2.png',
                fontColor: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.roboto(
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
