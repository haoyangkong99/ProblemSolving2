import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/ItemCard.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Marketplace/_marketplace.dart';
import 'package:utmletgo/viewmodel/ManageItemListingViewModel.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class ManageItemListingScreen extends StatefulWidget {
  const ManageItemListingScreen({super.key});

  @override
  State<ManageItemListingScreen> createState() =>
      _ManageItemListingScreenState();
}

class _ManageItemListingScreenState extends State<ManageItemListingScreen> {
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: basicAppBar(
            automaticallyImplyLeading: true,
            height: height,
            title: const Text(
              "Manage Item Listing",
            ),
            bottom: const TabBar(
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                tabs: [
                  Tab(
                    child: Text(
                      "In Progress",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                      child: Text(
                    "Completed",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  Tab(
                      child: Text(
                    "Out Of Delivery",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ))
                ]),
          ),
          body: ViewModelBuilder<ManageItemListingViewModel>.reactive(
            viewModelBuilder: () => ManageItemListingViewModel(),
            builder: (context, model, child) {
              if (model.dataReady('user') && model.dataReady('item')) {
                User currentUser = model.dataMap!['user'] as User;
                List<Item> itemList = model.dataMap!['item'];
                itemList = itemList
                    .where((element) =>
                        currentUser.itemLink.contains(element.guid))
                    .toList();

                return TabBarView(
                  children: [
                    showItemList(
                        itemList
                            .where((element) =>
                                element.status == ItemStatus.in_progress.name)
                            .toList(),
                        model),
                    showItemList(
                        itemList
                            .where((element) =>
                                element.status == ItemStatus.completed.name)
                            .toList(),
                        model),
                    showItemList(
                        itemList
                            .where((element) =>
                                element.status ==
                                ItemStatus.out_for_delivery.name)
                            .toList(),
                        model),
                  ],
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ));
              }
            },
          )),
    );
  }

  Widget showItemList(List<Item>? data, ManageItemListingViewModel model) {
    return data!.isEmpty
        ? Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/No item posted.png'))),
          )
        : ListView(
            children: <Widget>[
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemCard(
                    onTap: () {
                      model.navigateToMyItemScreen(data[index].guid);
                    },
                    img: data[index].coverImage,
                    title: data[index].title,
                    price: data[index].price,
                    quantity: data[index].quantity,
                  );
                },
              ),
            ],
          );
  }
}
