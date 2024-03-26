import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//mage(image: AssetImage("lib/Assets/logo.png"));

var nombre = TextEditingController();
var correo = TextEditingController();
var edad = TextEditingController();
var telefono = TextEditingController();
var contrasena = TextEditingController();
var verificarContrasena = TextEditingController();

getFoto() async {
  final ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: ImageSource.gallery);
  return file != null ? File(file.path) : null;
}

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
