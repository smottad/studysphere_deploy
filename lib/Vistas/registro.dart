import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_registro.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final titulo = "Crear cuenta";
  var _isChecked = false;
  CircleAvatar? foto;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(titulo),
            const Spacer(),
            const Image(
              alignment: Alignment.centerRight,
              image: AssetImage("lib/Assets/logo.png"),
              fit: BoxFit.contain,
              height: 55,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            InkWell(
              onTap: () async {
                var file = await getFoto();
                if (file == null) {
                  return;
                }
                return setState(
                  () => foto = CircleAvatar(
                    backgroundImage: FileImage(file),
                    radius: (MediaQuery.of(context).size.height * 0.07)
                        .clamp(10, 100),
                  ),
                );
              },
              customBorder: const CircleBorder(),
              child: foto ??
                  CircleAvatar(
                    backgroundImage: const AssetImage('lib/Assets/no_user.png'),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    radius: (MediaQuery.of(context).size.height * 0.07)
                        .clamp(10, 100),
                  ),
            ),
            const Spacer(),
            textFormulario(context, nombre, "Nombre"),
            textFormulario(context, correo, "Correo"),
            textFormulario(context, edad, "Edad"),
            textFormulario(context, telefono, "Teléfono"),
            textFormulario(context, contrasena, "Contraseña", oscurecer: true),
            textFormulario(context, verificarContrasena, "Confirmar contraseña",
                oscurecer: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.7)
                        .clamp(100, 400),
                    child: Center(child: terminosYCondiciones(context))),
                Checkbox(
                  checkColor:
                      Theme.of(context).colorScheme.onSecondaryContainer,
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => getColor(context, states)),
                  value: _isChecked,
                  onChanged: (bool? newValue) {
                    setState(() => _isChecked = newValue!);
                  },
                )
              ],
            ),
            const Spacer(),
            boton(context, "Crear cuenta", crearCuenta),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

Color getColor(BuildContext context, Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Theme.of(context).colorScheme.tertiaryContainer;
  }
  return Theme.of(context).colorScheme.secondaryContainer;
}

RichText terminosYCondiciones(context) => RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: 'Acepto los ', // el texto que quieres mostrar
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground)),
          TextSpan(
              text: 'términos y condiciones',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => terminos(context)),
          TextSpan(
            text: ' y nuestra ', // el texto que quieres mostrar
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          TextSpan(
              text: 'política de privacidad.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => politicas(context))
        ],
      ),
    );
