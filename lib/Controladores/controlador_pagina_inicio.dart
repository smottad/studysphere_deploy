import 'package:flutter/material.dart';

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
      Navigator.pushNamed(context, '/inicio/proyectos');
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
