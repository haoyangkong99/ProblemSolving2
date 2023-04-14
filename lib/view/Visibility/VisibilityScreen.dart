import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/constants/size_config.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Marketplace/SearchBar.dart';
import 'package:utmletgo/view/Visibility/EditVisibilityScreen.dart';
import 'package:utmletgo/view/Visibility/UserCard.dart';
import 'package:utmletgo/viewmodel/VisibilityViewModel.dart';

class VisibilityScreen extends StatefulWidget {
  const VisibilityScreen({super.key});

  @override
  State<VisibilityScreen> createState() => _VisibilityScreenState();
}

class _VisibilityScreenState extends State<VisibilityScreen> {
  List<User> searchResult = [];
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: ViewModelBuilder<VisibilityViewModel>.reactive(
          viewModelBuilder: () => VisibilityViewModel(),
          builder: (context, model, child) {
            if (!model.dataReady('user')) {
              return const Center(
                  child: CircularProgressIndicator(
                color: kPrimaryColor,
              ));
            } else {
              List<User> userList = model.dataMap!['user'] as List<User>;

              return Scaffold(
                  appBar: basicAppBar(
                      height: height,
                      title: const Text(
                        "Visibility",
                        // style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () async {
                            await model.signOut();
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                          child: SearchBar(
                        controller: controller,
                        onChanged: (String value) {
                          if (controller.text.isEmpty) {
                            searchResult.clear();
                            searchResult.addAll(userList);
                          } else {
                            searchResult.clear();

                            searchResult.addAll(userList
                                .where((element) =>
                                    element.name
                                        .toLowerCase()
                                        .contains(value) ||
                                    element.email.toLowerCase().contains(value))
                                .toList());
                            print(searchResult.length);
                          }
                          setState(() {});
                        },
                      )),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchResult.isEmpty
                              ? userList.length
                              : searchResult.length,
                          itemBuilder: ((context, index) => UserCard(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) =>
                                              EditVisibilityScreen(
                                                  userGuid: searchResult.isEmpty
                                                      ? userList[index].guid
                                                      : searchResult[index]
                                                          .guid)));
                                },
                                img: searchResult.isEmpty
                                    ? userList[index].profilePicture
                                    : searchResult[index].profilePicture,
                                name: searchResult.isEmpty
                                    ? userList[index].name
                                    : searchResult[index].name,
                                email: searchResult.isEmpty
                                    ? userList[index].email
                                    : searchResult[index].email,
                              )),
                        ),
                      )
                    ],
                  ));
            }
          }),
    );
  }
}
