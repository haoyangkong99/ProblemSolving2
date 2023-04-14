// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReviewsLink {
  double averageRating = 0;
  int reviewsCount = 0;
  List<String> reviewsGuid = List.empty();

  ReviewsLink();
  ReviewsLink.complete(this.averageRating, this.reviewsCount, this.reviewsGuid);

  Map<String, dynamic>? toMap() {
    return <String, dynamic>{
      'averageRating': averageRating,
      'reviewsCount': reviewsCount,
      'reviewsGuid': reviewsGuid,
    };
  }

  factory ReviewsLink.fromMap(Map<String, dynamic> map) {
    List<dynamic>? guidJson = map['reviewsGuid'];
    List<String>? guids = guidJson!.map((e) => e.toString()).toList();
    return ReviewsLink.complete(
        map['averageRating'] as double, map['reviewsCount'] as int, guids);
  }

  String toJson() => json.encode(toMap());

  factory ReviewsLink.fromJson(String source) =>
      ReviewsLink.fromMap(json.decode(source) as Map<String, dynamic>);
}
