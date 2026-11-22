import 'dart:async';
import 'dart:convert';
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
            debugPrint('debugPrint WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('debugPrint Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('debugPrint Page finished loading: $url');
            if (url == widget.returnUrl) {
              _readJS();
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

  void _readJS() async {
    try {
      final Object result = await _controller.runJavaScriptReturningResult(
        "window.document.getElementsByTagName('pre')[0].innerHTML;",
      );
      String html = result.toString();
      try {
        final decoded = jsonDecode(html);
        if (decoded is String) {
          html = decoded;
        }
      } catch (_) {}

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pop(context, html);
    } catch (err) {
      debugPrint('debugPrint exception $err');
      if (!mounted) return;
      Navigator.pop(context, null);
    }
  }
}
