import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_iniciar_sesion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

Future<void> iniciarSesionGoogle(BuildContext context) async {
  try {
    const webClientId =
        '790357339959-7j9hufe3kuiu0qk9h91trd9bht1qn110.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    // Check if the login was successful
    // Navigate to the home page
    Navigator.popAndPushNamed(context, '/inicio');
    Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
  } catch (e) {
    print('Error occurred during Google sign in: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error al iniciar sesión con Google"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

irRegistro(BuildContext context) {
  Navigator.pushNamed(context, '/registro');
}
