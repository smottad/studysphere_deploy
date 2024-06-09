import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studysphere/Servicios/servicio_registro.dart';

//mage(image: AssetImage("lib/Assets/logo.png"));

var isChecked = false;
final nombre = TextEditingController();
final correo = TextEditingController();
final edad = TextEditingController();
final telefono = TextEditingController();
final contrasena = TextEditingController();
final verificarContrasena = TextEditingController();

String? nombreValidator_;
String? correoValidator_;
String? edadValidator_;
String? telefonoValidator_;
String? contrasenaValidator_;
String? verificarContrasenaValidator_;

validarNombre() {
  //alfabetico + ñ + espacio
  RegExp regExp = RegExp(r"^[a-zA-ZñÑ ]+$");
  if (nombre.text.isEmpty) {
    nombreValidator_ = 'Ingrese su nombre';
  } else if (nombre.text.length > 100) {
    nombreValidator_ = 'El nombre es demasiado largo';
  } else if (!regExp.hasMatch(nombre.text)) {
    nombreValidator_ = 'Ingrese un nombre válido';
  } else {
    nombreValidator_ = null;
  }
}

validarCorreo() {
  RegExp regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (correo.text.isEmpty) {
    correoValidator_ = 'Ingrese su correo';
  } else if (correo.text.length > 100) {
    correoValidator_ = 'El correo es demasiado largo';
  } else if (!regExp.hasMatch(correo.text)) {
    correoValidator_ = 'Ingrese un correo válido';
  } else {
    correoValidator_ = null;
  }
}

bool esNumero(String s) {
  return int.tryParse(s) != null;
}

validarEdad() {
  if (edad.text.isEmpty) {
    edadValidator_ = 'Ingrese su edad';
  } else if (!esNumero(edad.text)) {
    edadValidator_ = 'Ingrese una edad válida';
  } else if (int.parse(edad.text) > 100 || int.parse(edad.text) < 1) {
    edadValidator_ = 'Ingrese una edad válido';
  } else {
    edadValidator_ = null;
  }
}

validarTelefono() {
  if (telefono.text.isEmpty) {
    telefonoValidator_ = 'Ingrese su número de teléfono';
  } else if (!esNumero(telefono.text)) {
    telefonoValidator_ = 'Ingrese una número válido';
  } else if (telefono.text.length != 7 && telefono.text.length != 10) {
    telefonoValidator_ = 'Ingrese un número válido';
  } else {
    telefonoValidator_ = null;
  }
}

validarContrasena() {
  RegExp regexMinus = RegExp(r'[A-Z]');
  RegExp regexMayus = RegExp(r'[a-z]');
  RegExp regexNumeros = RegExp(r'[0-9]');
  RegExp regexCaracteres = RegExp(r'^.{8,16}$');

  if (contrasena.text.isEmpty) {
    contrasenaValidator_ = "Por favor ingrese una contrasena";
  } else if (!regexCaracteres.hasMatch(contrasena.text)) {
    contrasenaValidator_ = "La contraseña debe tener entre 8 y 16 caracteres";
  } else if (!regexMinus.hasMatch(contrasena.text) ||
      !regexMayus.hasMatch(contrasena.text)) {
    contrasenaValidator_ =
        "La contraseña debe contener al menos una letra mayúscula y una minúscula";
  } else if (!regexNumeros.hasMatch(contrasena.text)) {
    contrasenaValidator_ = "La contraseña debe contener al menos un número";
  } else {
    contrasenaValidator_ = null;
  }
}

validarConfirmarContrasena() {
  if (verificarContrasena.text != contrasena.text) {
    verificarContrasenaValidator_ = 'Las constraseñas no coinciden';
  } else {
    verificarContrasenaValidator_ = null;
  }
}

getFoto() async {
  final ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: ImageSource.gallery);
  return file != null ? File(file.path) : null;
}

crearCuenta(BuildContext context) async {
  if (nombreValidator_ != null || nombre.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un nombre válido')));
  }
  if (correoValidator_ != null || correo.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un correo válido')));
  }
  if (edadValidator_ != null || edad.text.isEmpty) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Ingrese una edad válid')));
  }
  if (telefonoValidator_ != null || telefono.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un telefono válido')));
  }
  if (contrasenaValidator_ != null || contrasena.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una contraseña válida')));
  }
  if (verificarContrasenaValidator_ != null ||
      verificarContrasena.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')));
  }
  if (!isChecked) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Debe aceptar nuestros términos y condiciones para crear una cuenta')));
  }
  // Creamos una instancia de nuestro servicio de base de datos para utilizar sus métodos
  // Creamos una instancia de nuestro servicio de base de datos para utilizar sus métodos
  final ServicioRegistroBaseDatos servicioBaseDatosRegistro =
      ServicioRegistroBaseDatos();

// Llamamos al método correspondiente del servicio para crear la cuenta
  try {
    bool resultado = await servicioBaseDatosRegistro.registrarUsuario(
      nombre.text,
      correo.text,
      contrasena.text,
      edad.text,
      telefono.text,
    );

    if (context.mounted) {
      if (resultado == true) {
        // Mostrar un Snackbar indicando que el registro fue exitoso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuario registrado correctamente"),
            backgroundColor: Colors.green,
          ),
        );
        // Navegar a la pantalla de inicio después de mostrar el Snackbar
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      } else {
        // Si el registro no fue exitoso, muestra un Snackbar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al registrar el usuario"),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context); // Cierra la página actual
      }
    }
  } catch (error) {
    // Manejar cualquier error que pueda ocurrir durante el proceso de registro
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar el usuario: $error'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context); // Cierra la página actual
    }
  }
}

politicas(BuildContext context) {
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      Navigator.pushNamed(
        context,
        '/terminos',
        arguments: 'lib/Assets/policy.html',
      );
    }
  }
}

terminos(BuildContext context) {
  if (!kIsWeb) {
  if (Platform.isAndroid || Platform.isIOS) {
    Navigator.pushNamed(
      context,
      '/terminos',
      arguments: 'lib/Assets/terms.html',
    );
    }
  }
}
