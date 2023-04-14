import 'dart:io';

import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/OfferService.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  FirebaseDbService dbService = FirebaseDbService();
  FirebaseAuthenticationService authService = FirebaseAuthenticationService();
  String collectionPath = "chat";
  UserService userService = UserService();
  FirebaseStorageService storageService = FirebaseStorageService();
  OfferService offerService = OfferService();
  Future<Chat> getChatAndCreateIfNotExist(
      String itemGuid, String receiverGuid) async {
    var sender = await userService.getUserByDocumentId(authService.getUID());
    var receiver = await userService.getUserByGuid(receiverGuid);
    var result = await getChatWithCondition((chat) => chat.itemGuid == itemGuid)
        .then((value) => value.where((element) =>
            element.userGuids.contains(sender.guid) &&
            element.userGuids.contains(receiver.guid)));
    if (result.length > 1) {
      throw Exception("There is duplicated chats");
    } else if (result.length == 1) {
      return result.elementAt(0);
    } else {
      var chatGuid = const Uuid().v4();
      Chat chat = Chat.complete(chatGuid, itemGuid, DateTime.now().toString(),
          [sender.guid, receiver.guid], List.empty());
      await dbService.addDocumentWithRandomDocId(collectionPath, chat.toMap());
      return chat;
    }
  }

  Future<Chat> findMatchingChat(
      String itemGuid, String senderGuid, String receiverGuid) async {
    return getChatWithCondition((chat) => chat.itemGuid == itemGuid).then(
        (value) => value
            .where((element) =>
                element.userGuids.contains(senderGuid) &&
                element.userGuids.contains(receiverGuid))
            .elementAt(0));
  }

  Future<void> sendMessage(String itemGuid, String receiverGuid,
      String messageContent, ChatMessageType messageType) async {
    var sender = await userService.getUserByDocumentId(authService.getUID());
    var receiver = await userService.getUserByGuid(receiverGuid);

    var messageGuid = const Uuid().v4();
    DateTime lastSentDT = DateTime.now();
    switch (messageType) {
      case ChatMessageType.image:
        messageContent =
            await storageService.uploadImageToStorage(File(messageContent));
        break;

      case ChatMessageType.buyer_offer:
        messageContent = await offerService.addOffer(
            ChatMessageType.buyer_offer,
            double.parse(messageContent),
            itemGuid);
        break;
      case ChatMessageType.seller_offer:
        messageContent = await offerService.addOffer(
            ChatMessageType.seller_offer,
            double.parse(messageContent),
            itemGuid);
        break;
      default:
        break;
    }
    Message message = Message.complete(messageGuid, messageContent,
        messageType.name, sender.guid, lastSentDT.toString());
    Chat chat = await findMatchingChat(itemGuid, sender.guid, receiverGuid);
    chat.lastSentMessageDT = lastSentDT.toString();
    chat.messages.add(message);
    await updateChatByGuid(chat, chat.guid);
  }

  Future<bool> updateChatByDocumentId(Chat chat, String documentId) async {
    return await dbService.updateDocumentByDocumentId(
        collectionPath, documentId, chat.toMap());
  }

  Future<bool> updateChatByGuid(Chat chat, String guid) async {
    return await dbService.updateDocumentByGuid(
        collectionPath, guid, chat.toMap());
  }

  Future<bool> deleteChatByDocumentId(String documentId) async {
    return await dbService.deleteDocument(collectionPath, documentId);
  }

  Future<bool> deleteChatByGuid(String guid) async {
    return await dbService.deleteDocumentByGuid(collectionPath, guid);
  }

  Future<List<Chat>> getAllChats() {
    return dbService.readAllDocument(collectionPath).then((value) =>
        value.docs.map((chat) => Chat.fromMap(chat.data())).toList());
  }

  Future<Chat> getChatByDocumentId(String documentId) {
    return dbService
        .readByDocumentId(collectionPath, documentId)
        .then((value) => Chat.fromMap(value.data()));
  }

  Future<List<Chat>> getChatByGuid(String guid) {
    return dbService.readByGuid(collectionPath, guid).then((value) =>
        value.docs.map((chat) => Chat.fromMap(chat.data())).toList());
  }

  Future<List<Chat>> getChatWithCondition(bool Function(Chat) condition) {
    return dbService.readAllDocument(collectionPath).then((value) => value.docs
        .map((e) => Chat.fromMap(e.data()))
        .where(condition)
        .toList());
  }

  Stream<List<Chat>> getAllChatsAsStream() {
    return dbService
        .readAllDocumentAsStream(collectionPath)
        .map((event) => event.docs.map((e) => Chat.fromMap(e.data())).toList());
  }

  Stream<Chat> getChatByDocumentIdAsStream(String documentId) {
    return dbService
        .readByDocumentIdAsStream(collectionPath, documentId)
        .map((event) => Chat.fromMap(event.data()));
  }

  Stream<Chat> getChatByGuidAsStream(String guid) {
    return dbService.readByGuidAsStream(collectionPath, guid).map(
        (event) => event.docs.map((e) => Chat.fromMap(e.data())).elementAt(0));
  }

  Stream<List<Chat>> getChatsWithConditionAsStream(
      bool Function(Chat) condition) {
    return dbService.readAllDocumentAsStream(collectionPath).map((event) =>
        event.docs
            .map((e) => Chat.fromMap(e.data()))
            .where(condition)
            .toList());
  }
}
