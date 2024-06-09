import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_iniciar_sesion.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

// const String webClientId =
//     '790357339959-7j9hufe3kuiu0qk9h91trd9bht1qn110.apps.googleusercontent.com';
// const String androidClientId =
//     '790357339959-ltmqfj3hintajsqnoghio8obnc2i6614.apps.googleusercontent.com';

// Future<AuthResponse> iniciarSesionGoogle() async {
//   try {
//     const webClientId =
//         '790357339959-7j9hufe3kuiu0qk9h91trd9bht1qn110.apps.googleusercontent.com';

//     final GoogleSignIn googleSignIn = GoogleSignIn(clientId: webClientId);
//     final googleUser = await googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;

//     if (accessToken == null) {
//       throw 'No Access Token found.';
//     }
//     if (idToken == null) {
//       throw 'No ID Token found.';
//     }

//     final supabase = Supabase.instance.client;

//     return supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   } catch (e) {
//     print('Error occurred during Google sign in: $e');
//     throw e;
//   }
// }

class IniciarSesion extends StatelessWidget {
  const IniciarSesion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/Assets/background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            Text(
              "STUDY SPHERE",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.width * 0.5).clamp(200, 300),
              width: (MediaQuery.of(context).size.width * 0.5).clamp(200, 300),
              child: const Image(
                image: AssetImage("lib/Assets/logo.png"),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.8).clamp(200, 500),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await iniciarSesionGoogle(context);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Iniciar sesión con Google'),
            ),
            TextButton(
              onPressed: () {
                // Navegar a la página de registro
              },
              child: Text(
                "Crear una cuenta",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
