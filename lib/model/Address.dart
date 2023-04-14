// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:utmletgo/constants/_constants.dart';

class Address {
  String type = AddressType.home.name;
  String addressLine1 = '',
      addressLine2 = '',
      city = '',
      state = '',
      postcode = '';

  Address();
  Address.complete(this.type, this.addressLine1, this.addressLine2, this.city,
      this.state, this.postcode);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'state': state,
      'postcode': postcode,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address.complete(
      map['type'] as String,
      map['addressLine1'] as String,
      map['addressLine2'] as String,
      map['city'] as String,
      map['state'] as String,
      map['postcode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);
}
