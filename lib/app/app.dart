import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/view/Authentication/EditProfileScreen.dart';
import 'package:utmletgo/view/Authentication/ProfileScreen.dart';
import 'package:utmletgo/view/Authentication/_authentication.dart';
import 'package:utmletgo/view/HomeScreen.dart';
import 'package:utmletgo/view/MainScreen.dart';
import 'package:utmletgo/view/Marketplace/_marketplace.dart';
import 'package:utmletgo/view/Payment/PaymentScreen.dart';

@StackedApp(routes: [
  MaterialRoute(page: HomeScreen, initial: true),
  MaterialRoute(page: LoginScreen),
  MaterialRoute(page: RegisterScreen),
  MaterialRoute(page: ResetPasswordScreen),
  MaterialRoute(page: EditProfileScreen),
  MaterialRoute(
    page: ProfileScreen,
  ),
  // MaterialRoute(page: AddCreditCardScreen),
  MaterialRoute(
      page: MainScreen, children: [MaterialRoute(page: MarketplaceScreen)]),
  // @stacked-route
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: SnackbarService),
])
class App {}
