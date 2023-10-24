import 'package:flutter/material.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 90.0 ),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Correo',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 90.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
