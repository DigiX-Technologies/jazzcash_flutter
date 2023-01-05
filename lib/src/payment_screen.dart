import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String request;
  final String returnUrl;

  const PaymentScreen(this.request, this.returnUrl);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    } else if (Platform.isIOS) {
      WebView.platform = CupertinoWebView();
    }
  }

  WebViewController ? _webViewController ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebView(
          initialUrl: htmlToURI(),
          debuggingEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            _webViewController = webViewController;
          },
          onProgress: (int progress) {
             debugPrint('debugPrint WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          onPageStarted: (String url) {
            debugPrint('debugPrint Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('debugPrint Page finished loading: $url');
            if (url == widget.returnUrl) {
              readJS(context);
            }
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  String htmlToURI() {
    return Uri.dataFromString(widget.request,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
  }

  void readJS(BuildContext cont) async {
    String html = await _webViewController!.runJavascriptReturningResult(
        "window.document.getElementsByTagName('pre')[0].innerHTML;");

    try {
      // var jsondecoded = json.decode(html);
      // PaymentResponseModel paymentResponseModel;
      // if (Platform.isIOS) {
      //   // ios
      //   paymentResponseModel = PaymentResponseModel.fromJson(jsondecoded);
      // } else if (Platform.isAndroid) {
      //   // android
      //   paymentResponseModel =
      //       PaymentResponseModel.fromJson(json.decode(jsondecoded));
      // }
      // log('jsondecoded --> ${jsondecoded}');
      await Future.delayed(Duration(seconds: 2));
      // Navigator.pop(cont, paymentResponseModel);
      Navigator.pop(cont, html);
      // if(jsondecoded['pp_ResponseCode']=='000'){
      //
      // }

    } catch (err) {
      debugPrint('debugPrint exception $err');
      Navigator.pop(cont, null);
    }
   // print("html response --> $html");
  }
}
