import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';

class VisibilityViewModel extends MultipleStreamViewModel {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _userService = locator<UserService>();
  final _dataPassingService = locator<DataPassingService>();
  final _authService = locator<FirebaseAuthenticationService>();
  List<Item>? itemList = [];

  final String? userGuid;
  VisibilityViewModel({this.userGuid}) {
    if (userGuid != null) {
      var listenerUser =
          _userService.getUserByGuidAsStream(userGuid!).listen((event) {});
      listenerUser.onData((data) {
        var listenerItem = _itemService
            .getItemWithConditionAsStream(
              (item) => data.itemLink.contains(item.guid),
            )
            .listen((event) {});
        listenerItem.onData((dataItem) {
          itemList = dataItem;
          notifyListeners();
        });
      });
    }
  }

  @override
  Map<String, StreamData> get streamsMap => {
        'user': StreamData<List<User>>(
            _userService.getUserWithConditionAsStream(
                (user) => user.userType == UserType.user.name)),
      };

  void navigateToHomeScreen() {
    _navigationService.pushNamedAndRemoveUntil(Routes.homeScreen);
  }

  Future<void> signOut() async {
    _dataPassingService.removeAllData();
    await _authService.signOut();
    navigateToHomeScreen();
  }

  Future<void> setUserVisibility(bool visibility) async {
    User user = await _userService.getUserByGuid(userGuid);
    user.visibility =
        visibility ? VisibilityType.allow.name : VisibilityType.disallow.name;
    await _userService.updateUserByGuid(user, userGuid!);
  }

  Future<void> setItemVisibility(bool visibility, String itemGuid) async {
    Item item = await _itemService.getItemByGuid(itemGuid);
    item.visibility =
        visibility ? VisibilityType.allow.name : VisibilityType.disallow.name;

    await _itemService.updateItemByGuid(item, itemGuid);
  }
}
