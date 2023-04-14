import 'package:flutter/material.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/view/Contact/OfferMessage.dart';
import 'package:utmletgo/view/Contact/_contact.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key,
      required this.message,
      required this.isSender,
      required this.receiver})
      : super(key: key);

  final Message message;
  final User receiver;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(Message message) {
      switch (ChatMessageType.values
          .where((element) => element.name == message.messageType)
          .elementAt(0)) {
        case ChatMessageType.text:
          return TextMessage(
            message: message,
            isSender: isSender,
          );

        case ChatMessageType.image:
          return ImageMessage(
            message: message,
          );
        // case ChatMessageType.video:
        //   return VideoMessage(
        //     message: message,

        //   );
        case ChatMessageType.buyer_offer:
          return OfferMessage(message: message, isSender: isSender);

        case ChatMessageType.seller_offer:
          return OfferMessage(message: message, isSender: isSender);

        default:
          return const SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(receiver.profilePicture),
            ),
            const SizedBox(
              width: 20 / 2,
            )
          ],
          messageContaint(message),
        ],
      ),
    );
  }
}
