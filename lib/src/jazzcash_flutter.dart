import 'package:flutter/cupertino.dart';

import 'jazzcash_payment_data_model_v1.dart';
import 'jazzcash_payment_request.dart';
import 'payment_screen.dart';

class JazzCashFlutter {
  String merchantId;
  String merchantPassword;
  String integritySalt;
  bool isSandbox;

  JazzCashFlutter({
    required this.merchantId,
    required this.merchantPassword,
    required this.integritySalt,
    required this.isSandbox,
  });

  String sandBoxTransactionUrl = "https://sandbox.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/";
  String liveTransactionUrl = "https://payments.jazzcash.com.pk/CustomerPortal/transactionmanagement/merchantform/";

  Future<String> startPayment({required JazzCashPaymentDataModelV1 paymentDataModelV1, required BuildContext context}) async {
    JazzCashPaymentRequest paymentRequest = JazzCashPaymentRequest(
      integritySalt: integritySalt,
      merchantID: merchantId,
      merchantPassword: merchantPassword,
      transactionUrl: isSandbox ? sandBoxTransactionUrl : liveTransactionUrl,
    );

    String request = paymentRequest.generateRequest(jazzCashPaymentDataModel: paymentDataModelV1);
    return await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => PaymentScreen(request, paymentDataModelV1.ppReturnURL)));
  }
}
