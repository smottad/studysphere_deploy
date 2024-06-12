import 'package:flutter/material.dart';

TextEditingController controllerNumber1 = TextEditingController();
TextEditingController controllerNumber2 = TextEditingController();
TextEditingController controllerNumber3 = TextEditingController();
TextEditingController controllerNumber4 = TextEditingController();
TextEditingController controllerNumber5 = TextEditingController();
TextEditingController controllerNumber6 = TextEditingController();

goToNuevaContrasena(BuildContext context,) {
  Navigator.pushNamed(
    context,
    '/nueva_contrasena',
  );
}