import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/viewmodel/ProfileViewModel.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Validation _validator = Validation();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _contact = TextEditingController();
  bool isLoading = false, initial = true;
  String? status;
  XFile? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      _selectedFile = image;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, child) {
          User? user = model.dataMap!['user'] as User;
          if (model.dataReady('user') && initial) {
            _contact.text = user.contact;
            status = user.status;
            initial = false;
          }

          ImageProvider showImage() {
            if (_selectedFile == null) {
              if (user.profilePicture.isNotEmpty) {
                return NetworkImage(user.profilePicture);
              }

              return AssetImage(user.gender == Gender.Male.name
                  ? "assets/images/man profile icon.png"
                  : "assets/images/lady profile icon.png");
            } else {
              return FileImage(File(_selectedFile!.path));
            }
          }

          return Scaffold(
            appBar: basicAppBar(
              automaticallyImplyLeading: true,
              height: getMediaQueryHeight(context),
              title: const Text("Edit Profile"),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedFile = null;
                        _contact.clear();
                      });
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            body: !model.dataReady('user') || isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: getProportionateScreenWidth(
                            20, MediaQuery.of(context).size.width)),
                    child: Form(
                      key: _formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(children: [
                              Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 10), //10
                                  height: 170, //140
                                  width: 170,
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
                                      fit: BoxFit.cover,
                                      image: showImage(),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: width * 0.30,
                                child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                                height: 80,
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              getImage(
                                                                  ImageSource
                                                                      .camera);
                                                            },
                                                            icon: const Icon(
                                                              Icons.camera_alt,
                                                            )),
                                                        const Text(
                                                            'Choose From Camera')
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              getImage(
                                                                  ImageSource
                                                                      .gallery);

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .file_copy)),
                                                        const Text(
                                                            'Choose From Gallery')
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: kPrimaryColor,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )),
                              )
                            ]),
                            detailExpansionTile(user),
                            const SizedBox(
                              height: 20,
                            ),
                            inputTextFormField(
                                controller: _contact,
                                obscureText: false,
                                // onSaved: () {},
                                // onChanged: () {},
                                validator: _validator.validateContact,
                                labelText:
                                    "Contact (Start with 0xx- & follow with 6 to 8 digits)",
                                hintText: "Enter your contact number",
                                suffixIcon: const Icon(Icons.call),
                                keybordType: TextInputType.phone,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                            const SizedBox(
                              height: 20,
                            ),
                            statusDropDown(
                                validator: (value) =>
                                    value == null ? 'field required' : null,
                                value: status,
                                onChanged: (value) {
                                  setState(() {
                                    status = value;
                                  });
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: Btn(
                                  text: "Save",
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  backgroundColor: kPrimaryColor,
                                  borderColor: kPrimaryColor,
                                  width: getMediaQueryWidth(context) * 0.75,
                                  height: getMediaQueryHeight(context) * 0.07,
                                  onPressed: () async {
                                    bool validate =
                                        _formkey.currentState!.validate();

                                    if (validate && status!.isNotEmpty) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await model
                                          .updateUser(_contact.text,
                                              _selectedFile, status!, user)
                                          .whenComplete(() =>
                                              showCompleteUpdateDialogBox(
                                                  context))
                                          .onError<FirebaseException>((error,
                                                  stackTrace) =>
                                              showFirebaseExceptionErrorDialogBox(
                                                  context, error));
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      if (status!.isEmpty) {
                                        validateFields(context);
                                      }
                                    }
                                  },
                                  isRound: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }

  Future<dynamic> validateFields(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => const CustomDialogBox(
              title: "Incomplete Fields",
              content: "Please makesure the student's status field is selected",
            ));
  }

  ExpansionTile detailExpansionTile(User? data) {
    return ExpansionTile(
      childrenPadding: const EdgeInsets.all(15),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: const Text("Account Info"),
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            Text("Name: ${data!.name}"),
            Text("Email: ${data.email}"),
            Text("Gender: ${data.gender}")
          ],
        )
      ],
    );
  }
}
