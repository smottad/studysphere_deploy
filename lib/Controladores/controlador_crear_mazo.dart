import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_proyecto.dart';

TextEditingController nombreMazo = TextEditingController();

Future<Map<String, int>> getAsignaturas() async {
  final ServicioRegistroProyectoBaseDatos servicioBaseDatosGetAsignaturas =
      ServicioRegistroProyectoBaseDatos();
  return await servicioBaseDatosGetAsignaturas.obtenerAsignaturasPorUsuario();
}