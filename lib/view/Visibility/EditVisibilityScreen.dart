import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/VisibilityViewModel.dart';

class EditVisibilityScreen extends StatefulWidget {
  final String userGuid;
  const EditVisibilityScreen({super.key, required this.userGuid});

  @override
  State<EditVisibilityScreen> createState() => _EditVisibilityScreenState();
}

class _EditVisibilityScreenState extends State<EditVisibilityScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    double width = getMediaQueryWidth(context);
    return ViewModelBuilder<VisibilityViewModel>.reactive(
        viewModelBuilder: () => VisibilityViewModel(userGuid: widget.userGuid),
        builder: (context, model, child) {
          if (model.dataReady('user')) {
            List<Item>? itemList = model.itemList;
            List<User> userList = model.dataMap!['user'];
            User user = userList
                .where((element) => element.guid == widget.userGuid)
                .first;
            return Scaffold(
              appBar: basicAppBar(
                  automaticallyImplyLeading: true,
                  height: height,
                  title: const Text(
                    "Edit Visibility",
                    // style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await model
                              .setUserVisibility(
                                  user.visibility == VisibilityType.allow.name)
                              .then((value) {
                                itemList!.forEach((element) async {
                                  await model.setItemVisibility(
                                      element.visibility ==
                                          VisibilityType.allow.name,
                                      element.guid);
                                });
                              })
                              .then((value) async {
                                await Future.delayed(Duration(seconds: 1));
                                setState(() {
                                  isLoading = false;
                                });
                              })
                              .then((value) =>
                                  showCompleteUpdateDialogBox(context))
                              .onError<FirebaseException>((error, stackTrace) =>
                                  showFirebaseExceptionErrorDialogBox(
                                      context, error));
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        )),
                  ]),
              body: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ))
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: width * 0.01),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: width * 0.15,
                              backgroundImage:
                                  NetworkImage(user.profilePicture),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: const EdgeInsets.all(15),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            title: const Text(
                              "Account Info",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            children: [
                              ListView(
                                shrinkWrap: true,
                                children: [
                                  Text("Guid: ${user.guid}"),
                                  Text("Name: ${user.name}"),
                                  Text("Email: ${user.email}"),
                                  Text("Gender: ${user.gender}"),
                                  Text("Status: ${user.status}"),
                                  Text("Campus: ${user.campus}")
                                ],
                              )
                            ],
                          ),
                          ListTile(
                            leading: Text(
                              'Visibility: ',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            title: Switch(
                              // thumb color (round icon)
                              activeColor: Colors.white,
                              activeTrackColor: Colors.teal,
                              inactiveThumbColor: Colors.blueGrey.shade600,
                              inactiveTrackColor: Colors.grey.shade400,
                              splashRadius: 100,
                              // boolean variable value
                              value:
                                  user.visibility == VisibilityType.allow.name,
                              // changes the state of the switch
                              onChanged: (value) async {
                                user.visibility = value
                                    ? VisibilityType.allow.name
                                    : VisibilityType.disallow.name;
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                'Item Listing',
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Expanded(
                            child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // number of columns
                                  mainAxisSpacing: 10, // space between rows
                                  crossAxisSpacing: 10, // space between columns
                                  childAspectRatio:
                                      0.75, // width / height ratio of each item
                                ),
                                itemCount: itemList!.length,
                                itemBuilder: (context, index) => Card(
                                    color: Colors.grey[200],
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Container(
                                          height: height * 0.2,
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      itemList[index]
                                                          .coverImage),
                                                  fit: BoxFit.contain)),
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        Center(
                                            child: Text(
                                          model.itemList![index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        )),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Visibility: ',
                                                style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              Switch(
                                                // thumb color (round icon)
                                                activeColor: Colors.white,
                                                activeTrackColor: Colors.teal,
                                                inactiveThumbColor:
                                                    Colors.blueGrey.shade600,
                                                inactiveTrackColor:
                                                    Colors.grey.shade400,
                                                splashRadius: 100,
                                                // boolean variable value
                                                value: itemList[index]
                                                        .visibility ==
                                                    VisibilityType.allow.name,
                                                // changes the state of the switch
                                                onChanged: (value) async {
                                                  itemList[index].visibility =
                                                      value
                                                          ? VisibilityType
                                                              .allow.name
                                                          : VisibilityType
                                                              .disallow.name;
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ))),
                          )
                        ],
                      ),
                    ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          }
        });
  }
}
