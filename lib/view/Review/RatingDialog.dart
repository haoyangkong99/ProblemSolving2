import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/ReviewsViewModel.dart';

class RatingDialog extends StatefulWidget {
  final String sellerGuid;
  RatingDialog({super.key, required this.sellerGuid});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  TextEditingController _feedbackController = TextEditingController();
  String selectedItemGuid = '';
  String selectedItemTitle = '';

  double rating = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = getMediaQueryHeight(context);
    return ViewModelBuilder<ReviewsViewModel>.reactive(
        viewModelBuilder: () => ReviewsViewModel(userGuid: widget.sellerGuid),
        builder: (context, model, child) {
          if (model.dataReady('reviews') &&
              model.dataReady('userList') &&
              model.dataReady('seller') &&
              model.dataReady('itemList') &&
              model.dataReady('orderList')) {
            User seller = model.dataMap!['seller'];
            List<Reviews> reviewsList = model.dataMap!['reviews'];
            reviewsList = reviewsList
                .where((element) =>
                    seller.reviewsLink.reviewsGuid.contains(element.guid))
                .toList();
            List<User> reviewerList = model.dataMap!['userList'];
            reviewerList = reviewerList
                .where((element) => reviewsList
                    .map((e) => e.itemGuid)
                    .toList()
                    .contains(element.guid))
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
            if (completedItemList.isNotEmpty) {
              selectedItemTitle = completedItemList.first.title;
              selectedItemGuid = completedItemList.first.guid;
            }
            return Dialog(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey[50]),
                  padding: EdgeInsets.all(24.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      'Rate & Review ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          focusColor: kPrimaryColor,
                          //   dropdownColor: Colors.lightBlue[100],
                          borderRadius: BorderRadius.circular(25),
                          items: completedItemList.map((val) {
                            return DropdownMenuItem<String>(
                              value: val.title,
                              child: Container(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        val.title,
                                        maxLines: 2,
                                        semanticsLabel: '...',
                                        overflow: TextOverflow.ellipsis,
                                      ))),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedItemGuid = completedItemList
                                  .where((element) => element.title == newValue)
                                  .first
                                  .guid;
                              selectedItemTitle = newValue.toString();
                            });
                          },

                          value: selectedItemTitle,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down),
                          elevation: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'Montserrat', color: Colors.grey),
                            children: [
                              TextSpan(
                                text: 'Please rate ',
                              ),
                            ]),
                      ),
                    ),
                    RatingBar(
                      minRating: 1,
                      itemSize: 32,
                      allowHalfRating: false,
                      initialRating: 1,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (value) {
                        rating = value;
                      },
                      ratingWidget: RatingWidget(
                        empty: Icon(Icons.star_outline,
                            color: Colors.yellow, size: 20),
                        full: Icon(
                          Icons.star_outlined,
                          color: Colors.yellow,
                          size: 20,
                        ),
                        half: SizedBox(),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _feedbackController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Say something about the product.'),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLength: 200,
                        )),
                    Btn(
                        text: "Post",
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        backgroundColor: kPrimaryColor,
                        borderColor: kPrimaryColor,
                        width: width * 0.5,
                        height: height * 0.05,
                        onPressed: () async {
                          if (selectedItemGuid.isEmpty) {
                            showIncompleteFieldsDialogBox(context);
                          } else {
                            await model
                                .createReviews(selectedItemGuid, rating,
                                    _feedbackController.text)
                                .whenComplete(() => Navigator.pop(context));
                          }
                        },
                        isRound: false)
                  ])),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }
        });
  }
}
