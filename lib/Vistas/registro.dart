import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:studysphere/Componentes/boton.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_registro.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  var _isChecked = false;
  CircleAvatar? foto;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: appBar(context, "Crear cuenta", color: 1),
      backgroundColor: colorScheme.background,
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
                    backgroundColor: colorScheme.secondaryContainer,
                    radius: (MediaQuery.of(context).size.height * 0.07)
                        .clamp(10, 100),
                  ),
            ),
            const Spacer(),
            textFormulario(context, nombre, "Nombre",
                teclado: TextInputType.name),
            textFormulario(context, correo, "Correo",
                teclado: TextInputType.emailAddress),
            textFormulario(context, edad, "Edad",
                teclado: TextInputType.number),
            textFormulario(context, telefono, "Teléfono",
                teclado: TextInputType.phone),
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
                    child: Center(
                        child: terminosYCondiciones(
                            context, colorScheme, textTheme))),
                Checkbox(
                  checkColor: colorScheme.onSecondaryContainer,
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => getColor(context, states, colorScheme)),
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
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

Color getColor(
    BuildContext context, Set<MaterialState> states, ColorScheme colorScheme) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return colorScheme.tertiaryContainer;
  }
  return colorScheme.secondaryContainer;
}

RichText terminosYCondiciones(
        context, ColorScheme colorScheme, TextTheme textTheme) =>
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text: 'Acepto los ', // el texto que quieres mostrar
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onBackground)),
          TextSpan(
              text: 'términos y condiciones',
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => terminos(context)),
          TextSpan(
            text: ' y nuestra ', // el texto que quieres mostrar
            style:
                textTheme.bodySmall?.copyWith(color: colorScheme.onBackground),
          ),
          TextSpan(
              text: 'política de privacidad.',
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => politicas(context))
        ],
      ),
    );
