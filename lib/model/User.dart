// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/Account.dart';

import '_model.dart';

class User extends Account {
  String name = '',
      gender = '',
      status = '',
      campus = '',
      contact = '',
      profilePicture = '';

  String visibility = VisibilityType.allow.name;
  List<Address> addresses = [];
  List<String> itemLink = [];
  ReviewsLink reviewsLink = ReviewsLink();
  User() : super();
  User.complete(
      String guid,
      String email,
      String userType,
      this.name,
      this.gender,
      this.status,
      this.campus,
      this.contact,
      this.visibility,
      this.profilePicture,
      this.addresses,
      this.reviewsLink,
      this.itemLink)
      : super.complete(guid, email, userType);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'guid': guid,
      'email': email,
      'name': name,
      'gender': gender,
      'status': status,
      'campus': campus,
      'contact': contact,
      'addresses': addresses.map((e) => e.toMap()),
      'visibility': visibility,
      'profilePicture': profilePicture,
      'userType': userType,
      'reviewsLink': reviewsLink.toMap(),
      'itemLink': itemLink,
    };
    return map;
  }

  factory User.fromMap(Map<String, dynamic>? map) {
    List<dynamic> addressesJson = map!['addresses'];
    List<Address> addresses =
        addressesJson.map((e) => Address.fromMap(e)).toList();
    List<dynamic> itemLinksJson = map['itemLink'];
    List<String> itemLinks = itemLinksJson.map((e) => e.toString()).toList();

    return User.complete(
      map['guid'] as String,
      map['email'] as String,
      map['userType'] as String,
      map['name'] as String,
      map['gender'] as String,
      map['status'] as String,
      map['campus'] as String,
      map['contact'] as String,
      map['visibility'] as String,
      map['profilePicture'] as String,
      addresses,
      ReviewsLink.fromMap(map['reviewsLink'] as Map<String, dynamic>),
      itemLinks,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
