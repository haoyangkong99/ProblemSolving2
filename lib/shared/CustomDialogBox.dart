import 'package:flutter/material.dart';
import 'package:utmletgo/constants/constants.dart';

class CustomDialogBox extends StatelessWidget {
  final String? title, content;
  final bool isConfirm, isOtherContent;
  final dynamic actions;
  final Widget? otherContent;
  const CustomDialogBox(
      {super.key,
      required this.title,
      this.content,
      this.isConfirm = false,
      this.actions,
      this.isOtherContent = false,
      this.otherContent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text(title!),
        content: isOtherContent ? otherContent : Text(content!),
        actions: isConfirm
            ? actions
            : [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                ),
              ]);
  }
}
