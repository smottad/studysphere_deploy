import 'package:flutter/material.dart';

//para la foto del menu lateral, por ahora es generico
Image getFotoUsuario(double width, double height) {
  return Image(
    image: const AssetImage('lib/Assets/no_user.png'),
    width: width,
    height: height,
  );
}

irAsignaturas(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/asignaturas');
}

irProyectos(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/proyectos');
}

irHorario(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/horario');
}

irConfiguracion(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/proyectos');
}

void showAction(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushNamed(context, '/inicio/crear_recordatorio');
      break;
    case 1:
      Navigator.pushNamed(context, '/inicio/proyectos');
      //Navigator.pushNamed(context, '/inicio/crear_flashcard');
      break;
    case 2:
      Navigator.pushNamed(context, '/inicio/asignaturas');
      //Navigator.pushNamed(context, '/inicio/crear_asignatura');
      break;
    case 3:
      Navigator.pushNamed(context, '/inicio/proyectos');
      //Navigator.pushNamed(context, '/inicio/crear_proyecto');
      break;
    default:
      throw ('wtf');
  }
}
