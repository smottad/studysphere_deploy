import 'package:flutter/material.dart';

TextEditingController contrasena = TextEditingController();
TextEditingController verificarContrasena = TextEditingController();

goToLogin(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
}
