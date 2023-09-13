// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkscribe/components/auth_button.dart';
import 'package:inkscribe/components/auth_form_texfield.dart';
import 'package:inkscribe/components/dialog_card.dart';
import 'package:inkscribe/pages/auth/login.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:inkscribe/utils/functions.dart';

import '../../components/page_builders/page_builder.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: Text("Reset Password", style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 20.0),
              child: Text(
                "Enter your email assosciated with your account and we'll send you an OTP to reset your password.",
                style: GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: AuthFormTextField(
                hintText: "Email",
                isPassword: false,
                textEditingController: textEditingController,
              ),
            ),
            Form(
              key: _formKey,
              child: AuthButton(
                text: "Reset password",
                onPressed: () async {
                  FormState? formState = _formKey.currentState;
                  if (formState!.validate()) {
                    try {
                      await AuthServices().resetPassword(textEditingController.text);
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialogBox(
                          title: "Code Sent",
                          descriptions: "An OTP has been sent to your email. You will now be redirected to a page to complete the reset process.",
                          text: "Proceed",
                          onPressed: () => Navigator.push(context, ZoomPageRoute(page: const Login())),
                        ),
                      );
                    } on FirebaseException catch (error) {
                      ReusableFunctions.logError(error.message);
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialogBox(
                          title: "Error",
                          descriptions: error.message.toString(),
                          text: "Okay",
                        ),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const CustomDialogBox(
                        title: "Form incomplete",
                        descriptions: "Please fill out the form before signing up.",
                        text: "Okay",
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
