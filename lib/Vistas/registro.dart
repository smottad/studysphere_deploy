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
  CircleAvatar? foto;
  @override
  void initState() {
    super.initState();
    nombre.addListener(validarNombre);
    correo.addListener(validarCorreo);
    edad.addListener(validarEdad);
    telefono.addListener(validarTelefono);
    contrasena.addListener(validarContrasena);
    verificarContrasena.addListener(validarConfirmarContrasena);
  }

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
                  return setState(() => foto = CircleAvatar(
                        backgroundImage: FileImage(file),
                        radius: (MediaQuery.of(context).size.height * 0.07)
                            .clamp(10, 100),
                      ));
                },
                customBorder: const CircleBorder(),
                child: foto ?? FotoDefault(colorScheme: colorScheme)),
            const Spacer(),
            textFormulario(context, nombre, "Nombre",
                teclado: TextInputType.name,
                validator: (val) => nombreValidator_),
            textFormulario(context, correo, "Correo",
                teclado: TextInputType.emailAddress,
                validator: (val) => correoValidator_),
            textFormulario(context, edad, "Edad",
                teclado: TextInputType.number,
                validator: (val) => edadValidator_),
            textFormulario(context, telefono, "Teléfono",
                teclado: TextInputType.phone,
                validator: (val) => telefonoValidator_),
            textFormulario(context, contrasena, "Contraseña",
                oscurecer: true, validator: (val) => contrasenaValidator_),
            textFormulario(context, verificarContrasena, "Confirmar contraseña",
                oscurecer: true,
                validator: (val) => verificarContrasenaValidator_),
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
                  value: isChecked,
                  onChanged: (bool? newValue) {
                    setState(() => isChecked = newValue!);
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

class FotoDefault extends StatelessWidget {
  const FotoDefault({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: const AssetImage('lib/Assets/no_user.png'),
      backgroundColor: colorScheme.secondaryContainer,
      radius: (MediaQuery.of(context).size.height * 0.07).clamp(10, 100),
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
              style: textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => terminos(context)),
          TextSpan(
            text: ' y nuestra ', // el texto que quieres mostrar
            style:
                textTheme.bodySmall?.copyWith(color: colorScheme.onBackground),
          ),
          TextSpan(
              text: 'política de privacidad.',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => politicas(context))
        ],
      ),
    );
