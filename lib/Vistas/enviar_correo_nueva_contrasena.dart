import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/pop_up_confirm.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_enviar_correo_nueva_contrasena.dart';

class CorreoNuevaContrasena extends StatelessWidget {
  const CorreoNuevaContrasena({super.key,});

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
    GlobalKey<MyPopUpState> keyVisibility = GlobalKey();

    return Scaffold(
      appBar: appBar(context, "Recuperar contraseña", color: 0),
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
            Text(
              "Escribe el correo asociado a la cuenta para enviarte un código de recuperación",
              style: TextStyle(
                color: colorScheme.tertiary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                textFormulario(context, recoverEmail, "Correo de recuperación"),
                ElevatedButton(
                  onPressed: () {
                    RegExp regExp = RegExp(r"^[a-zA-Z0-9!#$%&'*+-\/=?^_`{|]+@[a-zA-Z0-9]+(.[a-zA-Z0-9]+)+$");

                    if (recoverEmail.text.isEmpty) {
                      keyVisibility.currentState?.changeAllow();
                      keyVisibility.currentState?.isCorrect(false, "Llene el campo");
                      timerPopUp(keyVisibility);
                    } else if (!regExp.hasMatch(recoverEmail.text)) {
                      keyVisibility.currentState?.changeAllow();
                      keyVisibility.currentState?.isCorrect(false, "Ingrese un correo válido");
                      timerPopUp(keyVisibility);
                    } else {
                      keyVisibility.currentState?.changeAllow();
                      keyVisibility.currentState?.isCorrect(true, "Se ha enviado un correo con un código de verificación");
                      timerPopUp(keyVisibility);
                      irIngresarCodigo(context);
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
                      "Enviar",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                  ),
                ),
              ],
            ),
            MyPopUp(key: keyVisibility,),
          ],
        ),
      ),
    );
  }
}