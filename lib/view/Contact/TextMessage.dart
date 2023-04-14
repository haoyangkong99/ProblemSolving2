import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/DateTimeConversion.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({Key? key, required this.message, required this.isSender})
      : super(key: key);

  final Message message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20 * 0.75, vertical: 20 / 2),
          decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(isSender ? 1 : 0.08),
              borderRadius: BorderRadius.circular(30)),
          child: Text(
            message.message,
            style: TextStyle(
                color: isSender
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyText1?.color),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            formateTime(convertToDateTime(message.timeSent)),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
