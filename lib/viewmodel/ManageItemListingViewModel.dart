import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/route.locator.dart';
import 'package:utmletgo/model/Item.dart';
import 'package:utmletgo/model/_model.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:utmletgo/view/Manage/MyItemScreen.dart';

class ManageItemListingViewModel extends MultipleStreamViewModel {
  final _navigationService = locator<NavigationService>();
  final _itemService = locator<ItemService>();
  final _dataPassingService = locator<DataPassingService>();
  final _userService = locator<UserService>();

  @override
  Map<String, StreamData> get streamsMap => {
        'item': StreamData<List<Item>>(_itemService.getAllItemsAsStream()),
        'user': StreamData<User>(_userService.getCurrentUserAsStream()),
      };
  Future<void> navigateToMyItemScreen(String guid) async {
    _dataPassingService.addToDataPassingList("item_guid", guid);
    _navigationService.navigateToView(MyItemScreen());
  }
}
