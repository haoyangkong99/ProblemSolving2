import 'package:card_swiper/card_swiper.dart';
import 'package:enhanced_read_more/enhanced_read_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Manage/EditItemScreen.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class MyItemScreen extends StatefulWidget {
  const MyItemScreen({super.key});

  @override
  State<MyItemScreen> createState() => _MyItemScreenState();
}

class _MyItemScreenState extends State<MyItemScreen> {
  bool isFav = false;
  List<String> images = [];
  TextEditingController _offer = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return ViewModelBuilder<ItemViewModel>.reactive(
        viewModelBuilder: () => ItemViewModel(),
        builder: (context, model, child) {
          if (model.dataReady('user') && model.dataReady('item')) {
            Item item = model.dataMap!['item'] as Item;
            images.clear();
            images.add(item.coverImage);
            images.addAll(item.images!.map((e) => e));

            return Scaffold(
              appBar: basicAppBar(
                height: getMediaQueryHeight(context),
                automaticallyImplyLeading: true,
                title: const Text(
                  "Item Details",
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditItemScreen()));
                      },
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  child: Column(
                    // shrinkWrap: true,
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
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item.title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "RM ${item.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Quantity: ${item.quantity.toString()}",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      const SubTitleHeader(text: "Description"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
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
                      ),
                      const SubTitleHeader(text: "Status"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          // alignment: WrapAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Chip(
                              backgroundColor: kPrimaryColor,
                              label: Text(
                                item.status
                                    .replaceAll(RegExp(r'_'), ' ')
                                    .toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SubTitleHeader(text: "Payment Methods"),
                      Wrap(
                          spacing: 5.0,
                          children: List.generate(
                              item.paymentMethods!.length,
                              (index) => Chip(
                                  label: Text(
                                    item.paymentMethods![index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: kPrimaryColor)))
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                  height: height * 0.12,
                  child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 1))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Btn(
                                text: "Out For Delivery",
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                backgroundColor: kPrimaryColor,
                                borderColor: kPrimaryColor,
                                width: width * 0.3,
                                height: height * 0.05,
                                onPressed: () {},
                                isRound: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Btn(
                                text: "View Offer",
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                backgroundColor: Colors.white,
                                borderColor: Colors.grey,
                                width: width * 0.3,
                                height: height * 0.05,
                                onPressed: () {},
                                isRound: false),
                          ),
                        ],
                      ))),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }
        });
  }
}
