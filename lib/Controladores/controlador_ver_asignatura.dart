import 'package:flutter/material.dart';

irEditarAsignatura(BuildContext context, String nameSubject, List<bool> daysSelected) {
  Navigator.pushNamed(context, '/inicio/editar_asignaturas', arguments: {"nameSubject": nameSubject, "days":daysSelected});
}

irVerAsignaturasPasadas(BuildContext context,) {
  Navigator.pushNamed(context, '/inicio/asignaturas_pasadas',);
}

irVerAsignaturasActuales(BuildContext context,) {
  Navigator.pushNamed(context, '/inicio/asignaturas',);
}