import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utmletgo/shared/Exception.dart';
import 'package:utmletgo/shared/_shared.dart';

void showFirebaseExceptionErrorDialogBox(
    BuildContext context, FirebaseException error) {
  showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogBox(
            title: error.code,
            content: error.message,
          ));
}

void showFirebaseAuthExceptionErrorDialogBox(
    BuildContext context, FirebaseAuthException error) {
  showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogBox(
            title: error.code,
            content: error.message,
          ));
}

void showExceptionErrorDialogBox(
    BuildContext context, Exception error, String title) {
  showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogBox(
            title: title,
            content: error.toString(),
          ));
}

void showGeneralExceptionErrorDialogBox(
    BuildContext context, GeneralException error) {
  showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogBox(
            title: error.title,
            content: error.message,
          ));
}
