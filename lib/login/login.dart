import 'package:app_smartv/login/form.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     body: Center(
      child: FormLogin(),
      
     ),
    );
  }
}
