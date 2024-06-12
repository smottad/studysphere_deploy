import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_iniciar_sesion.dart';

var email = TextEditingController();
var password = TextEditingController();

iniciarSesion(BuildContext context) async {
  print("entra a iniciar sesion");
  final ServicioBaseDatosInicioSesion servicioBaseDatosInicioSesion =
      ServicioBaseDatosInicioSesion();
  print("lugo de la conexion");

  try {
    Future<bool> resultado =
        servicioBaseDatosInicioSesion.iniciarSesion(email.text, password.text);

    if (await resultado == true) {
      Navigator.popAndPushNamed(context, '/inicio');
      Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Correo electrónico o contraseña incorrectos"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('An error occurred: $e');
    Navigator.pop(context);
  }
}

// final ServicioBaseDatos servicioBaseDatos = ServicioBaseDatos();

//   // Llamamos al método correspondiente del servicio para crear la cuenta
//   Future<String> resultado = servicioBaseDatos.insertarRegistros(
//     nombre.text,
//     correo.text,
//     edad.text,
//     telefono.text,
//     contrasena.text,
//   );
// // Si el registro fue exitoso, navega a la pantalla de inicio
//   if (resultado == "Usuario registrado correctamente") {
//     Navigator.popAndPushNamed(context, '/inicio');
//     Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
//   } else {
//     // Si el registro no fue exitoso, puedes devolver al usuario a la página de inicio de sesión
//     print("algun tipo de error");
//     print(resultado);
//     Navigator.pop(context); // Cierra la página actual
//   }
// }

// iniciarSesionGoogle(BuildContext context) {
//   Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
// }

// void iniciarSesionGoogle(BuildContext context) async {
//   print("entra a iniciar sesion");

//   final ServicioBaseDatosInicioSesion servicioBaseDatosInicioSesion =
//       ServicioBaseDatosInicioSesion();

//   try {
//     // Llamar al método de inicio de sesión con Google
//     bool resultado =
//         await servicioBaseDatosInicioSesion.iniciarSesionConGoogle(email.text);

//     if (resultado) {
//       Navigator.popAndPushNamed(context, '/inicio');
//       Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
//     } else {
//       print("Correo electrónico o contraseña incorrectos");
//     }
//   } catch (e) {
//     print('An error occurred: $e');
//     Navigator.pop(context);
//   }
// }

irRegistro(BuildContext context) {
  Navigator.pushNamed(context, '/registro');
}

irRecuperarContrasena(BuildContext context) {
  Navigator.pushNamed(context, '/correo_recuperar_contrasena');
}
