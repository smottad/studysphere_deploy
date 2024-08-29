import 'package:flutter/material.dart';
import 'package:studysphere/Controladores/controlador_estudiar_examen.dart';

irEditarAsignatura(BuildContext context, String nameSubject,
    List<bool> daysSelected, String idAsignatura) {
  Navigator.pushNamed(context, '/inicio/editar_asignaturas', arguments: {
    "nameSubject": nameSubject,
    "days": daysSelected,
    "idAsignatura": idAsignatura
  });
}

irVerAsignaturasPasadas(
  BuildContext context,
) {
  Navigator.pushReplacementNamed(
    context,
    '/inicio/asignaturas_pasadas',
  );
}

irVerAsignaturasActuales(
  BuildContext context,
) {
  Navigator.pushReplacementNamed(
    context,
    '/inicio/asignaturas',
  );
}

irEstudiarExamen(BuildContext context, ExamenArgs args) {
  Navigator.pushReplacementNamed(context, '/inicio/asignaturas/estudiar_examen', arguments: args);
}

irPrepararExamen(BuildContext context, ExamenArgs args) {
  Navigator.pushReplacementNamed(context, '/inicio/asignaturas/preparar_examen', arguments: args);
}
