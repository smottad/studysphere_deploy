import 'package:flutter/material.dart';

var email = TextEditingController();

var password = TextEditingController();

iniciarSesion(BuildContext context) {
  print('iniciando sesión ... ');
  Navigator.pushNamed(context, '/start');
}

iniciarSesionGoogle(BuildContext context) {
  print('iniciando sesión con google... ');
  Navigator.pushNamed(context, '/start');
}
