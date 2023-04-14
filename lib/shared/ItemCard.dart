import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/_shared.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String img;
  final double price;
  final int quantity;
  final dynamic onTap;
  final double? height;
  const ItemCard(
      {super.key,
      required this.img,
      required this.title,
      required this.price,
      required this.quantity,
      this.height,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 2,
          child: ItemCardBody(
              height: height,
              width: width,
              img: img,
              title: title,
              price: price,
              quantity: quantity),
        ),
      ),
    );
  }
}
