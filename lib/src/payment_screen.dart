import 'dart:async';
import 'dart:convert';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String request;
  final String returnUrl;

  const PaymentScreen(this.request, this.returnUrl, {super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;
  bool _returnHandled = false;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('JazzCash WebView loading ($progress%)');
          },
          onPageFinished: (String url) {
            if (!_returnHandled && _matchesReturnUrl(url)) {
              _returnHandled = true;
              unawaited(_readJS());
            }
          },
        ),
      )
      ..loadRequest(
        Uri.dataFromString(
          widget.request,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }

  bool _matchesReturnUrl(String url) {
    final currentUri = Uri.tryParse(url);
    final returnUri = Uri.tryParse(widget.returnUrl);
    if (currentUri == null || returnUri == null) return false;

    return currentUri.scheme == returnUri.scheme &&
        currentUri.host == returnUri.host &&
        currentUri.port == returnUri.port &&
        (currentUri.path.isEmpty ? '/' : currentUri.path) ==
            (returnUri.path.isEmpty ? '/' : returnUri.path);
  }

  Future<void> _readJS() async {
    try {
      final Object result = await _controller.runJavaScriptReturningResult(
        "document.querySelector('pre')"
        " ? document.querySelector('pre').textContent"
        " : document.body.innerText;",
      );
      String response = result.toString();
      try {
        final decoded = jsonDecode(response);
        if (decoded is String) {
          response = decoded;
        }
      } on FormatException {
        // Plain-text responses are returned unchanged.
      }

      if (!mounted) return;
      Navigator.pop(context, response);
    } on Exception catch (error) {
      debugPrint('Unable to read the JazzCash response: $error');
      if (!mounted) return;
      Navigator.pop(context, null);
    }
  }
}
