import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  final bool isEmailSignUp;
  RegisterScreen({Key? key, this.isEmailSignUp = true}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Validation _validator = Validation();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _contact = TextEditingController();

  int? page;

  String? gender, campus, status;
  bool isLoading = false;
  @override
  void initState() {
    page = widget.isEmailSignUp ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ViewModelBuilder<AuthenticationViewModel>.nonReactive(
        viewModelBuilder: () => AuthenticationViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Registration",
              ),
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(
                            20, MediaQuery.of(context).size.width)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          Text(
                            "Register Account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(
                                  28, MediaQuery.of(context).size.width),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Text(
                            "Complete your details\nPage ${page.toString()}/2 (${page == 1 ? 'Credentials' : 'Personal Info'})",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FormFields(context),
                          SizedBox(
                              height: getProportionateScreenHeight(
                                  20, MediaQuery.of(context).size.height)),
                          page == 1
                              ? nextPageButton(width, height, model)
                              : completeButton(width, height, model),
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

  Widget completeButton(
      double width, double height, AuthenticationViewModel model) {
    return Btn(
        text: "Complete",
        textStyle: const TextStyle(color: Colors.white, fontSize: 20),
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
            await model
                .registerWithEmailPassword(
                  _email.text,
                  _pass.text,
                  _confirm.text,
                  _name.text,
                  gender!,
                  status!,
                  campus!,
                  _contact.text,
                )
                .whenComplete(() => showCompleteRegistrationDialogBox(context))
                .onError<FirebaseException>((error, stackTrace) =>
                    showFirebaseExceptionErrorDialogBox(context, error));
            setState(() {
              isLoading = false;
            });
          }
        },
        isRound: true);
  }

  Widget nextPageButton(
      double width, double height, AuthenticationViewModel model) {
    return Btn(
        text: "Next Page",
        textStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: kPrimaryColor,
        borderColor: kPrimaryColor,
        width: width * 0.75,
        height: height * 0.07,
        onPressed: () {
          if (model.validateFields(_formkey)) {
            setState(() {
              page = 2;
            });
          } else {}
        },
        isRound: true);
  }

  Form FormFields(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          page == 1
              ? inputTextFormField(
                  controller: _email,
                  obscureText: false,
                  // onSaved: () {},
                  // onChanged: () {},
                  validator: _validator.validateEmail,
                  labelText: "Email",
                  hintText: "Enter your email",
                  suffixIcon: const Icon(Icons.mail),
                  keybordType: TextInputType.emailAddress,
                  floatingLabelBehavior: FloatingLabelBehavior.always)
              : inputTextFormField(
                  controller: _name,
                  obscureText: false,
                  // onSaved: () {},
                  // onChanged: () {},
                  validator: _validator.validateEmpty,
                  labelText: "Name",
                  hintText: "Enter your name",
                  suffixIcon: const Icon(Icons.person),
                  keybordType: TextInputType.name,
                  floatingLabelBehavior: FloatingLabelBehavior.always),
          SizedBox(
              height: getProportionateScreenHeight(
                  30, MediaQuery.of(context).size.height)),
          page == 1
              ? inputTextFormField(
                  controller: _pass,
                  obscureText: true,
                  // onSaved: () {},
                  // onChanged: () {},
                  validator: _validator.validatePassword,
                  labelText: "Password",
                  hintText: "Enter your password",
                  suffixIcon: const Icon(Icons.lock),
                  keybordType: TextInputType.visiblePassword,
                  floatingLabelBehavior: FloatingLabelBehavior.always)
              : genderDropDown(
                  validator: (value) => value == null ? 'field required' : null,
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  }),
          SizedBox(
              height: getProportionateScreenHeight(
                  30, MediaQuery.of(context).size.height)),
          page == 1
              ? inputTextFormField(
                  controller: _confirm,
                  obscureText: true,
                  // onSaved: () {},
                  // onChanged: () {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The confirm password cannot be empty";
                    }
                    if (value.length < 6 || value.length > 20) {
                      return 'At least 6 characters and not more than 20 characters';
                    }
                    if (value != _pass.text) {
                      return "Please makesure that the confirm password matches with the password entered";
                    }
                  },
                  labelText: "Confirm Password",
                  hintText: "Retype your password",
                  suffixIcon: const Icon(Icons.lock),
                  keybordType: TextInputType.visiblePassword,
                  floatingLabelBehavior: FloatingLabelBehavior.always)
              : statusDropDown(
                  validator: (value) => value == null ? 'field required' : null,
                  value: status,
                  onChanged: (value) {
                    setState(() {
                      status = value;
                    });
                  }),
          SizedBox(
              height: getProportionateScreenHeight(
                  20, MediaQuery.of(context).size.height)),
          page == 1
              ? const Center()
              : Column(
                  children: [
                    campusDropDown(
                        validator: (value) =>
                            value == null ? 'field required' : null,
                        value: campus,
                        onChanged: (value) {
                          setState(() {
                            campus = value;
                          });
                        }),
                    SizedBox(
                        height: getProportionateScreenHeight(
                            20, MediaQuery.of(context).size.height)),
                    inputTextFormField(
                        controller: _contact,
                        obscureText: false,
                        validator: _validator.validateContact,
                        labelText:
                            "Contact (Start with 0xx- & follow with 6 to 8 digits)",
                        hintText: "Enter your contact number",
                        suffixIcon: const Icon(Icons.call),
                        keybordType: TextInputType.phone,
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    SizedBox(
                        height: getProportionateScreenHeight(
                            20, MediaQuery.of(context).size.height)),
                  ],
                )
        ],
      ),
    );
  }
}
