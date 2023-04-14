import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/constants/constants.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Authentication/LoginScreen.dart';
import 'package:utmletgo/viewmodel/AuthenticationViewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 4));

    FlutterNativeSplash.remove();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<AuthenticationViewModel>.nonReactive(
        viewModelBuilder: () => AuthenticationViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 243, 238),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/default.png",
                    ),
                  ),
                  Btn(
                      text: "Login",
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 20),
                      backgroundColor: kPrimaryColor,
                      borderColor: kPrimaryColor,
                      width: width * 0.6,
                      height: height * 0.05,
                      onPressed: () {
                        model.navigateToLogin();
                      },
                      isRound: false),
                  const SizedBox(
                    height: 20,
                  ),
                  Btn(
                      text: "Register",
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20),
                      backgroundColor: Colors.white,
                      borderColor: Colors.white,
                      width: width * 0.6,
                      height: height * 0.05,
                      onPressed: () {
                        model.navigateToRegister();
                      },
                      isRound: false)
                ],
              ),
            ),
          );
        });
  }
}
