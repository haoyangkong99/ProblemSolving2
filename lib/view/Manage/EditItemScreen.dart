import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  XFile? _selectedCoverPhoto;
  final List<XFile?> _selectedOtherPhoto = [];
  bool selected = false, showAddPhoto = true;
  int currentPage = 1;
  int selectedFirstIndex = 0;
  int selectedSecondIndex = 0;
  String? categoryChosen, subcategoryChosen, condition;
  Validation validator = Validation();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  String _location = locationOptionsWithoutWholeMalaysia[0];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<String>? paymentMethods = [];
  bool isLoading = false;
  List<Widget> photoList = [];
  Item item = Item();
  bool haveEmptyPhotoContainer = false;
  int countMaxPhoto() {
    int totalPhoto = 0;
    _selectedCoverPhoto == null ? totalPhoto += 0 : totalPhoto += 1;
    _selectedOtherPhoto.isEmpty
        ? totalPhoto += 0
        : totalPhoto += _selectedOtherPhoto.length;
    _selectedCoverPhoto == null ? totalPhoto += 1 : totalPhoto += 0;
    return totalPhoto;
  }

  int getPhotoBuilderCount() {
    if (countMaxPhoto() < 2) {
      return 2;
    } else if (countMaxPhoto() == 5) {
      return 5;
    } else {
      return countMaxPhoto() + 1;
    }
  }

  getImage(
    ImageSource source,
    bool isCover,
    double width,
    double height,
    int index,
  ) async {
    XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      if (isCover) {
        _selectedCoverPhoto = image;
        photoList.removeAt(0);
        photoList.insert(
            0,
            photoContainer(
                width, height, FileImage(File(image.path)), true, index));
      } else {
        print("dx" + index.toString());
        _selectedOtherPhoto.add(image);
        photoList.insert(
            index,
            photoContainer(width, height, FileImage(File(image.path)), isCover,
                index + 1));
      }
      setState(() {});
    }
  }

  ImageProvider showImage(XFile file) {
    return FileImage(File(file.path));
  }

  List<Widget> getCategoryExpansionTiles() {
    return List<Widget>.generate(
        categoryList.length,
        (index) => ExpansionTile(
              title: Text(categoryList[index].name),
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryList[index].subCategory.length,
                    itemBuilder: (context, secondindex) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            categoryChosen = categoryList[index].name;
                            subcategoryChosen =
                                categoryList[index].subCategory[secondindex];
                            if (selected) {
                              if (secondindex == selectedSecondIndex &&
                                  index == selectedFirstIndex) {
                                selected = false;
                                selectedFirstIndex = 0;
                                selectedSecondIndex = 0;
                              } else {
                                selectedFirstIndex = index;
                                selectedSecondIndex = secondindex;
                              }
                            } else {
                              selected = true;
                              selectedFirstIndex = index;
                              selectedSecondIndex = secondindex;
                            }
                          });
                        },
                        child: ListTile(
                          trailing: selected &&
                                  selectedSecondIndex == secondindex &&
                                  selectedFirstIndex == index
                              ? const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.blue,
                                )
                              : const Icon(Icons.radio_button_off),
                          title: Text(
                              categoryList[index].subCategory[secondindex]),
                        ),
                      );
                    })
              ],
            ));
  }

  Widget photoContainer(double width, double height, ImageProvider image,
      bool isCover, int index) {
    return InkWell(
      onTap: () async {
        if (isCover) {
          await selectFileMethod(context, 0);
        }
      },
      child: Container(
        child: isCover
            ? Center()
            : Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      photoList.removeAt(index);
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 26,
                    )),
              ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: width / 3,
        height: height * 0.25,
        decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: image),
            border: Border.all(color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ItemViewModel>.reactive(
        viewModelBuilder: () => ItemViewModel(),
        builder: (context, model, child) {
          if (model.dataReady('user') && model.dataReady('item')) {
            item = model.dataMap!['item'] as Item;
            selected = true;
            selectedFirstIndex = categoryList
                .indexWhere((element) => element.name == item.category);
            selectedSecondIndex = categoryList[selectedFirstIndex]
                .subCategory
                .indexWhere((element) => element == item.subcategory);
            condition = item.condition;
            _location = item.location;
            _title.text = item.title;
            _description.text = item.description;
            _quantity.text = item.quantity.toString();
            paymentMethods = item.paymentMethods;
            _price.text = item.price.toStringAsFixed(2);

            if (photoList.isEmpty) {
              photoList = List.generate(
                  1,
                  (index) => _selectedCoverPhoto == null
                      ? photoContainer(width, height,
                          NetworkImage(item.coverImage), true, index)
                      : photoContainer(
                          width,
                          height,
                          FileImage(File(_selectedCoverPhoto!.path)),
                          true,
                          index));
            } else {
              photoList.removeAt(0);
              photoList.insert(
                  0,
                  _selectedCoverPhoto == null
                      ? photoContainer(
                          width, height, NetworkImage(item.coverImage), true, 0)
                      : photoContainer(width, height,
                          FileImage(File(_selectedCoverPhoto!.path)), true, 0));
              if (_selectedOtherPhoto.isEmpty) {
                photoList.addAll(List.generate(
                    item.images!.length,
                    (index) => photoContainer(width, height,
                        NetworkImage(item.images![index]), false, index + 1)));
              }
            }

            if (photoList.length < 5 && !haveEmptyPhotoContainer) {
              photoList
                  .add(emptyPhotoContainer(width, height, photoList.length));
              haveEmptyPhotoContainer = true;
            }
            print("lenght" + photoList.length.toString());
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: basicAppBar(
                height: height,
                automaticallyImplyLeading: true,
                title: const Text(
                  "Edit Item",
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => CustomDialogBox(
                                  title: 'Delete confirmation',
                                  content:
                                      'Are you sure to remove this item from your listing?',
                                  isOtherContent: false,
                                  isConfirm: true,
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {},
                                      child: const Text(
                                        "Confirm",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor),
                                      ),
                                    )
                                  ],
                                ));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ))
                ],
              ),
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(
                              20, MediaQuery.of(context).size.width)),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: currentPage == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Photos For Your Items",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                          "Please provide images related to your images to help buyers in making purchase decision."),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: height * 0.4,
                                        child: Swiper(
                                          viewportFraction: 0.8,
                                          scale: 0.9,
                                          loop: false,
                                          indicatorLayout:
                                              PageIndicatorLayout.COLOR,
                                          itemCount: photoList.length,
                                          itemBuilder: (context, idx) {
                                            // Widget showContainer() {
                                            //   if (idx == 0) {
                                            //     return _selectedCoverPhoto ==
                                            //             null
                                            //         ? photoContainer(
                                            //             width,
                                            //             height,
                                            //             NetworkImage(
                                            //                 item.coverImage))
                                            //         : photoContainer(
                                            //             width,
                                            //             height,
                                            //             FileImage(File(
                                            //                 _selectedCoverPhoto!
                                            //                     .path)));
                                            //   } else {}
                                            // }
                                            print(idx);
                                            return photoList[idx];
                                          },
                                          pagination: const SwiperPagination(),
                                          control: const SwiperControl(),
                                        ),
                                      ),
                                      getPhotoBuilderCount() == 5
                                          ? const SizedBox(
                                              height: 60,
                                              child: Center(
                                                child: Text(
                                                    "You have uploaded maximum number of photos"),
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 40,
                                            ),
                                      Center(
                                        child: Btn(
                                            text: "Continue",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                            backgroundColor: kPrimaryColor,
                                            borderColor: kPrimaryColor,
                                            width: width * 0.75,
                                            height: height * 0.07,
                                            onPressed: () {
                                              if (_selectedCoverPhoto == null) {
                                                validateCoverPhoto(context);
                                              } else {
                                                setState(() {
                                                  currentPage = 2;
                                                });
                                              }
                                            },
                                            isRound: false),
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Describle About The Items You Are Selling",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                          "Please provide related information of items in the fields provided."),
                                      ExpansionTile(
                                        subtitle: const Text(
                                            "Select your item category"),
                                        title: const Text(
                                          "Item Category",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        children: getCategoryExpansionTiles(),
                                      ),
                                      ExpansionTile(
                                        title: const Text("Item Condition"),
                                        children: [
                                          RadioListTile(
                                              title: const Text("New"),
                                              value: "New",
                                              groupValue: condition,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  condition = value;
                                                });
                                              }),
                                          RadioListTile(
                                              title: const Text("Used"),
                                              value: "Used",
                                              groupValue: condition,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  condition = value;
                                                });
                                              })
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      inputTextFormField(
                                        controller: _title,
                                        obscureText: false,
                                        validator: validator.validateEmpty,
                                        labelText: "Item Title",
                                        hintText:
                                            "Attractive title of your item",
                                        keybordType: TextInputType.text,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        maxLines: null,
                                        controller: _description,
                                        obscureText: false,
                                        validator: validator.validateEmpty,
                                        keyboardType: TextInputType.multiline,
                                        decoration: const InputDecoration(
                                          labelText: "Item Description",
                                          hintText:
                                              "Wirte something to describe about the item",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      inputTextFormField(
                                        controller: _price,
                                        obscureText: false,
                                        validator: validator.validateEmpty,
                                        labelText: "Item Price",
                                        hintText: "Price",
                                        keybordType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      inputTextFormField(
                                        controller: _quantity,
                                        obscureText: false,
                                        validator: validator.validateEmpty,
                                        labelText: "Item Quantity",
                                        hintText: "Quantity",
                                        keybordType: const TextInputType
                                            .numberWithOptions(decimal: false),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            focusColor: kPrimaryColor,
                                            //   dropdownColor: Colors.lightBlue[100],
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            items: locationOptions.map((val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Container(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          val,
                                                          maxLines: 2,
                                                          semanticsLabel: '...',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ))),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                _location = newValue.toString();
                                              });
                                            },
                                            value: _location,
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            elevation: 0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SubTitleHeader(
                                          text: "Payment Methods"),
                                      FormBuilderFilterChip<String>(
                                        initialValue: paymentMethods,
                                        elevation: 5,
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        backgroundColor: Colors.grey[200],
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.spaceEvenly,
                                        decoration: const InputDecoration(
                                            enabledBorder: InputBorder.none),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        name: 'condition filter',
                                        selectedColor: kPrimaryColor,
                                        options: const [
                                          FormBuilderChipOption(
                                            value: 'Cash On Delivery (COD)',
                                          ),
                                          FormBuilderChipOption(
                                            value: 'Credit/Debit Card',
                                          ),
                                          FormBuilderChipOption(
                                            value: 'Self-arrange',
                                          ),
                                        ],
                                        onChanged: (value) {
                                          paymentMethods = value;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Btn(
                                            text: "Save",
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                            backgroundColor: kPrimaryColor,
                                            borderColor: kPrimaryColor,
                                            width: width * 0.75,
                                            height: height * 0.07,
                                            onPressed: () async {
                                              bool validate = model
                                                  .validateFields(_formKey);
                                              if (paymentMethods!.isEmpty) {
                                                validateFields(context);
                                              } else {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                await model
                                                    .createItem(
                                                        _selectedCoverPhoto,
                                                        categoryList[
                                                                selectedFirstIndex]
                                                            .name,
                                                        categoryList[
                                                                    selectedFirstIndex]
                                                                .subCategory[
                                                            selectedSecondIndex],
                                                        condition,
                                                        _title.text,
                                                        _description.text,
                                                        _location,
                                                        _selectedOtherPhoto,
                                                        paymentMethods,
                                                        double.parse(
                                                            _price.text),
                                                        int.parse(
                                                            _quantity.text))
                                                    .onError<
                                                        FirebaseException>((error,
                                                            stackTrace) =>
                                                        showFirebaseExceptionErrorDialogBox(
                                                            context, error));
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            },
                                            isRound: false),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          }
        });
  }

  Widget emptyPhotoContainer(double width, double height, int idx) {
    return InkWell(
      onTap: () async {
        print("idx");
        print(idx);
        await selectFileMethod(context, idx);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: width / 4,
          height: height * 0.3,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline_rounded,
                size: 40,
              ),
              idx == 0
                  ? const Text("Cover photo")
                  : const Text("Add more photos")
            ],
          )),
    );
  }

  Future<dynamic> validateCoverPhoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => const CustomDialogBox(
              title: "Incomplete Cover Photo",
              content: 'Please makesure the cover photo is uploaded',
            ));
  }

  Future<dynamic> validateFields(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => const CustomDialogBox(
              title: "Incomplete Fields",
              content:
                  'Please makesure \n\n1. At least one payment method is selected\n2. Both category and subcategory are selected',
            ));
  }

  Future<dynamic> selectFileMethod(BuildContext context, int idx) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 80,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            getImage(
                                ImageSource.camera,
                                idx == 0 ? true : false,
                                getMediaQueryWidth(context),
                                getMediaQueryHeight(context),
                                idx);
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                          )),
                      const Text('Choose From Camera')
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            getImage(
                                ImageSource.gallery,
                                idx == 0 ? true : false,
                                getMediaQueryWidth(context),
                                getMediaQueryHeight(context),
                                idx);

                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.file_copy)),
                      const Text('Choose From Gallery')
                    ],
                  ),
                ],
              ));
        });
  }
}
