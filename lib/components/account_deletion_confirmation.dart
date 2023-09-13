import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/auth/sign_up.dart';
import '../utils/auth_service.dart';
import 'page_builders/page_builder.dart';

class AccountDeletionConfirmationWidget extends StatelessWidget {
  const AccountDeletionConfirmationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm"),
      content: SizedBox(
        height: 80.0,
        child: Column(
          children: [
            Text(
              style: GoogleFonts.roboto(fontSize: 15.0),
              "Clicking yes will delete your account. Are you sure you want to proceed?",
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => AuthServices().deleteAccount().then(
                (value) => Navigator.push(
                  context,
                  ZoomPageRoute(
                    page: const SignUp(),
                  ),
                ),
              ),
          icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
          label: Text(
            "Delete",
            style: GoogleFonts.roboto(color: Colors.red),
          ),
        ),
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel_outlined),
          label: Text(
            "Cancel",
            style: GoogleFonts.roboto(),
          ),
        ),
      ],
    );
  }
}
