import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/ItemCard.dart';
import 'package:utmletgo/shared/UserListTile.dart';
import 'package:utmletgo/shared/_shared.dart';

class ReviewCard extends StatelessWidget {
  final ImageProvider avatar;
  final String name, title, date, img;
  final double rating, price;
  final int quantity;
  final String message;
  const ReviewCard(
      {super.key,
      required this.avatar,
      required this.title,
      required this.date,
      required this.rating,
      required this.message,
      required this.name,
      required this.img,
      required this.price,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            width * 0.05, height * 0.01, width * 0.05, height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserListTile(
              image: avatar,
              title: name,
              rating: rating,
              trailing: Text(
                date,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                      height: height * 0.1,
                      width: width * 0.2,
                      child: Image.network(img)),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "RM ${price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
