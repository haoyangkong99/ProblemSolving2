import 'package:flutter/material.dart';

class ClipOvalImage extends StatelessWidget {
  final ImageProvider image;
  final double height, width;
  final BoxFit fit;
  const ClipOvalImage(
      {super.key,
      required this.image,
      required this.height,
      required this.width,
      required this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: fit,
          image: image,
        ),
      ),
    );
  }
}
