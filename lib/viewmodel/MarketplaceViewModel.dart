import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/category_constants.dart';
import 'package:utmletgo/constants/location_options.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:utmletgo/shared/DateTimeConversion.dart';
import 'package:utmletgo/view/Marketplace/FilterScreen.dart';
import 'package:utmletgo/view/Marketplace/ItemDetailsScreen.dart';
import 'package:utmletgo/view/Marketplace/ItemListScreen.dart';

class MarketplaceViewModel extends StreamViewModel<List<Item>> {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  User currentUser = User();
  @override
  Stream<List<Item>> get stream => _itemService.getAllItemsAsStream();
  MarketplaceViewModel() {
    getCurrentUser();
  }
  void getCurrentUser() {
    var listener = _userService.getCurrentUserAsStream().listen((event) {});
    listener.onData((data) {
      currentUser = data;

      notifyListeners();
    });
  }

  Future<void> navigateToItemListScreen() async {
    _navigationService.navigateToView(const ItemListScreen());
  }

  Future<void> navigateToFilterScreen() async {
    _navigationService.navigateToView(const FilterScreen());
  }

  Future<void> navigateToItemDetailScreen(String guid) async {
    _dataPassingService.addToDataPassingList("item_guid", guid);
    _navigationService.navigateToView(ItemDetailsScreen());
  }

  void passDataToNextWidget(String field, dynamic category) {
    _dataPassingService.addToDataPassingList(field, category);
  }

  dynamic getPassedData(String field) {
    return _dataPassingService.get(field);
  }

  bool checkDataPassingField(String field) {
    return _dataPassingService.checkField(field);
  }

  List<Item> getFilteredItems(List<Item> data) {
    var filter = _dataPassingService.get('filter') as Map<String, dynamic>;
    var categoryIndexList = filter['category'] as List<int>;
    var subcategoryList = filter['subcategory'] as List<String>;
    var conditionList = filter['conditions'] as List<String>;
    var sort = filter['sort'] as String;
    var location = filter['location'] as String;
    var priceRangeFrom = filter['priceRangeFrom'] as double;
    var priceRangeTo = filter['priceRangeTo'] as double;
    data = data
        .where((element) => priceRangeTo >= 20000
            ? (element.price >= priceRangeFrom)
            : (element.price >= priceRangeFrom &&
                element.price <= priceRangeTo))
        .toList();

    if (location != locationOptions[0]) {
      data = data.where((element) => element.location == location).toList();
    }

    if (conditionList.isNotEmpty) {
      data = data
          .where((element) => conditionList.any((y) => element.condition == y))
          .toList();
    }

    if (categoryIndexList.isNotEmpty) {
      data = data
          .where((element) => categoryIndexList
              .any((y) => element.category == categoryList[y].name))
          .toList();

      if (subcategoryList.isNotEmpty && subcategoryList[0].isNotEmpty) {
        data = data
            .where((element) =>
                subcategoryList.any((y) => element.subcategory == y))
            .toList();
      }
    }

    switch (sort) {
      case 'Oldest':
        data.sort((a, b) => convertToDateTime(a.postedDT)
            .compareTo(convertToDateTime(b.postedDT)));
        break;
      case 'Price -  High to Low':
        data.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Price -  Low to High':
        data.sort((a, b) => a.price.compareTo(b.price));
        break;
      default:
        data.sort((a, b) => convertToDateTime(b.postedDT)
            .compareTo(convertToDateTime(a.postedDT)));
        break;
    }

    return data;
  }

  void addFilterToDataPassing(
      String sort,
      List<int> category,
      List<String> subcategory,
      String location,
      List<String> conditions,
      double priceRangeFrom,
      double priceRangeTo) {
    Map<String, Object> data = {
      "sort": sort,
      "category": category,
      "subcategory": subcategory,
      "location": location,
      "conditions": conditions,
      "priceRangeFrom": priceRangeFrom,
      "priceRangeTo": priceRangeTo
    };
    _dataPassingService.addToDataPassingList("filter", data);
    _navigationService.popRepeated(2);
    _navigationService.navigateToView(const ItemListScreen(), arguments: data);
  }

  void clearFilter() {
    _dataPassingService.removeField("filter");
  }
}
