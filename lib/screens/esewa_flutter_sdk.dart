//import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Yo EsewaFlutterSdk aafai garako
// paxi yo file lai delete garerw eSewa ko SDK direct booking_screen ma import garne, that's all

class EsewaFlutterSdk {
  static Future<void> initPayment({
    required EsewaConfig esewaConfig,
    required EsewaPayment esewaPayment,
    required Function(EsewaPaymentSuccessResult) onPaymentSuccess,
    required Function(String) onPaymentFailure,
    required Function(String) onPaymentCancellation,
  }) async {
   // 5 second ko delay rakheko payment process lai
    await Future.delayed(Duration(seconds: 3));

    // payment amount 300 xa vani Payemnt Succes
    // navaye Fail
     // Make an API call to the eSewa payment gateway
   /* final response = await http.post(
      Uri.parse('https://rc.esewa.com.np/mobile/payment'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'environment': esewaConfig.environment.toString(),
        'clientId': esewaConfig.clientId,
        'secretId': esewaConfig.secretId,
        'productId': esewaPayment.productId,
        'productName': esewaPayment.productName,
        'productPrice': esewaPayment.productPrice.toString(),
      }),
    );

    // Handle the response from the eSewa payment gateway
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final successResult = EsewaPaymentSuccessResult(
          productId: esewaPayment.productId,
          productName: esewaPayment.productName,
          totalAmount: esewaPayment.productPrice,
          environment: esewaConfig.environment,
          code: data['00'],
          merchantName: data['Qflix'],
          message: data['Payment Successful'],
          date: data[DateTime.now().toString()],
          refId: data['1234567890'],
        );*/
    if (esewaPayment.productPrice == 300) {
      final successResult = EsewaPaymentSuccessResult(
        productId: esewaPayment.productId,
        productName: esewaPayment.productName,
        totalAmount: esewaPayment.productPrice,
        environment: esewaConfig.environment,
        code: "00",
        merchantName: "QFlix Butwal",
        message: "Payment successful",
        date: DateTime.now().toString(),
        refId: "1234567890",
      );
      onPaymentSuccess(successResult);
    } else {
      //payment failure
      onPaymentFailure("Payment failed");
    }
    //cancel lai code lekhexaina
  }
}
class EsewaConfig {
  final Environment environment;
  final String clientId;
  final String secretId;

  EsewaConfig({
    required this.environment,
    required this.clientId,
    required this.secretId,
  });
}

class EsewaPayment {
  final String productId;
  final String productName;
  final int productPrice;

  EsewaPayment({
    required this.productId,
    required this.productName,
    required this.productPrice,
  });
  @override
  String toString() {
    return productPrice.toString(); // Convert productPrice to a string
  }
}

class EsewaPaymentSuccessResult {
  final String productId;
  final String productName;
  final int totalAmount;
  final Environment environment;
  final String code;
  final String merchantName;
  final String message;
  final String date;
  final String refId;

  Object? totalPrice;

  Object? productPrice;

  EsewaPaymentSuccessResult({
    required this.productId,
    required this.productName,
    required this.totalAmount,
    required this.environment,
    required this.code,
    required this.merchantName,
    required this.message,
    required this.date,
    required this.refId,
  });
}

enum Environment {
  test,
  live,
}
