import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/ItemCard.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  String selectedPeriod = "";
  String selectedCategory = "";
  String selectedPrice = "";

  List<Item> searchResults = [];

  TextEditingController searchController = TextEditingController();

  late RubberAnimationController _controller;

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        halfBoundValue: AnimationControllerValue(percentage: 0.4),
        upperBoundValue: AnimationControllerValue(percentage: 0.4),
        lowerBoundValue: AnimationControllerValue(pixel: 50),
        duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _expand() {
    _controller.expand();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
          top: true,
          bottom: false,
          child: Scaffold(
              body: ViewModelBuilder<MarketplaceViewModel>.reactive(
            viewModelBuilder: () => MarketplaceViewModel(),
            builder: (context, model, child) {
              if (model.dataReady) {
                return Container(
                  margin: const EdgeInsets.only(top: kToolbarHeight),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            CloseButton()
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: kPrimaryColor, width: 1))),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              List<Item> tempList = [];
                              model.data!.forEach((item) {
                                if (item.title.toLowerCase().contains(value)) {
                                  tempList.add(item);
                                }
                              });
                              setState(() {
                                searchResults.clear();
                                searchResults.addAll(tempList);
                              });
                            } else {
                              setState(() {
                                searchResults.clear();
                                searchResults.addAll(model.data!.map((e) => e));
                              });
                            }
                          },
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 30,
                            ),
                            suffix: TextButton(
                              onPressed: () {
                                searchController.clear();
                                searchResults.clear();
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          color: Colors.orange[50],
                          child: ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (_, index) => ItemCard(
                                    img: searchResults[index].coverImage,
                                    title: searchResults[index].title,
                                    price: searchResults[index].price,
                                    quantity: searchResults[index].quantity,
                                    onTap: () {
                                      model.navigateToItemDetailScreen(
                                          searchResults[index].guid);
                                    },
                                  )),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              }
            },
          ))),
    );
  }
}
