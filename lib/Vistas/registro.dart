import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:studysphere/Componentes/text_forms.dart';
import 'package:studysphere/Controladores/controlador_registro.dart';
import 'package:studysphere/Componentes/avatar.dart'; // Asegúrate de importar el widget Avatar

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final rs = RandomString();
  String? imageUrl;
  String enlaceImagen = '';

  @override
  void initState() {
    super.initState();
    nombre.addListener(validarNombre);
    correo.addListener(validarCorreo);
    edad.addListener(validarEdad);
    telefono.addListener(validarTelefono);
    contrasena.addListener(validarContrasena);
    verificarContrasena.addListener(validarConfirmarContrasena);
    enlaceImagen =
        rs.getRandomString(uppersCount: 5, lowersCount: 5, numbersCount: 5);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const titulo = "Crear cuenta";

    final colorTexto = colorScheme.onSecondary;
    final colorBar = colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: colorTexto),
        backgroundColor: colorBar,
        foregroundColor: colorTexto,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.125,
            ),
            const Spacer(),
            const Text(titulo),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: const Image(
                alignment: Alignment.centerRight,
                image: AssetImage("lib/Assets/logo.png"),
                fit: BoxFit.contain,
                height: 55,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Avatar(
              enlaceImagen: enlaceImagen,
              imageUrl: imageUrl,
              onUpload: (url) {
                setState(() {
                  imageUrl = url;
                });
              },
            ),
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
                  fillColor: WidgetStateProperty.resolveWith(
                      (states) => getColor(context, states, colorScheme)),
                  value: isChecked,
                  onChanged: (bool? newValue) {
                    setState(() => isChecked = newValue!);
                  },
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => crearCuenta(context, enlaceImagen),
              child: const Text('Crear cuenta'),
            ),
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
    BuildContext context, Set<WidgetState> states, ColorScheme colorScheme) {
  const Set<WidgetState> interactiveStates = <WidgetState>{
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
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
              text: 'Acepto los ',
              style:
                  textTheme.bodySmall?.copyWith(color: colorScheme.onSurface)),
          TextSpan(
              text: 'términos y condiciones',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => terminos(context)),
          TextSpan(
            text: ' y nuestra ',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
          ),
          TextSpan(
              text: 'política de privacidad.',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.tertiary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => politicas(context))
        ],
      ),
    );
