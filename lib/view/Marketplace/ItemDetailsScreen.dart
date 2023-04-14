import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:enhanced_read_more/enhanced_read_more.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/UserListTile.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Marketplace/MakeOfferBottomSheet.dart';
import 'package:utmletgo/view/Review/ReviewCard.dart';
import 'package:utmletgo/view/Review/ReviewScreen.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({
    super.key,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  bool isFav = false;
  List<String> images = [];
  late User user;
  late ReviewsLink reviewsLink;
  TextEditingController _offer = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return ViewModelBuilder<ItemViewModel>.reactive(
        viewModelBuilder: () => ItemViewModel(),
        builder: (context, model, child) {
          if (model.dataReady('item') && model.dataReady('user')) {
            Item item = model.dataMap!['item'] as Item;
            List<User> temp = model.dataMap!['user'] as List<User>;
            User seller = temp.first;
            images.clear();
            images.add(item.coverImage);
            images.addAll(item.images!.map((e) => e));
            user = seller;
            reviewsLink = user.reviewsLink;
            ImageProvider showProfilePicture() {
              if (seller.profilePicture.isNotEmpty) {
                return NetworkImage(seller.profilePicture);
              } else {
                return AssetImage(seller.gender == Gender.Male.name
                    ? "assets/images/man profile icon.png"
                    : "assets/images/lady profile icon.png");
              }
            }

            return Scaffold(
              appBar: basicAppBar(
                height: getMediaQueryHeight(context),
                automaticallyImplyLeading: true,
                title: const Text(
                  "Item Details",
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: SizedBox(
                        height: height * 0.3,
                        child: Swiper(
                          loop: false,
                          indicatorLayout: PageIndicatorLayout.COLOR,
                          itemCount: images.length,
                          itemBuilder: (context, idx) => Container(
                            height: MediaQuery.of(context).size.height / 3.2,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                images[idx],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: Text(
                        "RM ${item.price.toString()}",
                        style:
                            const TextStyle(fontSize: 14.0, color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: Text(
                        "Quantity: ${item.quantity.toString()}",
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SubTitleHeader(text: "Description"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: ReadMoreText(
                        item.description,
                        style: const TextStyle(wordSpacing: 2),
                        trimLines: 4,
                        collapsed: true,
                        colorClickableText: Colors.blue[700],
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700]),
                        lessStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[300]),
                      ),
                    ),
                    const SubTitleHeader(
                      text: "Seller",
                    ),
                    InkWell(
                      onTap: () {},
                      child: UserListTile(
                        image: showProfilePicture(),
                        title: user.name,
                        rating: reviewsLink.averageRating,
                      ),
                    ),
                    SubTitleHeader(
                      text: "Reviews",
                      trailing: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReviewScreen(
                                      sellerGuid: user.guid,
                                    )));
                          },
                          child: Row(
                            children: [
                              Text(
                                "Read All",
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 16),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.blue[700],
                              )
                            ],
                          )),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: SizedBox(
                    //     height: height * 0.3,
                    //     child: Swiper(
                    //       loop: false,
                    //       itemCount: 2,
                    //       itemBuilder: (context, index) => const ReviewCard(
                    //           avatar: AssetImage("assets/images/cover.png"),
                    //           title: "Item title",
                    //           date: "2022",
                    //           rating: 4,
                    //           message:
                    //               "TEST messagexxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                    //           name: "ABC",
                    //           img:
                    //               "https://www.bmw.com.my/content/dam/bmw/common/all-models/m-series/series-overview/bmw-m-series-seo-overview-ms-04.jpg",
                    //           price: 9990,
                    //           quantity: 1),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                  height: height * 0.1,
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                if (isFav) {
                                  isFav = false;
                                } else {
                                  isFav = true;
                                }
                              });
                            },
                            fillColor: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Btn(
                                text: "Contact",
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                backgroundColor: Colors.white,
                                borderColor: Colors.grey,
                                width: width * 0.25,
                                height: height * 0.05,
                                onPressed: () {
                                  model
                                      .navigateToChatScreen(
                                          item.guid, seller.guid)
                                      .onError<Exception>((error, stackTrace) =>
                                          showExceptionErrorDialogBox(
                                              context, error, 'CHAT ERROR'));
                                },
                                isRound: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Btn(
                                text: "Make Offer",
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                backgroundColor: kPrimaryColor,
                                borderColor: kPrimaryColor,
                                width: width * 0.25,
                                height: height * 0.05,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          MakeOfferBottomSheet(
                                            controller: _offer,
                                            onPressed: () {
                                              model
                                                  .makeOffer(item.guid,
                                                      seller.guid, _offer.text)
                                                  .onError<Exception>((error,
                                                          stackTrace) =>
                                                      showExceptionErrorDialogBox(
                                                          context,
                                                          error,
                                                          'CHAT ERROR'));
                                            },
                                          ));
                                },
                                isRound: false),
                          )
                        ],
                      ))),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          }
        });
  }
}
