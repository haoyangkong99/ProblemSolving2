import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/Exception.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:sign_button/sign_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState>? _formkey = GlobalKey<FormState>();
  final Validation _validator = Validation();
  bool remember = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  void _handleRemeberme(bool? value) {
    remember = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember", value);
        prefs.setString('email', _email.text);
        prefs.setString('password', _pass.text);
      },
    );
    setState(() {});
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var email = _prefs.getString("email") ?? "";
      var password = _prefs.getString("password") ?? "";
      var remeberMe = _prefs.getBool("remember") ?? false;

      if (remeberMe) {
        setState(() {
          remember = true;
        });
        _email.text = email;
        _pass.text = password;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthenticationViewModel>.nonReactive(
        viewModelBuilder: () => AuthenticationViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Login",
              ),
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kPrimaryColor,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(
                            20, MediaQuery.of(context).size.width)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          header(context),
                          const Text(
                            "Login with your email and password",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.08),
                          formFields(context, model),
                          Btn(
                              text: "Login",
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                              backgroundColor: kPrimaryColor,
                              borderColor: kPrimaryColor,
                              width: getMediaQueryWidth(context) * 0.75,
                              height: getMediaQueryHeight(context) * 0.07,
                              onPressed: () async {
                                bool check = model.validateFields(_formkey);
                                check = true;

                                if (check) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await model
                                      .login(_email.text, _pass.text)
                                      .onError<FirebaseAuthException>((error,
                                              stackTrace) =>
                                          showFirebaseAuthExceptionErrorDialogBox(
                                              context, error))
                                      .onError<GeneralException>((error,
                                              stackTrace) =>
                                          showGeneralExceptionErrorDialogBox(
                                              context, error));

                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              isRound: true),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: const Center(
                              child: Text(
                                'OR',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SignInButton(
                              buttonType: ButtonType.google,
                              onPressed: () {
                                // model.loginWithSocialMedia();
                              }),
                          SignInButton(
                              buttonType: ButtonType.facebook,
                              onPressed: () {}),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t have an account? ",
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(
                                        16, getMediaQueryWidth(context))),
                              ),
                              GestureDetector(
                                onTap: () {
                                  model.navigateToRegister();
                                },
                                child: Text(
                                  "Register now",
                                  style: TextStyle(
                                      fontSize: getProportionateScreenWidth(
                                          16, getMediaQueryWidth(context)),
                                      color: kPrimaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  Form formFields(BuildContext context, AuthenticationViewModel model) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          inputTextFormField(
              controller: _email,
              obscureText: false,
              validator: _validator.validateEmail,
              labelText: "Email",
              hintText: "Enter your email",
              suffixIcon: const Icon(Icons.mail),
              keybordType: TextInputType.emailAddress,
              floatingLabelBehavior: FloatingLabelBehavior.always),
          SizedBox(
              height: getProportionateScreenHeight(
                  30, MediaQuery.of(context).size.height)),
          inputTextFormField(
              controller: _pass,
              obscureText: true,
              validator: _validator.validatePassword,
              labelText: "Password",
              hintText: "Enter your password",
              suffixIcon: const Icon(Icons.lock),
              keybordType: TextInputType.visiblePassword,
              floatingLabelBehavior: FloatingLabelBehavior.always),
          SizedBox(
              height: getProportionateScreenHeight(
                  30, MediaQuery.of(context).size.height)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: _handleRemeberme,
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  model.navigateToResetPassword();
                },
                child: const Text(
                  "Forget Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(
              height: getProportionateScreenHeight(
                  20, MediaQuery.of(context).size.height)),
        ],
      ),
    );
  }

  Text header(BuildContext context) {
    return Text(
      "Welcome Back",
      style: TextStyle(
        color: Colors.black,
        fontSize:
            getProportionateScreenWidth(28, MediaQuery.of(context).size.width),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
