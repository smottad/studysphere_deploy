import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_iniciar_sesion.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studysphere/Vistas/pagina_inicio.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({Key? key}) : super(key: key);

  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PaginaInicio(),
          ),
        );
      }
    });
  }

  final supabase = Supabase.instance.client;
  Future<AuthResponse> _googleSignIn() async {
    try {
      /// TODO: update the Web client ID with your own.
      ///
      /// Web Client ID that you registered with Google Cloud.
      // const webClientId =
      //     '790357339959-ou6j3phs7k166d0mugf0f997epf2ank4.apps.googleusercontent.com';

      /// TODO: update the iOS client ID with your own.
      ///
      /// iOS Client ID that you registered with Google Cloud.
      // const iosClientId = 'my-ios.apps.googleusercontent.com';

      // Google sign in on Android will work without providing the Android
      // Client ID registered on Google Cloud.

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            "770206202095-6u07tb5ja5ajsbf2bkac4oamsdq11op7.apps.googleusercontent.com",
        // serverClientId: webClientId,
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      // if (accessToken == null) {
      //   throw 'No Access Token found.';
      // }

      print("aca");
      print("idToken: $idToken");
      print("aca2");
      print("accessToken: $accessToken");

      return supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken ?? '',
        accessToken: accessToken,
      );
    } catch (e) {
      print('Error signing in with Google: $e');
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          //tamaño de la pantalla
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Assets/background.png"),
              //llenar el fondo sin importar la relacion de aspecto
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
                //Para mantener el tema de texto pero diciendo que sea negro
                style: textTheme.displayMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
              SizedBox(
                  height:
                      (MediaQuery.of(context).size.width * 0.5).clamp(200, 300),
                  width:
                      (MediaQuery.of(context).size.width * 0.5).clamp(200, 300),
                  child: const Image(
                    image: AssetImage("lib/Assets/logo.png"),
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                //minimo 200 maximo 500
                width:
                    (MediaQuery.of(context).size.width * 0.8).clamp(200, 500),
                child: textFormulario(context, email, "Correo",
                    padding: 0.0, teclado: TextInputType.emailAddress),
              ),
              textFormulario(context, password, "Contraseña", oscurecer: true),
              boton(context, "Iniciar sesión", iniciarSesion),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _googleSignIn();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'No se pudo obtener un token de acceso desde Google. Verifica tu cuenta de Google.'),
                        duration: Duration(seconds: 3), // Duración del mensaje
                      ),
                    );
                  }
                },
                child: const Text('Google login'),
              ),
              TextButton(
                onPressed: () => irRegistro(context),
                child: Text(
                  "Crear una cuenta",
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.tertiary),
                ),
              ),
              TextButton(
                onPressed: () => irRecuperarContrasena(context),
                child: Text(
                  "¿Te has olvidado de tu contraseña? Recuperar contraseña",
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.tertiary),
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
