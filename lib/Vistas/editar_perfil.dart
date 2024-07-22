import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Controladores/controlador_editar_perfil.dart';

// Controladores de texto para los campos del perfil
final nombre = TextEditingController();
final correo = TextEditingController();
final telefono = TextEditingController();
final contrasena = TextEditingController();
final verificarContrasena = TextEditingController();

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Future<void> cargarDatosUsuario() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    try {
      final response =
          await supabase.from('usuarios').select().eq('id', user!.id).single();

      final data = response;
      setState(() {
        nombre.text = data['nombre'] ?? '';
        correo.text = data['correo'] ?? '';
        // Convertir el campo 'telefono' a String
        telefono.text = data['telefono']?.toString() ?? '';
        contrasena.text = data['contraseña'] ?? '';
        verificarContrasena.text = data['contraseña'] ?? '';
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar datos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData hidden = Icons.remove_red_eye_outlined;

    GlobalKey<ProfileTextState> _keyProfileName = GlobalKey();
    GlobalKey<ProfileTextState> _keyProfileEmail = GlobalKey();
    GlobalKey<ProfileTextState> _keyProfilePhone = GlobalKey();
    GlobalKey<ProfileTextState> _keyProfilePassword = GlobalKey();
    GlobalKey<ProfileTextState> _keyProfileConfimrPassword = GlobalKey();
    GlobalKey<MyVisibilityState> _keyVisibility = GlobalKey();

    return Scaffold(
      appBar: appBar(context, "Perfil", color: 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProfileText(
                  key: _keyProfileName,
                  teclado: TextInputType.name,
                  controller: nombre,
                  label: "Nombre",
                ),
                IconButton(
                  onPressed: () {
                    _keyProfileName.currentState?.cambiarAHabilitado();
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
                ProfileText(
                  key: _keyProfileEmail,
                  teclado: TextInputType.emailAddress,
                  controller: correo,
                  label: "Correo",
                ),
                IconButton(
                  onPressed: () {
                    _keyProfileEmail.currentState?.cambiarAHabilitado();
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
                ProfileText(
                  key: _keyProfilePhone,
                  teclado: TextInputType.number,
                  controller: telefono,
                  label: "Telefono",
                ),
                IconButton(
                  onPressed: () {
                    _keyProfilePhone.currentState?.cambiarAHabilitado();
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
                        ProfileText(
                          key: _keyProfilePassword,
                          teclado: TextInputType.name,
                          controller: contrasena,
                          label: "Contraseña",
                          oscurecer: true,
                        ),
                        IconButton(
                          icon: Icon(hidden),
                          onPressed: () {
                            _keyProfilePassword.currentState
                                ?.mostrarContrasena();
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProfileText(
                          key: _keyProfileConfimrPassword,
                          teclado: TextInputType.name,
                          controller: verificarContrasena,
                          label: "Confirmar la contraseña",
                          oscurecer: true,
                          validator: true,
                          compareController: contrasena,
                        ),
                        IconButton(
                          onPressed: () {
                            _keyProfileConfimrPassword.currentState
                                ?.mostrarContrasena();
                          },
                          icon: Icon(hidden),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _keyProfilePassword.currentState?.cambiarAHabilitado();
                    _keyProfileConfimrPassword.currentState
                        ?.cambiarAHabilitado();
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            MyVisibility(
              key: _keyVisibility,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () {
                if (nombre.text.isNotEmpty &&
                    correo.text.isNotEmpty &&
                    telefono.text.isNotEmpty) {
                  actualizarPerfil(
                      context,
                      nombre.text,
                      correo.text,
                      telefono.text,
                      contrasena.text,
                      verificarContrasena
                          .text); // Llama a la función de actualización
                } else {
                  _keyVisibility.currentState?.changeAllow();
                  _keyVisibility.currentState
                      ?.isCorrect(false, "Debe llenar todos los campos");
                  Timer _timer;
                  int _start = 2;

                  const oneSec = Duration(seconds: 1);
                  _timer = Timer.periodic(
                    oneSec,
                    (Timer timer) {
                      if (_start == 0) {
                        timer.cancel();
                        _keyVisibility.currentState?.changeAllow();
                      } else {
                        _start--;
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
            )),
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
  ProfileText({
    super.key,
    this.oscurecer = false,
    this.padding = 6.0,
    this.teclado,
    required this.controller,
    required this.label,
    this.validator = false,
    this.compareController,
  });

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

  void cambiarAHabilitado() {
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

  void mostrarContrasena() {
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
                  if (widget.controller.text !=
                      widget.compareController?.text) {
                    return "Ambos campos deben coincidir";
                  } else {
                    return null;
                  }
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
