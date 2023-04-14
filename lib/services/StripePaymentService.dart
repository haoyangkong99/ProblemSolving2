import 'dart:convert';
import 'dart:developer';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:utmletgo/services/_services.dart';

class StripePaymentService {
  FirebaseDbService dbService = FirebaseDbService();

  Future<void> initPayment({
    required String email,
    required double amount,
  }) async {
    try {
      // 1. Create a payment intent on the server
      final response = await http.post(
          Uri.parse(
              'https://us-central1-utm-let-go.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      // 2. Initialize the payment sheet

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: jsonResponse['paymentIntent'],
              merchantDisplayName: 'UTM Let Go',
              customerId: jsonResponse['customer'],
              customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
              allowsDelayedPaymentMethods: true));
      await Stripe.instance.presentPaymentSheet();
    } catch (errorr) {
      if (errorr is StripeException) {
      } else {}
    }
  }
}
