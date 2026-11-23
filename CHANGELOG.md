## 1.0.7

* Validate payment amounts and escape dynamic values in the generated form.
* Match gateway return URLs when query parameters or fragments are added.
* Return a typed `String?` payment response and avoid an unnecessary callback delay.
* Improve the package documentation and sandbox example.
* Add pub.dev repository metadata and exclude large demo GIFs from the archive.

## 1.0.6

* Upgraded Dart SDK constraints to `>=3.0.0 <4.0.0`.
* Upgraded Flutter environment constraints to `>=3.0.0`.
* Upgraded `webview_flutter` dependency to `^4.10.0`.
* Migrated `PaymentScreen` from `webview_flutter` 3.x to 4.x using `WebViewController` and `WebViewWidget`.
* Added `fromJson` factory to `JazzCashPaymentDataModelV1` and cleaned up map initializations.
* Updated `flutter_lints` to `^5.0.0`.
* Added comprehensive unit test coverage.

## 1.0.5

JazzCash Flutter Payment Gateway Integration.
