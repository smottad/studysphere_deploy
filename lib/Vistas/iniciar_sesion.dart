import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_iniciar_sesion.dart';

class IniciarSesion extends StatelessWidget {
  const IniciarSesion({super.key});

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
              boton(context, "Iniciar con Google", iniciarSesion),
              TextButton(
                onPressed: () => irRegistro(context),
                child: Text(
                  "Crear una cuenta",
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
