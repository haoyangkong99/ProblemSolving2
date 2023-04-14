import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:utmletgo/constants/_constants.dart';

class AddressCard extends StatelessWidget {
  final AddressType type;
  final String message;
  final dynamic? onTap;
  const AddressCard(
      {super.key, required this.type, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    Color backgroundColor, iconTextColor;
    IconData icon;
    switch (type) {
      case AddressType.home:
        icon = Icons.house_outlined;
        backgroundColor = kPrimaryColor;
        iconTextColor = Colors.white;
        break;
      case AddressType.workplace:
        icon = Icons.work_outline_outlined;
        backgroundColor = kPrimaryColor;
        iconTextColor = Colors.white;
        break;
      case AddressType.unfilled:
        icon = Icons.house_outlined;
        backgroundColor = Colors.white;
        iconTextColor = Colors.black;
        break;
    }
    return InkWell(
      child: Container(
        width: width * 0.25,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            type.name == AddressType.unfilled
                ? Center()
                : Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: onTap,
                      child: Icon(
                        Icons.cancel,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  icon,
                  size: 30,
                  color: iconTextColor,
                ),
              ),
            ),
            Flexible(
              child: Text(message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: iconTextColor,
                    fontSize: 14.0,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
