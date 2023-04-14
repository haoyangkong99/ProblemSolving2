import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/OfferService.dart';
import 'package:utmletgo/services/OrderService.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:utmletgo/shared/Exception.dart';
import 'package:utmletgo/view/Address/AddressScreen.dart';

class OrderViewModel extends MultipleStreamViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _itemService = locator<ItemService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  final _creditCardService = locator<CreditCardService>();
  final _orderService = locator<OrderService>();
  final _offerService = locator<OfferService>();
  final _paymentService = locator<StripePaymentService>();
  Offer offer;
  OrderViewModel({required this.offer});
  @override
  Map<String, StreamData> get streamsMap => {
        // 'offer':
        //     StreamData<Offer>(_offerService.getOfferByGuidAsStream(offer.guid)),
        'item': StreamData<Item>(getItem()),
        'user': StreamData<User>(getUser()),
        'card': StreamData<List<CreditCard>>(getCreditCard())
      };
  Stream<Item> getItem() {
    String itemGuid = _dataPassingService.get('item_guid') as String;
    return _itemService.getItemByGuidAsStream(itemGuid);
  }

  Stream<User> getUser() {
    var userGuid = _dataPassingService.get('current_user_guid') as String;
    return _userService.getUserByGuidAsStream(userGuid);
  }

  Stream<List<CreditCard>> getCreditCard() {
    var userGuid = _dataPassingService.get('current_user_guid') as String;
    return _creditCardService.getCreditCardsWithConditionAsStream(
        (card) => card.userGuid == userGuid);
  }

  void navigateToAddressScreen() {
    _navigationService.popRepeated(1);
    _navigationService.navigateToView(AddressScreen());
  }

  void navigatePop() {
    _navigationService.popRepeated(1);
  }

  Future<void> updateOrderStatus(String guid, OrderStatus status) async {
    await _orderService.updateOrderStatus(guid, status);
  }

  Future<void> createOrder(String offerGuid, String itemGuid, double amount,
      Address shippingAddress, Payment payment) async {
    if (await _orderService.validateOrderExist(offer)) {
      throw GeneralException(
          title: "Order Existed For This Item",
          message:
              "You are not allowed to place order for this item as there exists order for this item");
    } else {
      await _orderService.addOrder(
          offerGuid, itemGuid, amount, shippingAddress, payment);
    }
  }

  Future<void> makePayment() async {
    await _paymentService.initPayment(
        email: 'haoyangkong@gmail.com', amount: 20000);
  }
}
