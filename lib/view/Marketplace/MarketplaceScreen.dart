import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Marketplace/_marketplace.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return Scaffold(
      appBar: basicAppBar(
        // backgroundColor: Colors.white,
        height: height,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOvalImage(
              height: height * 0.04,
              width: width * 0.04,
              fit: BoxFit.contain,
              image: const AssetImage(
                "assets/images/icon.png",
              )),
        ),
        title: const SearchBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Text(
              "Browse By Category",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const CategoryCardList()
        ],
      ),
    );
  }
}
