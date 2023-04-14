import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/shared/CustomDialogBox.dart';
import 'package:utmletgo/shared/Exception.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';
import 'package:video_player/video_player.dart';

class ChatInputFields extends StatefulWidget {
  const ChatInputFields({super.key});

  @override
  State<ChatInputFields> createState() => _ChatInputFieldsState();
}

class _ChatInputFieldsState extends State<ChatInputFields>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _message = TextEditingController();
  final TextEditingController _offer = TextEditingController();
  XFile? _selectedFile;
  bool _selectedFileIsVideo = false;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ViewModelBuilder<ChatViewModel>.reactive(
        viewModelBuilder: () => ChatViewModel(),
        builder: (context, model, child) {
          Future<void> showSendImageConfirmationDialog() async {
            showDialog(
                context: context,
                builder: (context) => CustomDialogBox(
                      title: 'Are you sure to send this media file?',
                      isOtherContent: true,
                      otherContent: SizedBox(
                          height: height * 0.3,
                          width: width * 0.4,
                          child: Image.file(File(_selectedFile!.path))),
                      isConfirm: true,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await model.addMessage(
                                _selectedFile!.path, ChatMessageType.image);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Send",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          ),
                        )
                      ],
                    ));
          }

          getMedia(
              ImageSource source, ChatViewModel model, bool isVideo) async {
            XFile? image;
            if (isVideo) {
              image = await _picker.pickVideo(source: source);
              _selectedFileIsVideo = true;
            } else {
              image = await _picker.pickImage(source: source);
              _selectedFileIsVideo = false;
            }

            if (image != null) {
              _selectedFile = image;

              showSendImageConfirmationDialog();
            }
          }

          return DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: const TabBar(
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: kPrimaryColor),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: [
                          Tab(text: 'Chat'),
                          Tab(text: 'Make Offer'),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.15,
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: TabBarView(children: <Widget>[
                        Container(
                            child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.grey[200]),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Scrollbar(
                                      child: TextFormField(
                                        maxLines: null,
                                        minLines: 1,
                                        keyboardType: TextInputType.multiline,
                                        // maxLines: 2,
                                        controller: _message,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            hintText: "Type your message here"),
                                      ),
                                    )),
                                    IconButton(
                                      onPressed: () {
                                        getMedia(
                                            ImageSource.gallery, model, false);
                                      },
                                      icon: Icon(
                                        Icons.photo,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        getMedia(
                                            ImageSource.camera, model, false);
                                      },
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    // IconButton(
                                    //   onPressed: () {
                                    //     getMedia(
                                    //         ImageSource.gallery, model, true);
                                    //   },
                                    //   icon: Icon(
                                    //     Icons.video_file,
                                    //     color: Colors.grey[700],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_message.text.isNotEmpty) {
                                  await model
                                      .addMessage(
                                          _message.text, ChatMessageType.text)
                                      .then((value) => _message.clear())
                                      .onError<FirebaseException>((error,
                                              stackTrace) =>
                                          showFirebaseExceptionErrorDialogBox(
                                              context, error));
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPrimaryColor),
                                  child: const Icon(Icons.send,
                                      color: Colors.white)),
                            ),
                          ],
                        )),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.grey[200]),
                                child: TextFormField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  controller: _offer,
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      hintText: "Price"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_offer.text.isNotEmpty) {
                                  bool isSeller = model.receiver.itemLink
                                      .contains(model.item.guid);
                                  await model
                                      .addMessage(
                                          _offer.text,
                                          isSeller
                                              ? ChatMessageType.buyer_offer
                                              : ChatMessageType.seller_offer)
                                      .then((value) => _offer.clear())
                                      .onError<FirebaseException>((error,
                                              stackTrace) =>
                                          showFirebaseExceptionErrorDialogBox(
                                              context, error));
                                }
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.resolveWith(
                                      (states) => 2),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => kPrimaryColor),
                                  padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 30),
                                  ),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                            )
                          ],
                        )),
                      ]),
                    )
                  ]));
        });
  }
}
