import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late Timer _timer;
  final int _refreshInterval = 60; // Intervalo de actualización en segundos

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: _refreshInterval), (timer) {
      _reloadWebView();
    });
  }

  Future<void> _reloadWebView() async {
    final webViewController = await _controller.future;
    webViewController.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: WebView(
        initialUrl: 'https://app-angular-pelis-udg.herokuapp.com/movie',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
