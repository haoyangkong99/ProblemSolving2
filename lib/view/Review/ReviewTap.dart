import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/view/Review/RatingDialog.dart';

class ReviewTap extends StatelessWidget {
  final String sellerGuid;
  ReviewTap(
      {super.key,
      required this.height,
      required this.width,
      required this.sellerGuid});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.075,
      width: width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) => RatingDialog(sellerGuid: sellerGuid));
          },
          child: Text(
            "Review",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
    );
  }
}
