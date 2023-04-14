import 'package:flutter/material.dart';

import 'package:utmletgo/constants/size_config.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String imgPath;
  final Color begin;
  final Color end;
  final onTap;
  const CategoryCard(
      {super.key,
      required this.name,
      required this.imgPath,
      required this.begin,
      required this.end,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: getMediaQueryHeight(context) * 0.15,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [begin, end],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                      widthFactor: 0.8,
                      alignment: const Alignment(-1, 0),
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    height: getMediaQueryHeight(context) * 0.15,
                    width: getMediaQueryWidth(context) * 0.3,
                    child: Image.asset(imgPath),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
