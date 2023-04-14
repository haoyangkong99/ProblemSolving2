import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/OrderService.dart';
import 'package:utmletgo/services/_services.dart';

class ReviewsViewModel extends MultipleStreamViewModel {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();
  final _reviewsService = locator<ReviewsService>();
  final _orderService = locator<OrderService>();

  String userGuid = '';
  ReviewsViewModel({required this.userGuid});
  @override
  Map<String, StreamData> get streamsMap => {
        'reviews':
            StreamData<List<Reviews>>(_reviewsService.getAllReviewsAsStream()),
        'seller':
            StreamData<User>(_userService.getUserByGuidAsStream(userGuid)),
        'orderList': StreamData<List<Order>>(getCompletedOrderList()),
        'userList': StreamData<List<User>>(_userService.getAllUsersAsStream()),
        'itemList': StreamData<List<Item>>(_itemService.getAllItemsAsStream()),
      };

  Stream<List<Reviews>> getReviews() {
    User seller = streamsMap['seller']!.data;
    print(seller);
    return _reviewsService.getReviewsWithConditionAsStream(
        (reviews) => seller.reviewsLink.reviewsGuid.contains(reviews.guid));
  }

  Stream<List<Item>> getItemList() {
    List<Reviews> reviews = streamsMap['reviews']!.data;
    List<String> involvedItemGuidList = reviews.map((e) => e.itemGuid).toList();
    return _itemService.getItemWithConditionAsStream(
        (p0) => involvedItemGuidList.contains(p0.guid));
  }

  Stream<List<Item>> getCompletedItemList() {
    List<Order> orderList = streamsMap['orderList']!.data;
    List<Reviews> reviews = streamsMap['reviews']!.data;

    List<String> orderItemGuid = orderList.map((e) => e.itemGuid).toList();
    orderItemGuid = orderItemGuid
        .where((element) => !reviews.any((r) => element.contains(r.itemGuid)))
        .toList();

    return _itemService
        .getItemWithConditionAsStream((p0) => orderItemGuid.contains(p0.guid));
  }

  Stream<List<Order>> getCompletedOrderList() {
    String currentUserGuid =
        _dataPassingService.get('current_user_guid') as String;
    return _orderService.getOrderWithConditionAsStream((order) =>
        order.buyerGuid == currentUserGuid &&
        order.status == OrderStatus.completed.name);
  }

  Stream<List<User>> getReviewers() {
    List<Reviews> reviews = streamsMap['reviews']!.data;
    List<String> involvedReviewerGuidList =
        reviews.map((e) => e.itemGuid).toList();
    return _userService.getUserWithConditionAsStream(
        (p0) => involvedReviewerGuidList.contains(p0.guid));
  }

  Future<void> createReviews(
      String itemGuid, double rating, String feedback) async {
    String reviewerGuid =
        await _userService.getCurrentUser().then((value) => value.guid);
    await _reviewsService.addReview(rating, feedback, itemGuid, reviewerGuid);
  }
}
