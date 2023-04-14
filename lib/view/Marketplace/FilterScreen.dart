import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedLocation = locationOptions[0];
  bool locationError = false;
  SfRangeValues rangeValues = const SfRangeValues(0, 20000);
  final TextEditingController _priceFrom =
      TextEditingController(text: 0.toString());
  final TextEditingController _priceTo =
      TextEditingController(text: 20000.toString());
  List<String> selectedSubCategory = [];
  List<int>? seletedCategory = [];
  List<String>? selectedConditions = [];
  String? selectedSort = 'Newest';
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = getMediaQueryHeight(context);

    double width = getMediaQueryWidth(context);
    return ViewModelBuilder<MarketplaceViewModel>.nonReactive(
      viewModelBuilder: () => MarketplaceViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: basicAppBar(
            automaticallyImplyLeading: true,
            actions: [
              TextButton(
                  onPressed: () {
                    selectedLocation = locationOptions[0];
                    rangeValues = const SfRangeValues(0, 1000);
                    seletedCategory!.clear();
                    selectedConditions!.clear();
                    selectedSort = 'Newest';
                    formkey.currentState!.reset();
                    setState(() {});
                  },
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
            height: height,
            title: const Text(
              "Filter and Sort",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        body: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                const SubTitleHeader(text: "Sort"),
                FormBuilderChoiceChip<String>(
                  initialValue: selectedSort,
                  elevation: 5,
                  labelStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey[200],
                  alignment: WrapAlignment.spaceAround,
                  decoration:
                      const InputDecoration(enabledBorder: InputBorder.none),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'sort filter',
                  selectedColor: kPrimaryColor,
                  options: const [
                    FormBuilderChipOption(
                      value: 'Newest',
                    ),
                    FormBuilderChipOption(
                      value: 'Oldest',
                    ),
                    FormBuilderChipOption(
                      value: 'Price -  High to Low',
                    ),
                    FormBuilderChipOption(
                      value: 'Price -  Low to High',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value;
                    });
                  },
                ),
                const SubTitleHeader(text: "By Category"),
                FormBuilderFilterChip<String>(
                  elevation: 5,
                  labelStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey[200],
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceEvenly,
                  decoration:
                      const InputDecoration(enabledBorder: InputBorder.none),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'category filter',
                  selectedColor: kPrimaryColor,
                  options: categoryList
                      .map((e) => FormBuilderChipOption(value: e.name))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      seletedCategory!.clear();
                      value!.forEach((element) {
                        seletedCategory!.add(categoryList.indexWhere(
                            (Category) => Category.name == element));
                      });
                      selectedSubCategory =
                          List.filled(seletedCategory!.length, "");
                    });
                  },
                ),
                seletedCategory!.isEmpty
                    ? const Center()
                    : const SubTitleHeader(
                        text: "Subcategory",
                        color: Colors.amber,
                      ),
                seletedCategory!.isEmpty
                    ? const Center()
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: seletedCategory!.length,
                        itemBuilder: (_, index) {
                          List<String> subCat =
                              categoryList[seletedCategory![index]].subCategory;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    categoryList[seletedCategory![index]].name),
                              ),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subCat.length,
                                  itemBuilder: (ctx, idx) {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedSubCategory[index] =
                                                  subCat[idx];
                                            });
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 20.0),
                                              decoration: BoxDecoration(
                                                  color: selectedSubCategory[
                                                              index] ==
                                                          subCat[idx]
                                                      ? Colors.amber
                                                      : Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(45)),
                                                  boxShadow: [
                                                    const BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 2.0,
                                                      spreadRadius: 0.0,
                                                      offset: Offset(2.0,
                                                          2.0), // shadow direction: bottom right
                                                    )
                                                  ]),
                                              child: Text(
                                                subCat[idx],
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black),
                                              ))),
                                    ));
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                const SubTitleHeader(text: "By Location"),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      focusColor: kPrimaryColor,
                      //   dropdownColor: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(25),
                      items: locationOptions.map((val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                val,
                                maxLines: 2,
                                semanticsLabel: '...',
                                overflow: TextOverflow.ellipsis,
                              )),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedLocation = newValue.toString();
                        });
                      },
                      value: selectedLocation,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      elevation: 0,
                    ),
                  ),
                ),
                const SubTitleHeader(text: "By Item Condition"),
                FormBuilderFilterChip<String>(
                  elevation: 5,
                  labelStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey[200],
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceEvenly,
                  decoration:
                      const InputDecoration(enabledBorder: InputBorder.none),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: 'condition filter',
                  selectedColor: kPrimaryColor,
                  options: const [
                    FormBuilderChipOption(
                      value: 'New',
                    ),
                    FormBuilderChipOption(
                      value: 'Used',
                    ),
                  ],
                  onChanged: (value) {
                    selectedConditions = value;
                  },
                ),
                const SubTitleHeader(text: "By Price Range"),
                SizedBox(
                  width: width * 0.8,
                  child: SfRangeSlider(
                    dragMode: SliderDragMode.both,
                    activeColor: kPrimaryColor,
                    min: 0.0,
                    max: 20000.0,
                    values: rangeValues,
                    interval: 5000,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 5,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        rangeValues = values;
                        double start = double.parse(values.start.toString());
                        double end = double.parse(values.end.toString());
                        _priceFrom.text = start.toStringAsFixed(2);
                        _priceTo.text = end.toStringAsFixed(2);
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: kPrimaryColor, width: 1))),
                      width: width * 0.3,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Start",
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        controller: _priceFrom,
                        onChanged: (value) {
                          rangeValues = SfRangeValues(
                              double.parse(value), rangeValues.end);
                        },
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: kPrimaryColor, width: 1))),
                      width: width * 0.3,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "End",
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        // initialValue: _priceTo.text,
                        controller: _priceTo,
                        onChanged: (value) {
                          setState(() {
                            rangeValues = SfRangeValues(
                                rangeValues.start, double.parse(value));
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 1))),
          height: height * 0.1,
          child: Center(
            child: Btn(
                text: "Apply changes",
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                backgroundColor: kPrimaryColor,
                borderColor: kPrimaryColor,
                width: width * 0.75,
                height: height * 0.07,
                onPressed: () {
                  model.addFilterToDataPassing(
                      selectedSort!,
                      seletedCategory!,
                      selectedSubCategory,
                      selectedLocation,
                      selectedConditions!,
                      double.parse(_priceFrom.text),
                      double.parse(_priceTo.text));
                },
                isRound: false),
          ),
        ),
      ),
    );
  }
}
