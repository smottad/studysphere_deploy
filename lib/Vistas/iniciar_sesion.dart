import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_iniciar_sesion.dart';

class IniciarSesion extends StatelessWidget {
  const IniciarSesion({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
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
                    (MediaQuery.of(context).size.width * 0.7).clamp(200, 500),
                child: TextField(
                  autocorrect: false,
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: "Usuario",
                    border: OutlineInputBorder(),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width:
                      (MediaQuery.of(context).size.width * 0.7).clamp(200, 500),
                  child: TextField(
                    autocorrect: false,
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña",
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () => iniciarSesion(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        //el secondary container es verde en el tema que puse
                        Theme.of(context).colorScheme.secondaryContainer,
                    elevation: 2,
                    fixedSize:
                        Size.fromWidth(MediaQuery.of(context).size.width / 2),
                    maximumSize: const Size.fromWidth(300),
                  ),
                  child: Center(
                    child: Text(
                      'Iniciar sesión',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () => iniciarSesionGoogle(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    elevation: 2,
                    fixedSize:
                        Size.fromWidth(MediaQuery.of(context).size.width / 2),
                    maximumSize: const Size.fromWidth(300),
                  ),
                  child: Center(
                    child: Text(
                      'Iniciar con google',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => irRegistro(context),
                child: Text(
                  "Crear una cuenta",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
