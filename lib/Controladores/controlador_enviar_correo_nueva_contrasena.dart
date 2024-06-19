import 'package:flutter/material.dart';

String? correoValidator_;

TextEditingController recoverEmail = TextEditingController();

irIngresarCodigo(
  BuildContext context,
) {
  Navigator.pushNamed(
    context,
    '/correo_ingresar_codigo',
  );
}
