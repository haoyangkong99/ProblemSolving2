import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/DateTimeConversion.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      height: getMediaQueryHeight(context) * 0.6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(message.message),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                });
          },
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Image.network(message.message),
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            formateTime(convertToDateTime(message.timeSent)),
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
