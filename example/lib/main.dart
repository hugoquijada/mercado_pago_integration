import 'package:flutter/material.dart';
import 'package:mercado_pago_integration/core/failures.dart';
import 'package:mercado_pago_integration/mercado_pago_integration.dart';
import 'package:mercado_pago_integration/models/payment.dart';

final Map<String, Object> preference = {
  'items': [
    {
      'title': 'Test Product',
      'description': 'Description',
      'quantity': 3,
      'currency_id': 'ARS',
      'unit_price': 1500,
    }
  ],
  'payer': {'name': 'Buyer G.', 'email': 'test@gmail.com'},
};
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mercado Pago Integration Example'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () async {
              const String mpPreferenceId = "251601260-25272df5-b188-436f-a9a0-29c31d871301";
              const String mpPublicKey = "APP_USR-4a4313ac-bede-4a66-b43d-25b9ec036783";
              (await MercadoPagoIntegration.startCheckout(
                publicKey: mpPublicKey,
                preferenceId: mpPreferenceId
              ))
                  .fold((Failure failure) {
                debugPrint('Failure => ${failure.message}');
              }, (Payment payment) {
                debugPrint('Payment => ${payment.paymentId}');
              });
            },
            child: Text('Test Integration'),
          ),
        ),
      ),
    );
  }
}
