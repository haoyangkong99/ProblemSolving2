import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/Reviews.dart';
import 'package:utmletgo/model/User.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/DateTimeConversion.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:utmletgo/view/Marketplace/MakeOfferBottomSheet.dart';
import 'package:utmletgo/view/Review/ReviewCard.dart';
import 'package:utmletgo/view/Review/ReviewTap.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class ReviewScreen extends StatefulWidget {
  final String sellerGuid;
  ReviewScreen({super.key, required this.sellerGuid});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return ViewModelBuilder<ReviewsViewModel>.reactive(
        viewModelBuilder: () => ReviewsViewModel(userGuid: widget.sellerGuid),
        builder: (context, model, child) {
          if (model.dataReady('reviews') &&
              model.dataReady('userList') &&
              model.dataReady('seller') &&
              model.dataReady('orderList') &&
              model.dataReady('itemList')) {
            User seller = model.dataMap!['seller'];
            List<Reviews> reviewsList = model.dataMap!['reviews'];
            reviewsList = reviewsList
                .where((element) =>
                    seller.reviewsLink.reviewsGuid.contains(element.guid))
                .toList();
            List<User> reviewerList = model.dataMap!['userList'];
            List<String> involvedReviewerGuidList =
                reviewsList.map((e) => e.reviewerGuid).toList();
            reviewerList = reviewerList
                .where((element) =>
                    involvedReviewerGuidList.contains(element.guid))
                .toList();

            List<Item> allItemList = model.dataMap!['itemList'];
            List<Item> itemList = allItemList
                .where((element) => reviewsList
                    .map((e) => e.itemGuid)
                    .toList()
                    .contains(element.guid))
                .toList();
            List<Order> orderList = model.dataMap!['orderList'];
            List<String> orderItemGuid =
                orderList.map((e) => e.itemGuid).toList();
            orderItemGuid = orderItemGuid
                .where((element) =>
                    !reviewsList.any((r) => element.contains(r.itemGuid)))
                .toList();
            List<Item> completedItemList = allItemList
                .where((element) => orderItemGuid.contains(element.guid))
                .toList();
            int counter = seller.reviewsLink.reviewsCount.isFinite
                ? 1
                : seller.reviewsLink.reviewsCount;

            double average = seller.reviewsLink.averageRating.isFinite
                ? seller.reviewsLink.averageRating
                : 0;
            int fiveStars = reviewsList.isEmpty
                ? 2
                : reviewsList.where((element) => element.rating == 5).length;

            int fourStars = reviewsList.isEmpty
                ? 2
                : reviewsList.where((element) => element.rating == 4).length;
            int threeStars = reviewsList.isEmpty
                ? 2
                : reviewsList.where((element) => element.rating == 3).length;
            int twoStars = reviewsList.isEmpty
                ? 2
                : reviewsList.where((element) => element.rating == 2).length;
            int oneStars = reviewsList.isEmpty
                ? 2
                : reviewsList.where((element) => element.rating == 1).length;
            return Scaffold(
                appBar: basicAppBar(
                    height: getMediaQueryHeight(context),
                    automaticallyImplyLeading: true,
                    centerTitle: false,
                    title: Text(
                      "Reviews - ${seller.name}",
                    )),
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.1, height * 0.03,
                          width * 0.1, height * 0.03),
                      child: RatingSummary(
                        counter: counter,
                        average: average,
                        showAverage: true,
                        counterFiveStars: fiveStars,
                        counterFourStars: fourStars,
                        counterThreeStars: threeStars,
                        counterTwoStars: twoStars,
                        counterOneStars: oneStars,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 1))),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
                              child: Text(
                                "Recent Reviews",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          reviewsList.isEmpty
                              ? Container(
                                  width: width,
                                  height: height * 0.4,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              'assets/images/No matching items.png'))),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: reviewsList.length,
                                      itemBuilder: (context, index) => Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            child: ReviewCard(
                                                avatar: NetworkImage(reviewerList
                                                    .where((element) =>
                                                        element.guid ==
                                                        reviewsList[index]
                                                            .reviewerGuid)
                                                    .first
                                                    .profilePicture),
                                                title: itemList
                                                    .where((element) =>
                                                        element.guid ==
                                                        reviewsList[index]
                                                            .itemGuid)
                                                    .first
                                                    .title,
                                                date: formateDateTime(convertToDateTime(
                                                    reviewsList[index].postDT)),
                                                rating: reviewsList[index]
                                                    .rating
                                                    .toDouble(),
                                                message:
                                                    reviewsList[index].message,
                                                name: reviewerList
                                                    .where((element) =>
                                                        element.guid ==
                                                        reviewsList[index]
                                                            .reviewerGuid)
                                                    .first
                                                    .name,
                                                img: itemList.where((element) => element.guid == reviewsList[index].itemGuid).first.coverImage,
                                                price: itemList.where((element) => element.guid == reviewsList[index].itemGuid).first.price,
                                                quantity: itemList.where((element) => element.guid == reviewsList[index].itemGuid).first.quantity),
                                          )),
                                )
                        ],
                      ),
                    ))
                  ],
                ),
                bottomNavigationBar: completedItemList.isNotEmpty
                    ? ReviewTap(
                        height: height,
                        width: width,
                        sellerGuid: widget.sellerGuid,
                      )
                    : null);
          } else {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }
        });
  }
}
