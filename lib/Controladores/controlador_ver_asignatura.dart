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

irEstudiarExamen(BuildContext context) {
  Navigator.pushNamed(context, '/inicio/asignaturas/estudiar_examen');
}

irPrepararExamen(BuildContext context, ExamenArgs args) {
  Navigator.pushNamed(context, '/inicio/asignaturas/preparar_examen', arguments: args);
}
