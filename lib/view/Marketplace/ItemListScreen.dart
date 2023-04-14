import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/ItemCard.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Marketplace/_marketplace.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    return ViewModelBuilder<MarketplaceViewModel>.reactive(
      viewModelBuilder: () => MarketplaceViewModel(),
      builder: (context, model, child) {
        if (model.dataReady) {
          List<Item>? itemList = model.data;
          if (model.checkDataPassingField('filter')) {
            itemList = model.getFilteredItems(itemList!);
          } else {
            itemList = itemList!
                .where((element) =>
                    element.category == model.getPassedData('category'))
                .toList();
          }
          itemList = itemList.where((element) {
            return !model.currentUser.itemLink.contains(element.guid);
          }).toList();
          return Scaffold(
              key: _key,
              appBar: basicAppBar(
                leading: IconButton(
                    onPressed: () {
                      model.clearFilter();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                height: height,
                title: const SearchBar(),
                actions: [
                  IconButton(
                      onPressed: () {
                        model.navigateToFilterScreen();
                      },
                      icon: const Icon(
                        Icons.filter_list_outlined,
                        color: Colors.white,
                      ))
                ],
              ),
              body: showItemList(itemList, model));
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        }
      },
    );
  }

  Widget showItemList(List<Item> data, MarketplaceViewModel model) {
    return data.isEmpty
        ? Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/No matching items.png'))),
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
                      model.navigateToItemDetailScreen(data[index].guid);
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
