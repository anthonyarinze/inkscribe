import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/pages/auth/sign_up.dart';
import 'package:inkscribe/pages/master.dart';

import '../../components/dialog_card.dart';
import '../../utils/auth_service.dart';
import '../../components/auth_button.dart';
import '../../components/auth_form_texfield.dart';
import '../../components/page_builder.dart';
import '../../components/third_party_auth_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
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
                        text: 'Login',
                        onPressed: () async {
                          FormState? formState = _formKey.currentState;
                          if (formState!.validate()) {
                            await AuthServices().loginWithEmailAndPassword(
                              _email.text,
                              _password.text,
                            );
                            Navigator.push(context, ZoomPageRoute(page: const Master()));
                          } else {
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
                  text: 'Login with Google',
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
                      ZoomPageRoute(page: const SignUp()),
                    ),
                    child: Text(
                      "Sign Up",
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
