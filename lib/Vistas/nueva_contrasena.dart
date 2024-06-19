import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/ProfileText.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/pop_up_confirm.dart';
import 'package:studysphere/Controladores/controlador_nueva_contrasena.dart';

class NuevaContrasena extends StatelessWidget {
  const NuevaContrasena({super.key,});

  void timerPopUp(GlobalKey<MyPopUpState> keyVisibility) {
    Timer timer;
    int start = 2;

    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          keyVisibility.currentState?.changeAllow();
        } else {
          start--;
        }
      },
    );
  }

  @override
  Widget build (BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    IconData hidden = Icons.remove_red_eye_outlined;

    GlobalKey<ProfileTextState> keyProfilePassword = GlobalKey();
    GlobalKey<ProfileTextState> keyProfileConfimrPassword = GlobalKey();
    GlobalKey<MyPopUpState> keyVisibility = GlobalKey();

    return Scaffold(
      appBar: appBar(context, "Ingresar código", color: 0),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileText(key: keyProfilePassword, teclado: TextInputType.name, controller: contrasena, label: "Contraseña", oscurecer: true,),
                        IconButton(
                          icon: Icon(hidden),
                          onPressed: () {
                            keyProfilePassword.currentState?.mostrarContrasena();
                          }, 
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileText(key: keyProfileConfimrPassword, teclado: TextInputType.name, controller: verificarContrasena, label: "Confirmar la contraseña", oscurecer: true, validator: true, compareController: contrasena,),
                        IconButton(
                          onPressed: () {
                            keyProfileConfimrPassword.currentState?.mostrarContrasena();
                          }, 
                          icon: Icon(hidden),
                          ),
                      ],
                    ),
                  ],
                ), 
                IconButton(
                  onPressed: () {
                    keyProfilePassword.currentState?.cambiarAHabilitado();
                    keyProfileConfimrPassword.currentState?.cambiarAHabilitado();
                  }, 
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            MyPopUp(key: keyVisibility,),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.2).clamp(1, 150),
              child: ElevatedButton(
                onPressed: () {
                  if (contrasena.text.isEmpty || verificarContrasena.text.isEmpty) {
                    keyVisibility.currentState?.changeAllow();
                    keyVisibility.currentState?.isCorrect(false, "Llene todos los campos");
                    timerPopUp(keyVisibility);
                  } else if (contrasena.text != verificarContrasena.text) {
                    keyVisibility.currentState?.changeAllow();
                    keyVisibility.currentState?.isCorrect(false, "Los campos tienen que coincidir");
                    timerPopUp(keyVisibility);
                  } else {
                    keyVisibility.currentState?.changeAllow();
                    keyVisibility.currentState?.isCorrect(true, "Contraseña cambiada");
                    timerPopUp(keyVisibility);
                    goToLogin(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      //el secondary container es verde en el tema que puse
                      Theme.of(context).colorScheme.secondaryContainer,
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Confirmar",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}