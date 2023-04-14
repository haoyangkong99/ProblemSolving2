import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/view/Authentication/ProfileScreen.dart';
import 'package:utmletgo/view/Contact/InboxScreen.dart';
import 'package:utmletgo/view/Manage/ManageScreen.dart';

import 'package:utmletgo/view/Marketplace/MarketplaceScreen.dart';
import 'package:utmletgo/view/PostItem/PostItemScreen.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _bottomNavIndex = 0;
  late CircularBottomNavigationController _navigationController;
  final iconList = [
    TabItem(Icons.store, "Marketplace", Colors.blue),
    TabItem(Icons.chat, "Inbox", Colors.green),
    TabItem(Icons.add_box_outlined, "Post", kPrimaryColor),
    TabItem(Icons.task, "Manage", Colors.cyan),
    TabItem(Icons.manage_accounts_sharp, "Profile", Colors.red),
  ];
  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(_bottomNavIndex);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: getViewForIndex(_bottomNavIndex),
        bottomNavigationBar: CircularBottomNavigation(
          iconList,
          controller: _navigationController,
          selectedPos: _bottomNavIndex,
          barHeight: 60,
          barBackgroundColor: Colors.white,
          backgroundBoxShadow: <BoxShadow>[
            const BoxShadow(color: Colors.black45, blurRadius: 10.0),
          ],
          animationDuration: const Duration(milliseconds: 300),
          selectedCallback: (value) {
            setState(() {
              _bottomNavIndex = value!;
            });
          },
        ),
      ),
    );
  }

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const MarketplaceScreen();
      case 1:
        return const InboxScreen();
      case 2:
        return const PostItemScreen();
      case 3:
        return const ManageScreen();
      default:
        return const ProfileScreen();
    }
  }
}
