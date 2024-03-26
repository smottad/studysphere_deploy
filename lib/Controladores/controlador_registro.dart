import 'dart:io';

import 'package:flutter/material.dart';

var nombre = TextEditingController();
var correo = TextEditingController();
var edad = TextEditingController();
var telefono = TextEditingController();
var contrasena = TextEditingController();
var verificarContrasena = TextEditingController();

crearCuenta(BuildContext context) {
  Navigator.pushNamed(context, '/inicio');
}

politicas(BuildContext context) {
  if (Platform.isAndroid || Platform.isIOS) {
    Navigator.pushNamed(
      context,
      '/terminos',
      arguments: 'lib/Assets/policy.html',
    );
  }
}

terminos(BuildContext context) {
  if (Platform.isAndroid || Platform.isIOS) {
    Navigator.pushNamed(
      context,
      '/terminos',
      arguments: 'lib/Assets/terms.html',
    );
  }
}
