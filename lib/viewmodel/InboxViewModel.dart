import 'dart:math';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:utmletgo/view/Contact/ChatScreen.dart';

class InboxViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  final _chatService = locator<ChatService>();
  List<Chat> chatList = [];
  List<Item> itemList = [];
  List<User> userList = [];
  User currentUser = User();
  InboxViewModel() {
    getChatList();
  }
  Future<void> getChatList() async {
    currentUser = await _userService.getCurrentUser();
    var listenerChat = _chatService
        .getChatsWithConditionAsStream(
            (chat) => chat.userGuids.contains(currentUser.guid))
        .listen((event) {});
    listenerChat.onData((chat) async {
      List<String> involvedItemGuids = chat.map((e) => e.itemGuid).toList();
      Set<String> involvedUserGuids = Set();

      chat.forEach((element) {
        involvedUserGuids.addAll(element.userGuids);
      });

      var listenerItem = _itemService
          .getItemWithConditionAsStream(
              (item) => involvedItemGuids.contains(item.guid))
          .listen((event) {});
      listenerItem.onData(
        (item) {
          itemList = item;
          notifyListeners();
        },
      );
      var listenerUser = _userService
          .getUserWithConditionAsStream(
              (user) => involvedUserGuids.contains(user.guid))
          .listen((event) {});
      listenerUser.onData((user) {
        userList = user;
        notifyListeners();
      });
      chatList = chat;

      notifyListeners();
    });
  }

  void navigateToChatScreen(
      String chatGuid, String receiverGuid, String itemGuid) {
    _dataPassingService.addToDataPassingList('item_guid', itemGuid);
    _dataPassingService.addToDataPassingList('chat_guid', chatGuid);
    _dataPassingService.addToDataPassingList('receiver_guid', receiverGuid);
    _navigationService.navigateToView(ChatScreen());
  }
}
