// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';

class Reviews {
  String guid = '', postDT = '', message = '', reviewerGuid = '', itemGuid = '';
  double rating = 0.0;

  Reviews();
  Reviews.complete(this.guid, this.postDT, this.message, this.rating,
      this.reviewerGuid, this.itemGuid);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
      'postDT': postDT,
      'message': message,
      'rating': rating,
      'reviewerGuid': reviewerGuid,
      'itemGuid': itemGuid
    };
  }

  factory Reviews.fromMap(Map<String, dynamic>? map) {
    return Reviews.complete(
      map!['guid'] as String,
      map['postDT'] as String,
      map['message'] as String,
      map['rating'] as double,
      map['reviewerGuid'] as String,
      map['itemGuid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reviews.fromJson(String source) =>
      Reviews.fromMap(json.decode(source) as Map<String, dynamic>);
}
