import 'package:flutter/material.dart';

TextEditingController contrasena = TextEditingController();
TextEditingController verificarContrasena = TextEditingController();

goToLogin(BuildContext context) {
  Navigator.pushNamed(
    context,
    '/',
  );
}