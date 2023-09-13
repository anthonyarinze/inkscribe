// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inkscribe/components/dialog_card.dart';
import 'package:inkscribe/theme/palette.dart';
import 'package:inkscribe/utils/auth_service.dart';
import 'package:inkscribe/utils/functions.dart';

class AddCommentDialog extends StatefulWidget {
  final String title;
  final Color color;
  const AddCommentDialog({super.key, required this.title, required this.color});

  @override
  AddCommentDialogState createState() => AddCommentDialogState();
}

class AddCommentDialogState extends State<AddCommentDialog> {
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  bool isCommentValid = false;
  Color selectedColor = Colors.blue; // Initialize with a default color.

  Widget _buildColorButton(Color color) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedColor = color; // Update the selected color.
        });
      },
      child: Container(
        width: 36, // Adjust the size of the circular button as needed.
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null, // Add a border to the selected color.
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleTextEditingController,
            onChanged: (text) {
              setState(() {
                isCommentValid = text.isNotEmpty; // Update the validity based on text input.
              });
            },
            decoration: const InputDecoration(labelText: 'Title'),
          ),
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
                        await AuthServices().addCommentToBook(widget.title, titleTextEditingController.text, textEditingController.text, selectedColor);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorButton(Palette.noteColor1),
              _buildColorButton(Palette.noteColor2),
              _buildColorButton(Palette.noteColor3),
              _buildColorButton(Palette.noteColor4),
              _buildColorButton(Palette.noteColor5),
              _buildColorButton(Palette.noteColor6),
            ],
          )
        ],
      ),
    );
  }
}
