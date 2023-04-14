import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:utmletgo/constants/_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/shared/TextFormFieldFormatter.dart';
import 'package:utmletgo/shared/_shared.dart';
import 'package:utmletgo/view/Payment/CreditDebitCard.dart';
import 'package:utmletgo/viewmodel/_viewmodel.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController cvc = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController month = TextEditingController();
  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController cardHolder = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Validation _validator = Validation();
  final SwiperController _swiper = SwiperController();
  bool initial = true, isLoading = false;
  int currentIndex = 0;
  List<CreditDebitCard> cards = [];
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
                  cardHolder.clear();
                  cardNumber.clear();
                  year.clear();
                  month.clear();
                  cvc.clear();
                });
              },
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.white),
              ))
        ],
        automaticallyImplyLeading: true,
        title: const Text(
          'Payment',
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
          User user = model.dataMap!['user'] as User;
          List<CreditCard> cardList = model.dataMap!['card'];
          if (model.dataReady('card')) {
            cards.clear();
            cards.add(const CreditDebitCard(
              deletable: false,
              cardHolder: '',
              cardNumber: '',
              year: '',
              month: '',
              cvc: '',
              color: Colors.red,
            ));
            Iterable<CreditDebitCard> cardsFromDb =
                cardList.map((e) => CreditDebitCard(
                      cardHolder: e.cardHolder,
                      cardNumber: e.cardNumber,
                      year: e.year.toString(),
                      month: e.month.toString(),
                      cvc: e.cvc.toString(),
                      color: Colors.purple,
                      onTap: () async {
                        await model.deleteCard(e);
                        setState(() {});
                        currentIndex = 0;
                      },
                    ));
            cards.addAll(cardsFromDb);
            _swiper.index = currentIndex;
          }
          return !model.dataReady('card') || isLoading
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
                                        height: height * 0.35,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0),
                                        child: Swiper(
                                            controller: _swiper,
                                            onIndexChanged: (value) {
                                              setState(() {
                                                currentIndex = value;
                                                if (currentIndex == 0) {
                                                  cardNumber.clear();
                                                  cardHolder.clear();
                                                  year.clear();
                                                  month.clear();
                                                  cvc.clear();
                                                } else {
                                                  cardNumber.text =
                                                      cardList[currentIndex - 1]
                                                          .cardNumber;
                                                  cardHolder.text =
                                                      cardList[currentIndex - 1]
                                                          .cardHolder;
                                                  year.text =
                                                      cardList[currentIndex - 1]
                                                          .year
                                                          .toString();
                                                  month.text =
                                                      cardList[currentIndex - 1]
                                                          .month
                                                          .toString();
                                                  cvc.text =
                                                      cardList[currentIndex - 1]
                                                          .cvc
                                                          .toString();
                                                }
                                              });
                                            },
                                            viewportFraction: 0.85,
                                            scale: 0.5,
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
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 3),
                                          blurRadius: 5)
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        // color: Colors.grey[200],
                                      ),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: _validator.validateEmpty,
                                        inputFormatters: [
                                          CreditCardNumberFormatter(
                                            mask: 'xxxx-xxxx-xxxx-xxxx',
                                            separator: '-',
                                          )
                                        ],
                                        controller: cardNumber,
                                        onChanged: (val) {
                                          setState(() {});
                                        },
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15),
                                            border: InputBorder.none,
                                            hintText: 'Card Number'),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: TextFormField(
                                              validator:
                                                  _validator.validateEmpty,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2)
                                              ],
                                              controller: month,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 15),
                                                  border: InputBorder.none,
                                                  hintText: 'Month'),
                                              onChanged: (val) {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: TextFormField(
                                              validator:
                                                  _validator.validateEmpty,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2)
                                              ],
                                              controller: year,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 15),
                                                  border: InputBorder.none,
                                                  hintText: 'Year'),
                                              onChanged: (val) {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: TextFormField(
                                              validator:
                                                  _validator.validateEmpty,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3)
                                              ],
                                              controller: cvc,
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5,
                                                          horizontal: 15),
                                                  border: InputBorder.none,
                                                  hintText: 'CVC'),
                                              onChanged: (val) {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: TextFormField(
                                        validator: _validator.validateEmpty,
                                        controller: cardHolder,
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15),
                                            border: InputBorder.none,
                                            hintText: 'Name on card'),
                                        onChanged: (val) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: getMediaQueryHeight(context) * 0.05,
                              ),
                              Center(
                                child: Btn(
                                    text: cards.length == 1 ? "Add" : "Save",
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    backgroundColor: kPrimaryColor,
                                    borderColor: kPrimaryColor,
                                    width: getMediaQueryWidth(context) * 0.75,
                                    height: getMediaQueryHeight(context) * 0.07,
                                    onPressed: () async {
                                      bool validate =
                                          _formkey.currentState!.validate();
                                      if (validate) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await Future.delayed(
                                            const Duration(seconds: 1));
                                        await model
                                            .updateCard(
                                                CreditCard(
                                                    guid: currentIndex == 0
                                                        ? const Uuid().v4()
                                                        : cardList[
                                                                currentIndex -
                                                                    1]
                                                            .guid,
                                                    userGuid: user.guid,
                                                    cardHolder: cardHolder.text,
                                                    cvc: int.parse(cvc.text),
                                                    cardNumber: cardNumber.text,
                                                    month:
                                                        int.parse(month.text),
                                                    year: int.parse(year.text)),
                                                currentIndex)
                                            .whenComplete(() {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            })
                                            .then((value) =>
                                                showCompleteUpdateDialogBox(
                                                    context))
                                            .onError<FirebaseException>((error,
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
                );
        },
      ),
    );
  }
}
