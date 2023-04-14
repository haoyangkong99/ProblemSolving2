// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:utmletgo/constants/_constants.dart';

import '_model.dart';

class Item {
  String guid = '',
      coverImage = '',
      category = '',
      subcategory = '',
      condition = '',
      title = '',
      description = '',
      location = '',
      status = '',
      postedDT = '',
      visibility = VisibilityType.allow.name;
  List<String>? images, paymentMethods;
  double price = 0;
  int quantity = 0;
  ReviewsLink reviewsLink = ReviewsLink();
  Item();
  Item.complete(
      this.guid,
      this.coverImage,
      this.category,
      this.subcategory,
      this.condition,
      this.title,
      this.description,
      this.location,
      this.status,
      this.postedDT,
      this.visibility,
      this.images,
      this.paymentMethods,
      this.price,
      this.quantity,
      this.reviewsLink);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
      'coverImage': coverImage,
      'category': category,
      'subcategory': subcategory,
      'condition': condition,
      'title': title,
      'description': description,
      'location': location,
      'status': status,
      'postedDT': postedDT,
      'visibility': visibility,
      'images': images,
      'paymentMethods': paymentMethods,
      'price': price,
      'quantity': quantity,
      'reviewsLink': reviewsLink.toMap(),
    };
  }

  factory Item.fromMap(Map<String, dynamic>? map) {
    List<dynamic> imagesJson = map!['images'];
    List<String> images = imagesJson.map((e) => e.toString()).toList();
    List<dynamic> paymentMethodsJson = map['paymentMethods'];
    List<String> paymentMethods =
        paymentMethodsJson.map((e) => e.toString()).toList();

    return Item.complete(
      map['guid'] as String,
      map['coverImage'] as String,
      map['category'] as String,
      map['subcategory'] as String,
      map['condition'] as String,
      map['title'] as String,
      map['description'] as String,
      map['location'] as String,
      map['status'] as String,
      map['postedDT'] as String,
      map['visibility'] as String,
      images,
      paymentMethods,
      map['price'] as double,
      map['quantity'] as int,
      ReviewsLink.fromMap(map['reviewsLink'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
