import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_proyecto.dart';

goEditProject(
  BuildContext context,
  String nameProject,
) {
  Navigator.pushNamed(context, '/inicio/editar_proyectos', arguments: {
    "nameProject": nameProject,
  });
}

goVerProyectosPasados(
  BuildContext context,
) {
  Navigator.pushReplacementNamed(
    context,
    '/inicio/proyectos_pasados',
  );
}

goVerProyectosActuales(
  BuildContext context,
) {
  Navigator.pushReplacementNamed(
    context,
    '/inicio/proyectos',
  );
}

obtenerNombresProyectos(BuildContext context) {
  final servicioProyecto = ServicioRegistroProyectoBaseDatos();
  return servicioProyecto.obtenerNombresProyectosPorUsuario(context);
}

obtenerNombresProyectosAntiguos(BuildContext context) {
  final servicioProyecto = ServicioRegistroProyectoBaseDatos();
  return servicioProyecto.obtenerNombresProyectosPorUsuarioAntiguos(context);
}
