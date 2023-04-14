import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:utmletgo/constants/_constants.dart';

class CustomDropDownButton extends StatelessWidget {
  final List<String> data;
  final dynamic onChanged;
  final dynamic value;
  final double? width;
  const CustomDropDownButton(
      {super.key,
      required this.data,
      required this.onChanged,
      required this.value,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          focusColor: kPrimaryColor,
          borderRadius: BorderRadius.circular(25),
          items: data.map((val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Container(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        val,
                        maxLines: 2,
                        semanticsLabel: '...',
                        overflow: TextOverflow.ellipsis,
                      ))),
            );
          }).toList(),
          onChanged: onChanged,
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          elevation: 0,
        ),
      ),
    );
  }
}
