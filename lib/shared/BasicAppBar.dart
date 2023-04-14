import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';

AppBar basicAppBar(
    {Widget? leading,
    required Widget? title,
    List<Widget>? actions,
    TabBar? bottom,
    bool automaticallyImplyLeading = false,
    bool centerTitle = true,
    Color? backgroundColor = kPrimaryColor,
    required double height}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    backgroundColor: backgroundColor,
    centerTitle: centerTitle,
    leading: leading,
    elevation: 5,
    toolbarHeight: height * 0.08,
    title: title,
    actions: actions,
    bottom: bottom,
  );
}
