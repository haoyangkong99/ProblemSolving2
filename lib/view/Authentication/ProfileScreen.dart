import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/constants/size_config.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/MenuOptions.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/ProfileViewModel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: basicAppBar(
        height: getMediaQueryHeight(context),
        title: const Text("Profile"),
      ),
      body: ViewModelBuilder<ProfileViewModel>.reactive(
          viewModelBuilder: () => ProfileViewModel(),
          builder: (context, model, child) {
            User user = model.dataMap!['user'] as User;
            return !model.dataReady('user')
                ? const Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        profileSumary(user),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: kPrimaryColor,
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                      offset: Offset(0, 1))
                                ]),
                            height: getMediaQueryHeight(context) * 0.17,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: kPrimaryColor,
                                        ),
                                        onPressed: () =>
                                            {model.navigateToEditProfile()},
                                      ),
                                      const Text(
                                        'Profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.credit_card,
                                            color: kPrimaryColor),
                                        onPressed: () =>
                                            {model.navigateToPayment()},
                                      ),
                                      const Text(
                                        'Payment',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.home,
                                            color: kPrimaryColor),
                                        onPressed: () {
                                          model.navigateToAddress();
                                        },
                                      ),
                                      const Text(
                                        'Address',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        MenuOptions(
                            onPressed: () {},
                            icon: const Icon(Icons.reviews),
                            text: "Reviews"),
                        MenuOptions(
                            onPressed: () {
                              model.signOut();
                            },
                            icon: const Icon(Icons.logout),
                            text: "Log Out")
                      ],
                    ));
          }),
    );
  }

  Center profileSumary(User? data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10), //10
            height: 140, //140
            width: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 5, //8
              ),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 10))
              ],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: showProfileImage(data!),
              ),
            ),
          ),
          Text(
            data.name,
            style: const TextStyle(
              fontSize: 22, // 22
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5), //5
          Text(
            data.email,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF8492A2),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                data.reviewsLink.averageRating.toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }

  ImageProvider showProfileImage(User data) {
    if (data.profilePicture.isNotEmpty) {
      return NetworkImage(data.profilePicture);
    } else {
      return AssetImage(data.gender == Gender.Male.name
          ? "assets/images/man profile icon.png"
          : "assets/images/lady profile icon.png");
    }
  }
}
