import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmletgo/constants/_constants.dart';

class MakeOfferBottomSheet extends StatelessWidget {
  final onPressed;
  MakeOfferBottomSheet(
      {super.key, required this.onPressed, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: kPrimaryColor,
          height: getMediaQueryHeight(context) * 0.05,
          child: const Center(
            child: Text(
              "Make Offer",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
            height: getMediaQueryHeight(context) * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.grey[200]),
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      controller: controller,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          hintText: "Price"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 1, color: Colors.white),
                  ),
                  style: ButtonStyle(
                      elevation:
                          MaterialStateProperty.resolveWith((states) => 2),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => kPrimaryColor),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 30),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                )
              ],
            )),
      ],
    );
  }
}
