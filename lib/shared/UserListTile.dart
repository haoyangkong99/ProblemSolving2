import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class UserListTile extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final double rating;
  final Widget? trailing;
  const UserListTile(
      {super.key,
      required this.image,
      required this.title,
      required this.rating,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      leading: ClipOvalImage(
          height: height * 0.1,
          width: width * 0.1,
          fit: BoxFit.cover,
          image: image),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          RatingBar.readOnly(
            size: 20,
            isHalfAllowed: true,
            halfFilledIcon: Icons.star_half,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            initialRating: rating,
          ),
          SizedBox(
            width: width * 0.1,
            child: Center(
              child: Text(
                "(${rating.toString()})",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      trailing: trailing,
    );
  }
}
