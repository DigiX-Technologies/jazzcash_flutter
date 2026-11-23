# JazzCash Flutter example

This app demonstrates the package's sandbox payment flow.

1. Configure valid JazzCash sandbox credentials and a registered return URL in
   `lib/main.dart`.
2. From this directory, run `flutter pub get`.
3. Launch the app on an Android or iOS device or simulator with WebView support.
4. Tap **Purchase Now** to open the hosted payment page.

The example deliberately does not treat the returned page text as proof of
payment. Verify transaction status on your backend before fulfilling an order.
Do not use the example's in-app credentials pattern for production secrets; see
the security note in the package [README](../README.md).
