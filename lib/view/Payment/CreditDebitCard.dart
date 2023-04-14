import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:math' as math;

class CreditDebitCard extends StatelessWidget {
  final String cardNumber, month, year, cvc, cardHolder;
  final Color color;
  final bool deletable;
  final dynamic onTap;
  const CreditDebitCard(
      {super.key,
      required this.cardNumber,
      required this.month,
      required this.year,
      required this.cvc,
      required this.cardHolder,
      required this.color,
      this.deletable = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    String convertMonthYear(String month, String year) {
      if (month.isNotEmpty)
        return month + '/' + year;
      else
        return '';
    }

    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          deletable
              ? Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: onTap,
                    child: Icon(
                      Icons.cancel,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                )
              : Center(),
          Text(
            'CREDIT CARD',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              Container(
                height: 25,
                width: 40,
                color: Colors.white,
              ),
              Flexible(
                  child: Center(
                      child: Text(cardNumber,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)))),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(convertMonthYear(month, year),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(cvc,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
          Spacer(),
          Text(cardHolder,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0))
        ],
      ),
    );
  }
}
