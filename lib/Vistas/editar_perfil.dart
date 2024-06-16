import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Controladores/controlador_editar_perfil.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    IconData hidden = Icons.remove_red_eye_outlined;

    nombre.text = "Anderson Morales";
    correo.text = "amoralesch@unal.edu.co";
    telefono.text = "3007174707";

    GlobalKey<ProfileTextState> keyProfileName = GlobalKey();
    GlobalKey<ProfileTextState> keyProfileEmail = GlobalKey();
    GlobalKey<ProfileTextState> keyProfilePhone = GlobalKey();
    GlobalKey<ProfileTextState> keyProfilePassword = GlobalKey();
    GlobalKey<ProfileTextState> keyProfileConfimrPassword = GlobalKey();
    GlobalKey<MyVisibilityState> keyVisibility = GlobalKey();

    return Scaffold(
      appBar: appBar(context, "Perfil", color: 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                ProfileText(key: keyProfileName, teclado: TextInputType.name, controller: nombre, label: "Nombre",),
                IconButton(
                  onPressed: () {
                    keyProfileName.currentState?.cambiarAHabilitado();
                  }, 
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                ProfileText(key: keyProfileEmail, teclado: TextInputType.emailAddress, controller: correo, label: "Correo",),
                IconButton(
                  onPressed: () {
                    keyProfileEmail.currentState?.cambiarAHabilitado();
                  }, 
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [ 
                ProfileText(key: keyProfilePhone, teclado: TextInputType.number, controller: telefono, label: "Telefono",),
                IconButton(
                  onPressed: () {
                    keyProfilePhone.currentState?.cambiarAHabilitado();
                  }, 
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
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
              height: 15,
            ),
            MyVisibility(
              key: keyVisibility,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),    
              ),
              onPressed: () {
                if (nombre.text.isNotEmpty && correo.text.isNotEmpty && telefono.text.isNotEmpty) {
                  print("----- CORRECTO -----");
                  keyVisibility.currentState?.changeAllow();
                  keyVisibility.currentState?.isCorrect(true, "Datos actualizados exitosamente");
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
                } else {
                  print("----- Ingresar datos -----");
                  keyVisibility.currentState?.changeAllow();
                  keyVisibility.currentState?.isCorrect(false, "Debe llenar todos los campos");
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
              },
              child: Text(
                "Guardar",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyVisibility extends StatefulWidget {
  const MyVisibility({super.key});

  @override
  State<MyVisibility> createState() => MyVisibilityState();
}

class MyVisibilityState extends State<MyVisibility> {
  bool allow = false;
  String contentText = "";
  Color textColor = const Color.fromRGBO(0, 0, 0, 0);
  Color bckgColor = const Color.fromRGBO(0, 0, 0, 0);

  void changeAllow() {
    if (allow) {
      setState(() {
        allow = false;
      });
    } else {
      setState(() {
        allow = true;
      });
    }
  }

  void isCorrect(bool submit, String newText) {
    if (submit) {
      setState(() {
        textColor = const Color.fromARGB(255, 15, 94, 8);
        bckgColor = const Color.fromARGB(135, 68, 155, 10);
        contentText = newText;
      });
    } else {
      setState(() {
        textColor = const Color.fromRGBO(255, 0, 0, 1);
        bckgColor = const Color.fromRGBO(255, 62, 62, 0.541);
        contentText = newText;
      });
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Visibility(
      visible: allow,
      child: Container( 
        decoration: BoxDecoration(
          color: bckgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: textColor,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            contentText,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ), 
    );
  }
}

class ProfileText extends StatefulWidget {
  ProfileText({super.key, this.oscurecer = false, this.padding = 6.0, this.teclado, required this.controller, required this.label, this.validator = false, this.compareController,});

  bool oscurecer;
  final double padding;
  final TextInputType? teclado;
  final TextEditingController controller;
  final String label;
  final bool validator;
  final TextEditingController? compareController;

  @override
  State<ProfileText> createState() => ProfileTextState();
}

class ProfileTextState extends State<ProfileText> {
  bool habilitar = false;

  void cambiarAHabilitado () {
    if (habilitar) {
      setState(() {
        habilitar = false;
      });
    } else {
      setState(() {
        habilitar = true;
      });
    }
  }

  void mostrarContrasena () {
    if (widget.oscurecer) {
      setState(() {
        widget.oscurecer = false;
      });
    } else {
      setState(() {
        widget.oscurecer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Row( 
        mainAxisSize: MainAxisSize.min, 
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.8).clamp(200, 500),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: !widget.oscurecer,
              controller: widget.controller,
              obscureText: widget.oscurecer,
              obscuringCharacter: '*',
              keyboardType: widget.teclado,
              enabled: habilitar,
              validator: (value) {
                if (widget.validator) {
                  if (widget.controller.text != widget.compareController?.text) {
                    return "Ambos campos deben coincidir";
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),  
        ],
      ),
    );
  }
}