import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inkscribe/components/dialog_card.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:inkscribe/utils/functions.dart';

class AddCommentDialog extends StatefulWidget {
  final String title;
  const AddCommentDialog({super.key, required this.title});

  @override
  AddCommentDialogState createState() => AddCommentDialogState();
}

class AddCommentDialogState extends State<AddCommentDialog> {
  TextEditingController textEditingController = TextEditingController();
  bool isCommentValid = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textEditingController,
            onChanged: (text) {
              setState(() {
                isCommentValid = text.isNotEmpty; // Update the validity based on text input.
              });
            },
            decoration: const InputDecoration(labelText: 'Your Comment'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: isCommentValid
                  ? () async {
                      try {
                        await AuthServices().addCommentToBook(widget.title, textEditingController.text);
                        Navigator.pop(context);
                      } on SocketException catch (error) {
                        ReusableFunctions.logError(error.message);
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) => CustomDialogBox(title: "Error", descriptions: error.message, text: "Close"),
                        );
                      }
                    }
                  : null, // Disable the button when there's no comment.
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
