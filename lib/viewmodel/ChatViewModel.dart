import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utmletgo/shared/Exception.dart';

class ChatViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  final _chatService = locator<ChatService>();
  final _authService = locator<FirebaseAuthenticationService>();
  Chat chat = Chat();
  User sender = User();
  User receiver = User();
  Item item = Item();

  ChatViewModel() {
    var itemGuid = _dataPassingService.get("item_guid") as String;
    var receiverGuid = _dataPassingService.get('receiver_guid') as String;
    var chatGuid = _dataPassingService.get('chat_guid') as String;
    var listenerItem =
        _itemService.getItemByGuidAsStream(itemGuid).listen((event) {});
    listenerItem.onData((data) {
      item = data;
      notifyListeners();
    });

    var listenerSender = _userService
        .getUserByDocumentIdAsStream(_authService.getUID())
        .listen((event) {});
    listenerSender.onData((data) {
      sender = data;
      notifyListeners();
    });

    var listenerReceiver =
        _userService.getUserByGuidAsStream(receiverGuid).listen((event) {});
    listenerReceiver.onData((data) {
      receiver = data;
      notifyListeners();
    });
    var listenerChat =
        _chatService.getChatByGuidAsStream(chatGuid).listen((event) {});
    listenerChat.onData((data) {
      chat = data;
      notifyListeners();
    });
  }

  Future<void> launchPhone(String phoneNo) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNo,
    );
    await launchUrl(launchUri);
  }

  Future<void> launchWhatsapp(String phoneNo) async {
    final whatsappUrl = 'whatsapp://send?phone=+6$phoneNo';
    Uri launchUri = Uri(path: whatsappUrl);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw GeneralException(
          title: 'WHATSAPP ERROR',
          message: 'Invalid Whatsapp link: \n${whatsappUrl}');
    }
  }

  void addDataToDataPassing(String field, dynamic category) {
    _dataPassingService.addToDataPassingList(field, category);
  }

  dynamic getPassedData(String field) {
    return _dataPassingService.get(field);
  }

  bool checkDataPassingField(String field) {
    return _dataPassingService.checkField(field);
  }

  Future<void> addMessage(String message, ChatMessageType type) async {
    await _chatService.sendMessage(item.guid, receiver.guid, message, type);
  }
}
