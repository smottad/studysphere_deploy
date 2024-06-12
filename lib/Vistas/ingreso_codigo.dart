import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/pop_up_confirm.dart';
import 'package:studysphere/Componentes/text_code.dart';
import 'package:studysphere/Controladores/controlador_ingreso_codigo.dart';

class IngresoCodigoVerificacion extends StatelessWidget {
  const IngresoCodigoVerificacion({super.key,});

  void timerPopUp(GlobalKey<MyPopUpState> keyVisibility) {
    Timer _timer;
    int _start = 2;

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          keyVisibility.currentState?.changeAllow();
        } else {
          _start--;
        }
      },
    );
  }

  @override
  Widget build (BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    GlobalKey<MyPopUpState> _keyVisibility = GlobalKey();

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
            Text(
              "Escribe el código de recuperación",
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
                TextCodigo(validator: controllerNumber1),
                const SizedBox(
                  width: 20,
                ),
                TextCodigo(validator: controllerNumber2),
                const SizedBox(
                  width: 20,
                ),
                TextCodigo(validator: controllerNumber3),
                const SizedBox(
                  width: 20,
                ),
                TextCodigo(validator: controllerNumber4),
                const SizedBox(
                  width: 20,
                ),
                TextCodigo(validator: controllerNumber5),
                const SizedBox(
                  width: 20,
                ),
                TextCodigo(validator: controllerNumber6),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            MyPopUp(key: _keyVisibility,),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.2).clamp(1, 150),
              child: ElevatedButton(
                onPressed: () {
                  if (controllerNumber1.text.isEmpty || controllerNumber2.text.isEmpty || controllerNumber3.text.isEmpty || controllerNumber4.text.isEmpty || controllerNumber5.text.isEmpty || controllerNumber6.text.isEmpty) {
                    _keyVisibility.currentState?.changeAllow();
                    _keyVisibility.currentState?.isCorrect(false, "Llene los campos");
                    timerPopUp(_keyVisibility);
                  } else {
                    _keyVisibility.currentState?.changeAllow();
                    _keyVisibility.currentState?.isCorrect(true, "Código correcto");
                    timerPopUp(_keyVisibility);
                    goToNuevaContrasena(context);
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