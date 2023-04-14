// Get the proportionate height as per screen size
import 'package:flutter/material.dart';

double getProportionateScreenHeight(double inputHeight, double height) {
  double? screenHeight = height;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth, double width) {
  double screenWidth = width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

double getMediaQueryHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getMediaQueryWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
