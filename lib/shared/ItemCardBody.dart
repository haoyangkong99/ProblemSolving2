import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';

class ItemCardBody extends StatelessWidget {
  const ItemCardBody({
    super.key,
    required this.height,
    required this.width,
    required this.img,
    required this.title,
    required this.price,
    required this.quantity,
  });

  final double height;
  final double width;
  final String img;
  final String title;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getMediaQueryHeight(context) * 0.18,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.03,
              right: width * 0.03,
            ),
            child: Container(
              height: height * 0.15,
              width: width * 0.35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  img,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10.0),
              Text(
                "RM ${price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 14.0, color: Colors.red),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Quantity: ${quantity.toString()}",
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
