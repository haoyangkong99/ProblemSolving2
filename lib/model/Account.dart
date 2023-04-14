import 'package:utmletgo/constants/enum_constants.dart';

class Account {
  String guid = '', email = '';
  String userType = UserType.user.name;

  Account();
  Account.complete(this.guid, this.email, this.userType);
}
