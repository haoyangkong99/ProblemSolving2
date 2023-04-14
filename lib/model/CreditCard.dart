import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CreditCard {
  String guid, userGuid, cardNumber, cardHolder;
  int year, month, cvc;
  CreditCard(
      {required this.guid,
      required this.userGuid,
      required this.cardHolder,
      required this.cvc,
      required this.cardNumber,
      required this.month,
      required this.year});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
      'userGuid': userGuid,
      'cardNumber': cardNumber,
      'cardHolder': cardHolder,
      'cvc': cvc,
      'year': year,
      'month': month
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic>? map) {
    return CreditCard(
      guid: map!['guid'] as String,
      userGuid: map['userGuid'] as String,
      cardNumber: map['cardNumber'] as String,
      cardHolder: map['cardHolder'] as String,
      cvc: map['cvc'] as int,
      year: map['year'] as int,
      month: map['month'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditCard.fromJson(String source) =>
      CreditCard.fromMap(json.decode(source) as Map<String, dynamic>);
}
