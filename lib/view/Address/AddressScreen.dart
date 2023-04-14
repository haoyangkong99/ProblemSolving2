import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/constants/size_config.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/StateDropDownButton.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Address/AddressCard.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _addressLine1 = TextEditingController();
  final TextEditingController _addressLine2 = TextEditingController();
  final TextEditingController _postcode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Validation _validator = Validation();
  final SwiperController _swiper = SwiperController();
  String state = locationOptionsWithoutWholeMalaysia[0];
  String addressType = AddressType.home.name;
  List<AddressCard> cards = [];
  bool initial = true, isLoading = false;
  int currentIndex = 0;
  AddressType getAddressType(String? type) {
    if (AddressType.home.name == type) {
      return AddressType.home;
    } else if (AddressType.workplace.name == type) {
      return AddressType.workplace;
    }
    return AddressType.unfilled;
  }

  List<TextEditingController> generateControllerList(int length) {
    return List.filled(length, TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: basicAppBar(
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _addressLine1.clear();
                  _addressLine2.clear();
                  _postcode.clear();
                  _city.clear();
                  state = locationOptionsWithoutWholeMalaysia[0];
                  addressType = AddressType.home.name;
                });
              },
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.white),
              ))
        ],
        automaticallyImplyLeading: true,
        title: const Text(
          'Address',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
        height: getMediaQueryHeight(context),
      ),
      body: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        builder: (context, model, child) {
          User? user = model.dataMap!['user'] as User;
          if (model.dataReady('user')) {
            cards.clear();
            cards.add(const AddressCard(
              type: AddressType.unfilled,
              message: "Add New Address",
            ));
            Iterable<AddressCard> cardsFromDb =
                user.addresses.map((e) => AddressCard(
                      type: getAddressType(e.type),
                      message: "${e.addressLine1} \n${e.city}, ${e.state}",
                      onTap: () async {
                        await model.deleteAddress(currentIndex, user);
                        currentIndex = 0;
                        setState(() {});
                      },
                    ));
            cards.addAll(cardsFromDb);
            _swiper.index = currentIndex;
          }
          return !model.dataReady('user') || isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ))
              : Form(
                  key: _formkey,
                  child: LayoutBuilder(
                    builder: (_, viewportConstraints) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: getMediaQueryWidth(context) * 0.05,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: height * 0.2,
                                          color: const Color(0xffFAF1E2),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30.0),
                                          child: Swiper(
                                              controller: _swiper,
                                              onIndexChanged: (value) {
                                                setState(() {
                                                  currentIndex = value;

                                                  if (currentIndex != 0) {
                                                    _addressLine1.text = user
                                                        .addresses[
                                                            currentIndex - 1]
                                                        .addressLine1;
                                                    _addressLine2.text = user
                                                        .addresses[
                                                            currentIndex - 1]
                                                        .addressLine2;
                                                    _postcode.text = user
                                                        .addresses[
                                                            currentIndex - 1]
                                                        .postcode;
                                                    _city.text = user
                                                        .addresses[
                                                            currentIndex - 1]
                                                        .city;
                                                    state = user
                                                        .addresses[
                                                            currentIndex - 1]
                                                        .state;
                                                    addressType = user
                                                        .addresses[
                                                            currentIndex - 1]
                                                        .type;
                                                  } else {
                                                    _addressLine1.text = '';
                                                    _addressLine2.text = '';
                                                    _city.text = '';
                                                    _postcode.text = '';
                                                    state =
                                                        locationOptionsWithoutWholeMalaysia[
                                                            0];
                                                    addressType =
                                                        AddressType.home.name;
                                                  }
                                                });
                                              },
                                              viewportFraction: 0.7,
                                              scale: 0.4,
                                              loop: false,
                                              indicatorLayout:
                                                  PageIndicatorLayout.SLIDE,
                                              itemCount: cards.length,
                                              itemBuilder: (_, index) {
                                                return cards[index];
                                              }),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: getMediaQueryHeight(context) * 0.05,
                                ),
                                SizedBox(
                                  child: Column(
                                    children: <Widget>[
                                      CustomDropDownButton(
                                          width:
                                              getMediaQueryWidth(context) * 1,
                                          data: AddressType.values
                                              .map((e) => e.name)
                                              .where((element) => !(element ==
                                                  AddressType.unfilled.name))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              addressType = value;
                                            });
                                          },
                                          value: addressType),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      inputTextFormField(
                                          controller: _addressLine1,
                                          obscureText: false,
                                          validator: _validator.validateEmpty,
                                          // labelText: "Location",
                                          hintText: "Address Line 1",
                                          // suffixIcon: const Icon(Icons.home),
                                          keybordType:
                                              TextInputType.streetAddress,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      inputTextFormField(
                                          controller: _addressLine2,
                                          obscureText: false,
                                          validator: _validator.validateEmpty,
                                          // labelText: "Location",
                                          hintText: "Address Line 2",
                                          // suffixIcon: const Icon(Icons.home),
                                          keybordType:
                                              TextInputType.streetAddress,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      inputTextFormField(
                                          controller: _postcode,
                                          obscureText: false,
                                          validator: _validator.validateEmpty,
                                          // labelText: "Location",
                                          hintText: "Postcode",
                                          // suffixIcon: const Icon(Icons.home),
                                          keybordType: TextInputType.number,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      inputTextFormField(
                                          controller: _city,
                                          obscureText: false,
                                          validator: _validator.validateEmpty,
                                          // labelText: "Location",
                                          hintText: "City",
                                          // suffixIcon: const Icon(Icons.home),
                                          keybordType:
                                              TextInputType.streetAddress,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      CustomDropDownButton(
                                          width:
                                              getMediaQueryWidth(context) * 1,
                                          data:
                                              locationOptionsWithoutWholeMalaysia,
                                          onChanged: (value) {
                                            setState(() {
                                              state = value;
                                            });
                                          },
                                          value: state)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: getMediaQueryHeight(context) * 0.05,
                                ),
                                Center(
                                  child: Btn(
                                      text: "Save",
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      backgroundColor: kPrimaryColor,
                                      borderColor: kPrimaryColor,
                                      width: getMediaQueryWidth(context) * 0.75,
                                      height:
                                          getMediaQueryHeight(context) * 0.07,
                                      onPressed: () async {
                                        bool validate = validateFields(
                                            _addressLine1,
                                            _addressLine2,
                                            _city,
                                            _postcode,
                                            state,
                                            addressType);

                                        if (validate) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await model
                                              .updateAddresses(
                                                  addressType,
                                                  _addressLine1.text,
                                                  _addressLine2.text,
                                                  _postcode.text,
                                                  _city.text,
                                                  state,
                                                  user,
                                                  currentIndex)
                                              .whenComplete(() async {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            await showCompleteUpdateDialogBox(
                                                context);
                                          }).onError<FirebaseException>((error,
                                                      stackTrace) =>
                                                  showFirebaseExceptionErrorDialogBox(
                                                      context, error));
                                        }
                                      },
                                      isRound: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  bool validateFields(
      TextEditingController line1,
      TextEditingController line2,
      TextEditingController city,
      TextEditingController postcode,
      String state,
      String type) {
    if (line1.text.isEmpty ||
        line2.text.isEmpty ||
        city.text.isEmpty ||
        postcode.text.isEmpty ||
        state.isEmpty ||
        type.isEmpty) {
      showIncompleteFieldsDialogBox(context);
      return false;
    } else {
      return true;
    }
  }
}
