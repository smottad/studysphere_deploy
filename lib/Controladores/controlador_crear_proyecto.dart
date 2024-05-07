import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_registrar_proyecto.dart';

// Controlador para crear un proyecto
void crearProyecto(
  BuildContext context,
  String nombreProyecto,
  String materiaProyecto,
  int materiaProyectoId,
  DateTime fechaInicioProyecto,
  DateTime fechaFinalProyecto,
) {
  final ServicioRegistroProyectoBaseDatos servicioBaseDatos =
      ServicioRegistroProyectoBaseDatos();
  // print(nombreProyecto);
  // print(materiaProyecto);
  // print(materiaProyectoId);

  // Convert DateTime to Date
  // String fechaInicioProyectoDate =
  //     fechaInicioProyecto.toLocal().toString().split(' ')[0];
  // String fechaFinalProyectoDate =
  //     fechaFinalProyecto.toLocal().toString().split(' ')[0];

  // print(fechaInicioProyectoDate);
  // print(fechaFinalProyectoDate);

  servicioBaseDatos.guardarProyectoEnSupabase(nombreProyecto,
      fechaInicioProyecto, fechaFinalProyecto, materiaProyectoId);
}
