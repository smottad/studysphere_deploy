import 'package:flutter/material.dart';

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
