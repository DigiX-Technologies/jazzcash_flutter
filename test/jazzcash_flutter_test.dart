import 'package:flutter_test/flutter_test.dart';
import 'package:jazzcash_flutter/jazzcash_flutter.dart';
import 'package:jazzcash_flutter/src/jazzcash_payment_request.dart';

void main() {
  group('JazzCashFlutter Tests', () {
    test('JazzCashFlutter initialization', () {
      final jazzCash = JazzCashFlutter(
        merchantId: 'test_merchant_id',
        merchantPassword: 'test_password',
        integritySalt: 'test_salt',
        isSandbox: true,
      );

      expect(jazzCash.merchantId, 'test_merchant_id');
      expect(jazzCash.merchantPassword, 'test_password');
      expect(jazzCash.integritySalt, 'test_salt');
      expect(jazzCash.isSandbox, true);
      expect(
          jazzCash.sandBoxTransactionUrl, contains('sandbox.jazzcash.com.pk'));
      expect(jazzCash.liveTransactionUrl, contains('payments.jazzcash.com.pk'));
    });

    test('JazzCashPaymentDataModelV1 serialization and deserialization', () {
      final model = JazzCashPaymentDataModelV1(
        ppAmount: '100',
        ppBillReference: 'ref123',
        ppDescription: 'Test Product',
        ppMerchantID: 'MC12345',
        ppPassword: 'pass',
        ppReturnURL: 'https://example.com/return',
      );

      final json = model.toJson();
      expect(json['pp_Amount'], '100');
      expect(json['pp_BillReference'], 'ref123');
      expect(json['pp_Description'], 'Test Product');
      expect(json['pp_MerchantID'], 'MC12345');
      expect(json['pp_Password'], 'pass');
      expect(json['pp_ReturnURL'], 'https://example.com/return');
      expect(json['pp_Version'], '1.1');
      expect(json['pp_Language'], 'EN');
      expect(json['pp_TxnCurrency'], 'PKR');

      final fromJsonModel = JazzCashPaymentDataModelV1.fromJson(json);
      expect(fromJsonModel.ppAmount, model.ppAmount);
      expect(fromJsonModel.ppBillReference, model.ppBillReference);
      expect(fromJsonModel.ppDescription, model.ppDescription);
      expect(fromJsonModel.ppMerchantID, model.ppMerchantID);
      expect(fromJsonModel.ppPassword, model.ppPassword);
      expect(fromJsonModel.ppReturnURL, model.ppReturnURL);
    });

    test('JazzCashPaymentRequest generates valid HTML form', () {
      final paymentRequest = JazzCashPaymentRequest(
        integritySalt: 'test_salt_123',
        merchantID: 'test_mid',
        merchantPassword: 'test_pwd',
        transactionUrl: 'https://sandbox.jazzcash.com.pk/form',
      );

      final model = JazzCashPaymentDataModelV1(
        ppAmount: '500',
        ppBillReference: 'bill_001',
        ppDescription: 'Test item',
        ppMerchantID: 'test_mid',
        ppPassword: 'test_pwd',
        ppReturnURL: 'https://example.com/callback',
      );

      final html =
          paymentRequest.generateRequest(jazzCashPaymentDataModel: model);

      expect(html, contains('<!DOCTYPE html>'));
      expect(html, contains('test_salt_123'));
      expect(html, contains('test_mid'));
      expect(html, contains('test_pwd'));
      expect(html, contains('https://sandbox.jazzcash.com.pk/form'));
      expect(html, contains('https://example.com/callback'));
      expect(html, contains('bill_001'));
      expect(html, contains('Test item'));
    });

    test('JazzCashPaymentRequest escapes HTML attribute values', () {
      final paymentRequest = JazzCashPaymentRequest(
        integritySalt: 'test_salt',
        merchantID: 'test_mid',
        merchantPassword: 'test_pwd',
        transactionUrl: 'https://sandbox.jazzcash.com.pk/form',
      );
      final model = JazzCashPaymentDataModelV1(
        ppAmount: '100',
        ppBillReference: 'bill_001',
        ppDescription: 'item" autofocus onfocus="alert(1)',
        ppMerchantID: 'test_mid',
        ppPassword: 'test_pwd',
        ppReturnURL: 'https://example.com/callback',
      );

      final html = paymentRequest.generateRequest(
        jazzCashPaymentDataModel: model,
      );

      expect(html,
          contains('value="item&quot; autofocus onfocus=&quot;alert(1)"'));
      expect(html, isNot(contains('value="item" autofocus')));
    });

    test('JazzCashPaymentRequest rejects non-positive or non-numeric amounts',
        () {
      final paymentRequest = JazzCashPaymentRequest(
        integritySalt: 'test_salt',
        merchantID: 'test_mid',
        merchantPassword: 'test_pwd',
        transactionUrl: 'https://sandbox.jazzcash.com.pk/form',
      );

      JazzCashPaymentDataModelV1 createModel(String amount) {
        return JazzCashPaymentDataModelV1(
          ppAmount: amount,
          ppBillReference: 'bill_001',
          ppDescription: 'Test item',
          ppMerchantID: 'test_mid',
          ppPassword: 'test_pwd',
          ppReturnURL: 'https://example.com/callback',
        );
      }

      for (final amount in ['0', '-1', '100; alert(1)']) {
        expect(
          () => paymentRequest.generateRequest(
            jazzCashPaymentDataModel: createModel(amount),
          ),
          throwsArgumentError,
        );
      }
    });
  });
}
