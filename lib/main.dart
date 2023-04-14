import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/route.locator.dart';
import 'package:utmletgo/app/route.router.dart';
import 'package:utmletgo/constants/theme.dart';
import 'package:utmletgo/firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await setupLocator();
  runApp(MaterialApp(
    title: 'UTM Let Go',
    theme: theme(),
    debugShowCheckedModeBanner: false,
    navigatorKey: StackedService.navigatorKey,
    onGenerateRoute: StackedRouter().onGenerateRoute,
  ));
}
