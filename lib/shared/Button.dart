import 'package:flutter/material.dart';

import '../constants/_constants.dart';

// TextButton froyoFlatBtn(String text, onPressed) {
//   return TextButton(
//     onPressed: onPressed,
//     child: Text(
//       text,
//       style: TextStyle(
//         color: Colors.white,
//       ),
//     ),
//     style: ButtonStyle(
//         backgroundColor:
//             MaterialStateColor.resolveWith((states) => primaryColor),
//         shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
//   );
// }

Widget Btn(
    {required String text,
    required onPressed,
    textStyle,
    backgroundColor,
    borderColor,
    width,
    height,
    required bool isRound,
    onLongPress}) {
  return OutlinedButton(
      onLongPress: onLongPress,
      onPressed: onPressed,
      style: ButtonStyle(
        // padding: MaterialStateProperty.all<EdgeInsets>(),
        backgroundColor: MaterialStateProperty.all(backgroundColor),

        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isRound ? 25 : 4)),
        ),
        side: MaterialStateBorderSide.resolveWith(
          ((states) => BorderSide(color: borderColor)),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ));
}
