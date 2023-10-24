import 'package:app_smartv/login/login.dart';
import 'package:app_smartv/screens/signage.dart';
import 'package:app_smartv/screens/pantallas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TvApp());
}

class TvApp extends StatelessWidget {
  const TvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PromoTV',

      initialRoute: 'test',
        routes: {
          'login': (BuildContext context) => const Login(),
          'webview': (BuildContext context) => const WebViewApp(),
          'test' :(BuildContext context) => const DigitalSignageApp(),
        },



      home: const Login(),   
    );
  }
}
