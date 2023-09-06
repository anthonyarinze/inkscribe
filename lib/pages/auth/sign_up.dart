import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/auth_button.dart';
import '../../components/dialog_card.dart';
import '../../components/page_builders/page_builder.dart';
import '../../components/third_party_auth_button.dart';
import 'login.dart';
import '../master.dart';
import '../../utils/auth_service.dart';
import '../../components/auth_form_texfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
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
                      isPassword: false,
                      hintText: 'Username',
                      textEditingController: _username,
                    ),
                    AuthFormTextField(
                      hintText: 'Email',
                      isPassword: false,
                      textEditingController: _email,
                    ),
                    AuthFormTextField(
                      isPassword: true,
                      hintText: 'Password',
                      textEditingController: _password,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: AuthButton(
                        text: 'Sign Up',
                        onPressed: () {
                          FormState? formState = _formKey.currentState;
                          if (formState!.validate()) {
                            AuthServices()
                                .signUpWithEmailAndPassword(
                                  _username.text.toString(),
                                  _email.text.trim(),
                                  _password.text.toString(),
                                )
                                .then(
                                  (value) => showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                      title: 'Account Created',
                                      descriptions: 'Your account has been successfully created :)',
                                      text: 'Okay',
                                      onPressed: () => Navigator.push(
                                        context,
                                        ZoomPageRoute(
                                          page: const Master(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                          } else {
                            // Display error message to user;
                            showDialog(
                              context: context,
                              builder: (context) => const CustomDialogBox(
                                title: 'Form Incomplete',
                                descriptions: 'Please fill out the form before signing up.',
                                text: 'Okay',
                              ),
                            );
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
