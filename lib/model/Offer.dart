import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Offer {
  String guid = '', type = '', status = '', itemGuid = '';
  double price = 0;
  Offer();
  Offer.complete(this.guid, this.itemGuid, this.type, this.status, this.price);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
      'itemGuid': itemGuid,
      'type': type,
      'status': status,
      'price': price,
    };
  }

  factory Offer.fromMap(Map<String, dynamic>? map) {
    return Offer.complete(
      map!['guid'] as String,
      map['itemGuid'] as String,
      map['type'] as String,
      map['status'] as String,
      map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Offer.fromJson(String source) =>
      Offer.fromMap(json.decode(source) as Map<String, dynamic>);
}
