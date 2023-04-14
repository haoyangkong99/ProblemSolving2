import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Contact/ConversationCard.dart';
import 'package:utmletgo/viewmodel/InboxViewModel.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InboxViewModel>.reactive(
        viewModelBuilder: () => InboxViewModel(),
        builder: (context, model, child) {
          List<Chat> buyingList = model.chatList
              .where(
                  (chat) => !model.currentUser.itemLink.contains(chat.itemGuid))
              .toList();
          List<Chat> sellingList = model.chatList
              .where(
                  (chat) => model.currentUser.itemLink.contains(chat.itemGuid))
              .toList();
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: basicAppBar(
                height: getMediaQueryHeight(context),
                title: const Text(
                  "Inbox",
                  // style: TextStyle(color: Colors.white),
                ),
                bottom: const TabBar(
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.white,
                    indicatorWeight: 4,
                    tabs: [
                      Tab(
                        child: Text(
                          "Buying",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Tab(
                          child: Text(
                        "Selling",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ))
                    ]),
              ),
              body: TabBarView(children: [
                buyingList.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/No conversation icon seller.png'))),
                      )
                    : ListView.builder(
                        itemCount: buyingList.length,
                        itemBuilder: (context, index) {
                          Item item = model.itemList
                              .where((element) =>
                                  element.guid == buyingList[index].itemGuid)
                              .first;
                          User seller = model.userList
                              .where((element) => element.itemLink
                                  .contains(buyingList[index].itemGuid))
                              .first;
                          return ConversationCard(
                              img: item.coverImage,
                              name: seller.name,
                              title: item.title,
                              ontap: () {
                                model.navigateToChatScreen(
                                    buyingList[index].guid,
                                    seller.guid,
                                    item.guid);
                              });
                        }),
                sellingList.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/No conversation icon buyer.png'))),
                      )
                    : ListView.builder(
                        itemCount: sellingList.length,
                        itemBuilder: (context, index) {
                          Item item = model.itemList
                              .where((element) =>
                                  element.guid == sellingList[index].itemGuid)
                              .elementAt(0);
                          User buyer = model.userList
                              .where((element) => !element.itemLink
                                  .contains(sellingList[index].itemGuid))
                              .elementAt(0);
                          return ConversationCard(
                              img: item.coverImage,
                              name: buyer.name,
                              title: item.title,
                              ontap: () {
                                model.navigateToChatScreen(
                                    sellingList[index].guid,
                                    buyer.guid,
                                    item.guid);
                              });
                        }),
              ]),
            ),
          );
        });
  }
}
