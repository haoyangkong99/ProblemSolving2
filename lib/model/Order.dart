// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:utmletgo/model/Payment.dart';
import 'package:utmletgo/model/_model.dart';

class Order {
  String guid = '', offerGuid = '', itemGuid = '', status = '', buyerGuid = '';
  double amount = 0;
  List<Payment> payment = [];
  Address shippingAddress = Address();
  Order();
  Order.complete(
      {required this.guid,
      required this.offerGuid,
      required this.itemGuid,
      required this.status,
      required this.amount,
      required this.payment,
      required this.shippingAddress,
      required this.buyerGuid});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
      'offerGuid': offerGuid,
      'itemGuid': itemGuid,
      'status': status,
      'amount': amount,
      'payment': payment.map((x) => x.toMap()).toList(),
      'shippingAddress': shippingAddress.toMap(),
      'buyerGuid': buyerGuid
    };
  }

  factory Order.fromMap(Map<String, dynamic>? map) {
    List<dynamic> paymentJson = map!['payment'];
    List<Payment> paymentList =
        paymentJson.map((e) => Payment.fromMap(e)).toList();

    return Order.complete(
        guid: map['guid'] as String,
        offerGuid: map['offerGuid'] as String,
        itemGuid: map['itemGuid'] as String,
        status: map['status'] as String,
        amount: map['amount'] as double,
        payment: paymentList,
        shippingAddress: Address.fromMap(map['shippingAddress']),
        buyerGuid: map['buyerGuid'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
