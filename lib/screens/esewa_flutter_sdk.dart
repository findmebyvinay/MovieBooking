import 'package:flutter/material.dart';
import 'dart:async';

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
    await Future.delayed(Duration(seconds: 5));

    // payment amount 300 xa vani Payemnt Succes
    // navaye Fail
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
