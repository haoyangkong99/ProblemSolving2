import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/ChatService.dart';
import 'package:utmletgo/services/DataPassingService.dart';
import 'package:utmletgo/services/FirebaseStorageService.dart';
import 'package:utmletgo/services/ItemService.dart';
import 'package:utmletgo/services/ReviewsService.dart';
import 'package:utmletgo/services/UserService.dart';
import 'package:utmletgo/view/Contact/ChatScreen.dart';
import 'package:utmletgo/view/Marketplace/FilterScreen.dart';

class ItemViewModel extends MultipleStreamViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _itemService = locator<ItemService>();
  final _storageService = locator<FirebaseStorageService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  final _chatService = locator<ChatService>();
  final _reviewService = locator<ReviewsService>();

  @override
  Map<String, StreamData> get streamsMap => {
        'item': StreamData<Item>(getItem()),
        'user': StreamData<List<User>>(getUser()),
      };
  void navigateToFilterScreen() {
    _navigationService.navigateToView(FilterScreen());
  }

  Stream<Item> getItem() {
    var itemGuid = _dataPassingService.get('item_guid') as String;
    return _itemService.getItemByGuidAsStream(itemGuid);
  }

  Stream<List<User>> getUser() {
    var itemGuid = _dataPassingService.get('item_guid') as String;
    return _userService.getUserWithConditionAsStream(
        (user) => user.itemLink.any((element) => element == itemGuid));
  }

  Future<void> createItem(
      XFile? coverImage,
      String? category,
      String? subcategory,
      String? condition,
      String title,
      String description,
      String location,
      List<XFile?> images,
      List<String>? paymentMethods,
      double price,
      int quantity) async {
    String coverImageUrl = await _storageService
        .uploadImageToStorage(_storageService.convertXFileToFile(coverImage));

    List<String> otherImageUrls =
        await _storageService.uploadMultipleImagesToStorage(
            _storageService.convertXFilesToFile(images));
    print(otherImageUrls);
    String postedDT = DateTime.now().toString();
    await _itemService.addItem(
        coverImageUrl,
        category!,
        subcategory!,
        condition!,
        title,
        description,
        location,
        ItemStatus.in_progress.name,
        postedDT,
        VisibilityType.allow.name,
        otherImageUrls,
        paymentMethods!,
        price,
        quantity);
    await _dialogService
        .showDialog(
            title: 'Successfully Posted',
            description: 'The new item has been posted successfully.',
            buttonTitleColor: kPrimaryColor)
        .then((value) =>
            _navigationService.pushNamedAndRemoveUntil(Routes.mainScreen));
  }

  Future<void> updateItem(
      Item item,
      XFile? coverImage,
      String? category,
      String? subcategory,
      String? condition,
      String title,
      String description,
      String location,
      List<XFile?> images,
      List<String>? paymentMethods,
      double price,
      int quantity) async {
    String coverImageUrl = await _storageService
        .uploadImageToStorage(_storageService.convertXFileToFile(coverImage));

    List<String> otherImageUrls =
        await _storageService.uploadMultipleImagesToStorage(
            _storageService.convertXFilesToFile(images));
    String postedDT = DateTime.now().toString();
    await _itemService.addItem(
        coverImageUrl,
        category!,
        subcategory!,
        condition!,
        title,
        description,
        location,
        ItemStatus.in_progress.name,
        postedDT,
        VisibilityType.allow.name,
        otherImageUrls,
        paymentMethods!,
        price,
        quantity);
  }

  bool validateFields(GlobalKey<FormState>? key) {
    return key!.currentState!.validate();
  }

  Future<void> navigateToChatScreen(
      String itemGuid, String receiverGuid) async {
    Chat result =
        await _chatService.getChatAndCreateIfNotExist(itemGuid, receiverGuid);
    _dataPassingService.addToDataPassingList("receiver_guid", receiverGuid);
    _dataPassingService.addToDataPassingList("chat_guid", result.guid);
    _navigationService.navigateToView(ChatScreen());
  }

  Future<void> makeOffer(
      String itemGuid, String receiverGuid, String message) async {
    Chat result =
        await _chatService.getChatAndCreateIfNotExist(itemGuid, receiverGuid);
    _dataPassingService.addToDataPassingList("receiver_guid", receiverGuid);
    _dataPassingService.addToDataPassingList("chat_guid", result.guid);
    _chatService.sendMessage(
        itemGuid, receiverGuid, message, ChatMessageType.buyer_offer);
    _navigationService.navigateToView(ChatScreen());
  }
}
