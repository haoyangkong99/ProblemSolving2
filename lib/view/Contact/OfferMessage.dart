import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/DateTimeConversion.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Order/OrderScreen.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class OfferMessage extends StatelessWidget {
  const OfferMessage({Key? key, required this.message, required this.isSender})
      : super(key: key);

  final Message message;
  final bool isSender;
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    Widget showOfferOption(Offer? offer, OfferViewModel model) {
      if (offer!.status == OfferStatus.pending.name) {
        return isSender
            ? Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      color: isSender ? Colors.white : Colors.black,
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(
                      'Pending Now.....',
                      style: TextStyle(
                          color: isSender ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                            onPressed: () async {
                              await model
                                  .updateOfferStatus(OfferStatus.accepted);
                            },
                            child: const Text(
                              "Accept",
                              style: TextStyle(color: Colors.black),
                            ))),
                    Container(
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                            onPressed: () async {
                              await model
                                  .updateOfferStatus(OfferStatus.rejected);
                            },
                            child: const Text("Reject",
                                style: TextStyle(color: Colors.black))))
                  ],
                ),
              );
      } else {
        List<Order> orderList = model.dataMap!['order'];
        User currentUser = model.dataMap!['currentUser'];
        return Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: isSender ? Colors.white : Colors.black,
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(
                    offer.status == OfferStatus.rejected.name
                        ? 'Rejected'
                        : orderList.length > 0
                            ? 'Accepted & Order Placed'
                            : 'Accepted',
                    style: TextStyle(
                        color: isSender ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            offer.status == OfferStatus.accepted.name &&
                    orderList.isEmpty &&
                    !currentUser.itemLink.contains(offer.itemGuid)
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                            onPressed: () async {
                              if (offer.status == OfferStatus.accepted.name) {
                                List<Order> orderList =
                                    await model.validateOrderExist(offer);
                                if (orderList.isNotEmpty) {
                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const CustomDialogBox(
                                            title:
                                                "Order Existed For This Item",
                                            content:
                                                "You are not allowed to place order for this item as there exists order for this item",
                                          ));
                                } else {
                                  model.navigateToOrderScreen(offer);
                                }
                              }
                            },
                            child: const Text(
                              "Tap to place order",
                              style: TextStyle(color: Colors.black),
                            ))),
                  )
                : Center(),
          ],
        );
      }
    }

    return ViewModelBuilder<OfferViewModel>.reactive(
        viewModelBuilder: () => OfferViewModel(chatMessage: message),
        builder: (context, model, child) {
          if (!model.dataReady('offer') || !model.dataReady('currentUser')) {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else {
            Offer offer = model.dataMap!['offer'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: getMediaQueryWidth(context) * 0.6,
                  height: offer.status == OfferStatus.accepted.name
                      ? getMediaQueryHeight(context) * 0.2
                      : getMediaQueryHeight(context) * 0.15,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20 * 0.75, vertical: 20 / 2),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(isSender ? 1 : 0.08),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.messageType == ChatMessageType.buyer_offer.name
                            ? "Buyer's Offer"
                            : "Seller's Offer",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'RM ${offer.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: isSender
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      showOfferOption(offer, model)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    formateTime(convertToDateTime(message.timeSent)),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10),
                  ),
                )
              ],
            );
          }
        });
  }
}
