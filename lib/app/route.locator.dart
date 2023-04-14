// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/services/CreditCardService.dart';
import 'package:utmletgo/services/OfferService.dart';
import 'package:utmletgo/services/OrderService.dart';
import 'package:utmletgo/services/StripePaymentService.dart';
import 'package:utmletgo/services/_services.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ChatService());
  locator.registerLazySingleton(() => ItemService());
  locator.registerLazySingleton(() => ReviewsService());
  locator.registerLazySingleton(() => DataPassingService());
  locator.registerLazySingleton(() => OfferService());
  locator.registerLazySingleton(() => CreditCardService());
  locator.registerLazySingleton(() => VisiblityService());
  locator.registerLazySingleton(() => OrderService());
  locator.registerLazySingleton(() => StripePaymentService());
}
