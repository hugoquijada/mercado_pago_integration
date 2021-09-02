import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/failures.dart';
import 'models/payment.dart';
import 'models/result.dart';

class MercadoPagoIntegration {
  static const MethodChannel _channel = const MethodChannel('mercado_pago_integration');

  static Future<Either<Failure, Payment>> startCheckout({
    @required String publicKey,
    @required String preferenceId,
  }) async {
    try {
      assert(publicKey != null);
      assert(preferenceId != null);
      final String mpResult = await _channel.invokeMethod('startCheckout', {
        'publicKey': publicKey,
        'checkoutPreferenceId': preferenceId,
      });
      Result result;
      try {
        result = Result.fromJson(jsonDecode(mpResult) as Map<String, dynamic>);
        if (result.error != null && result.error.isNotEmpty) {
          return Left(UserCanceledFailure(message: result.error));
        } else {
          return Right(result.payment);
        }
      } catch (er) {
        debugPrint(er);
        return Left(UserCanceledFailure(message: 'Wrong Payment information, please review it'));
      }
    } catch (e) {
      return Left(CreatePreferenceFailure(message: '${e?.code} -> ${e?.message}'));
    }
  }

}
