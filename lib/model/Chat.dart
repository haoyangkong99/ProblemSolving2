// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:utmletgo/model/_model.dart';

class Chat {
  String guid = '', itemGuid = '';
  String lastSentMessageDT = DateTime.now().toString();
  List<String> userGuids = [];
  List<Message> messages = [];
  Chat();
  Chat.complete(this.guid, this.itemGuid, this.lastSentMessageDT,
      this.userGuids, this.messages);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guid': guid,
      'itemGuid': itemGuid,
      'lastSentMessageDT': lastSentMessageDT,
      'userGuids': userGuids,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic>? map) {
    List<dynamic> userGuidsJson = map!['userGuids'];
    List<dynamic> messagesJson = map['messages'];
    return Chat.complete(
        map['guid'] as String,
        map['itemGuid'] as String,
        map['lastSentMessageDT'] as String,
        userGuidsJson
            .map(
              (e) => e.toString(),
            )
            .toList(),
        messagesJson.map((e) => Message.fromMap(e)).toList());
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
