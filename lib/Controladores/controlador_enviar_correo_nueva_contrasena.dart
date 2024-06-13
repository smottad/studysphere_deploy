import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';

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
