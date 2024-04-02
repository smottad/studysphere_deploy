import 'package:flutter/material.dart';

var email = TextEditingController();

var password = TextEditingController();

iniciarSesion(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
}

iniciarSesionGoogle(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
}

irRegistro(BuildContext context) {
  Navigator.pushNamed(context, '/registro');
}
