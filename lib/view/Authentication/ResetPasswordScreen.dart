import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final Validation _validator = Validation();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isLoading = false;
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ViewModelBuilder<AuthenticationViewModel>.nonReactive(
        viewModelBuilder: () => AuthenticationViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Forget Password",
              ),
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(
                            20, MediaQuery.of(context).size.width)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(
                                  28, MediaQuery.of(context).size.width),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Reset password with email address",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.08),
                          Form(
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
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                                SizedBox(
                                    height: getProportionateScreenHeight(20,
                                        MediaQuery.of(context).size.height)),
                              ],
                            ),
                          ),
                          Btn(
                              text: "Reset",
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                              backgroundColor: kPrimaryColor,
                              borderColor: kPrimaryColor,
                              width: width * 0.75,
                              height: height * 0.07,
                              onPressed: () async {
                                bool check = model.validateFields(_formkey);

                                if (check) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Future.delayed(Duration(seconds: 4));
                                  await model
                                      .resetPassword(_email.text)
                                      .whenComplete(() async {
                                    await showCompleteResetPassowrdDialogBox(
                                        context);
                                    model.navigateToLogin();
                                  }).onError<FirebaseAuthException>((error,
                                              stackTrace) =>
                                          showFirebaseAuthExceptionErrorDialogBox(
                                              context, error));
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                              },
                              isRound: true),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.08),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
