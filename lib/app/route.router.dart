// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/view/Marketplace/ItemListScreen.dart';
import 'package:utmletgo/view/Payment/PaymentScreen.dart';
import 'package:utmletgo/view/Visibility/VisibilityScreen.dart';

import '../view/Authentication/EditProfileScreen.dart';
import '../view/Authentication/LoginScreen.dart';
import '../view/Authentication/ProfileScreen.dart';
import '../view/Authentication/RegisterScreen.dart';
import '../view/Authentication/ResetPasswordScreen.dart';
import '../view/HomeScreen.dart';
import '../view/MainScreen.dart';
import '../view/Marketplace/MarketplaceScreen.dart';

class Routes {
  static const String homeScreen = '/';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String editProfileScreen = '/edit-profile-screen';
  static const String profileScreen = '/profile-screen';
  static const String mainScreen = '/main-screen';
  static const String addCreditCardScreen = '/add-credit-card-screen';
  static const String adminVisibilityScreen = '/admin-visibility-screen';
  static const all = <String>{
    homeScreen,
    loginScreen,
    registerScreen,
    resetPasswordScreen,
    editProfileScreen,
    profileScreen,
    mainScreen,
    addCreditCardScreen,
    adminVisibilityScreen
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeScreen, page: HomeScreen),
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.registerScreen, page: RegisterScreen),
    RouteDef(Routes.resetPasswordScreen, page: ResetPasswordScreen),
    RouteDef(Routes.editProfileScreen, page: EditProfileScreen),
    RouteDef(Routes.profileScreen, page: ProfileScreen),
    RouteDef(Routes.adminVisibilityScreen, page: VisibilityScreen),
    RouteDef(
      Routes.mainScreen,
      page: MainScreen,
      generator: MainScreenRouter(),
    ),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    HomeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeScreen(),
        settings: data,
      );
    },
    LoginScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const LoginScreen(),
        settings: data,
      );
    },
    RegisterScreen: (data) {
      var args = data.getArgs<RegisterScreenArguments>(
        orElse: () => RegisterScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => RegisterScreen(
          key: args.key,
        ),
        settings: data,
      );
    },
    ResetPasswordScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ResetPasswordScreen(),
        settings: data,
      );
    },
    EditProfileScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const EditProfileScreen(),
        settings: data,
      );
    },
    ProfileScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ProfileScreen(),
        settings: data,
      );
    },
    MainScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MainScreen(),
        settings: data,
      );
    },
    VisibilityScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const VisibilityScreen(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// RegisterScreen arguments holder class
class RegisterScreenArguments {
  final Key? key;
  final int? page;
  RegisterScreenArguments({this.key, this.page = 1});
}

class MainScreenRoutes {
  static const String marketplaceScreen = '/marketplace-screen';
  static const all = <String>{
    marketplaceScreen,
  };
}

class MainScreenRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(MainScreenRoutes.marketplaceScreen, page: MarketplaceScreen),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    MarketplaceScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MarketplaceScreen(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToHomeScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.homeScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.loginScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToRegisterScreen({
    Key? key,
    int? page = 1,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.registerScreen,
      arguments: RegisterScreenArguments(key: key, page: page),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToResetPasswordScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.resetPasswordScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToEditProfileScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.editProfileScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToProfileScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.profileScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToMainScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.mainScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToNestedMarketplaceScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      MainScreenRoutes.marketplaceScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddCreditCardScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.addCreditCardScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAdminVisibilityScreen({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.adminVisibilityScreen,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
