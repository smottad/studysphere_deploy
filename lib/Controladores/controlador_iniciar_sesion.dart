import 'package:flutter/material.dart';

var email = TextEditingController();

var password = TextEditingController();

iniciarSesion(BuildContext context) {
  Navigator.pushNamed(context, '/inicio');
}

iniciarSesionGoogle(BuildContext context) {
  Navigator.pushNamed(context, '/inicio');
}

irRegistro(BuildContext context) {
  Navigator.pushNamed(context, '/registro');
}
