import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Payment {
  String method, paymentDT, status;
  double amount;
  Map<String, Object> paymentInfo;
  Payment({
    required this.method,
    required this.status,
    required this.amount,
    required this.paymentDT,
    required this.paymentInfo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'method': method,
      'paymentDT': paymentDT,
      'status': status,
      'amount': amount,
      'paymentInfo': paymentInfo,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      method: map['method'] as String,
      paymentDT: map['paymentDT'] as String,
      status: map['status'] as String,
      amount: map['amount'] as double,
      paymentInfo: map['paymentInfo'] as Map<String, Object>,
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source) as Map<String, dynamic>);
}
