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
  Navigator.pushNamed(
    context,
    '/inicio/proyectos_pasados',
  );
}

goVeProyectosActuales(
  BuildContext context,
) {
  Navigator.pushNamed(
    context,
    '/inicio/proyectos',
  );
}

obtenerNombresProyectos(BuildContext context) {
  final servicioProyecto = ServicioRegistroProyectoBaseDatos();
  return servicioProyecto.obtenerNombresProyectosPorUsuario(context);
}
