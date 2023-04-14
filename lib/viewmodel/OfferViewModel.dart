// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/OfferService.dart';
import 'package:utmletgo/services/OrderService.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:utmletgo/view/Order/OrderScreen.dart';

class OfferViewModel extends MultipleStreamViewModel {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _offerService = locator<OfferService>();
  final _orderService = locator<OrderService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  Message chatMessage;

  OfferViewModel({
    required this.chatMessage,
  });
  @override
  Map<String, StreamData> get streamsMap => {
        'offer': StreamData<Offer>(
            _offerService.getOfferByGuidAsStream(chatMessage.message)),
        'order': StreamData<List<Order>>(getOrder()),
        'currentUser': StreamData<User>(_userService.getCurrentUserAsStream())
      };
  Stream<List<Order>> getOrder() {
    var guid = _dataPassingService.get('item_guid');
    return _orderService.getOrderWithConditionAsStream((order) =>
        order.itemGuid == guid && order.status != OrderStatus.cancelled.name);
  }

  Future<void> updateOfferStatus(OfferStatus status) async {
    Offer offer = await _offerService.getOfferByGuid(chatMessage.message);
    if (status == OfferStatus.accepted) {}
    offer.status = status.name;
    await _offerService.updateOfferByGuid(offer, offer.guid);
  }

  Future<List<Order>> validateOrderExist(Offer offer) async {
    return await _orderService.getOrderWithCondition((order) =>
        order.itemGuid == offer.itemGuid &&
        order.status != OrderStatus.cancelled.name);
  }

  void navigateToOrderScreen(Offer offer) {
    _navigationService.navigateToView(OrderScreen(offer: offer));
  }
}
