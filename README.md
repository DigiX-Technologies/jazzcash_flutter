# Installing

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  jazzcash_flutter: <Latest Version>
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```
$ pub get
```

with `Flutter`:

```
$ flutter pub get
```



### 3. Import it

Now in your `Dart` code, you can use:

```dart
import 'package:jazzcash_flutter/jazzcash_flutter.dart';
```

# Usage

`jazzcash_flutter` is a payment gateway integration package for flutter that initiates the payment process with jazzcash wallet and debit card.
Start it like:

```dart
Future _payViaJazzCash(ProductModel element, BuildContext c) async {
   // print("clicked on Product ${element.name}");

    try {
      JazzCashFlutter jazzCashFlutter = JazzCashFlutter(
        merchantId: "Your Merchant Id",
        merchantPassword: "Your Merchant Password",
        integritySalt: "Your Integrity Salt here",
        isSandbox: true,
      );

      DateTime date = DateTime.now();

      JazzCashPaymentDataModelV1 paymentDataModelV1 = JazzCashPaymentDataModelV1(
          ppAmount: '${element.price}',
          ppBillReference:'refbill${date.year}${date.month}${date.day}${date.hour}${date.millisecond}',
          ppDescription: 'Product details  ${element.name} - ${element.price}',
          ppMerchantID: "Your Merchant Password",
          ppPassword:  "Your Merchant Password",
          ppReturnURL:  "Your Return Url",);

      jazzCashFlutter.startPayment(paymentDataModelV1: paymentDataModelV1, context: context).then((_response) {
        _checkIfPaymentSuccessfull(_response, element, context).then((res) {
         // res is the response you returned from your return url;
          return res;
        });

        setState(() {});
      });
    } catch (err) {
      print("Error in payment $err");
      CommonFunctions.CommonToast(
        message: "Error in payment $err",
      );
      return false;
    }
  }
```
![Android](https://github.com/DigiX-Technologies/jazzcash_flutter/blob/main/images/jazzcash_android.gif)
![IOS](https://github.com/DigiX-Technologies/jazzcash_flutter/blob/main/images/jazzcash_ios.gif)
