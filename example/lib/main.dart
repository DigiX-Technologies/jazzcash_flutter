// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:jazzcash_flutter/jazzcash_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jazzcash Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String paymentStatus = 'Ready for a sandbox payment';
  bool _isProcessing = false;
  final ProductModel productModel = const ProductModel(
    productName: 'Product 1',
    productPrice: '100.00',
  );
  final String integritySalt = 'YOUR_SANDBOX_INTEGRITY_SALT';
  final String merchantID = 'YOUR_SANDBOX_MERCHANT_ID';
  final String merchantPassword = 'YOUR_SANDBOX_MERCHANT_PASSWORD';
  final String returnUrl = 'https://example.com/jazzcash/return';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JazzCash Flutter Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product name: ${productModel.productName}'),
            Text('Product price: PKR ${productModel.productPrice}'),
            const SizedBox(height: 12),
            Text(paymentStatus, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _payViaJazzCash(productModel, context),
              child: Text(_isProcessing ? 'Opening JazzCash…' : 'Purchase now'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _payViaJazzCash(ProductModel element, BuildContext c) async {
    setState(() {
      _isProcessing = true;
      paymentStatus = 'Opening the JazzCash payment page...';
    });

    try {
      final jazzCashFlutter = JazzCashFlutter(
        merchantId: merchantID,
        merchantPassword: merchantPassword,
        integritySalt: integritySalt,
        isSandbox: true,
      );

      final billReference = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';

      final paymentDataModelV1 = JazzCashPaymentDataModelV1(
        ppAmount: element.productPrice,
        ppBillReference: billReference,
        ppDescription: '${element.productName} - PKR ${element.productPrice}',
        ppMerchantID: merchantID,
        ppPassword: merchantPassword,
        ppReturnURL: returnUrl,
      );

      final response = await jazzCashFlutter.startPayment(
        paymentDataModelV1: paymentDataModelV1,
        context: c,
      );
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        paymentStatus = response == null
            ? 'No response was returned. Confirm the payment with your backend.'
            : 'Gateway response received. Verify it with your backend.';
      });
    } catch (err) {
      debugPrint('Unable to start JazzCash payment: $err');
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        paymentStatus = 'Could not start payment. Check the sandbox setup.';
      });
    }
  }
}

class ProductModel {
  const ProductModel({
    required this.productName,
    required this.productPrice,
  });

  final String productName;
  final String productPrice;
}
