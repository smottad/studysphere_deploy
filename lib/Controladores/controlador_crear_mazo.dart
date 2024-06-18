import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_proyecto.dart';

TextEditingController nombreMazoCrear = TextEditingController();

Future<Map<String, int>> getAsignaturasCrearMazo() async {
  final ServicioRegistroProyectoBaseDatos servicioBaseDatosGetAsignaturas =
      ServicioRegistroProyectoBaseDatos();
  return await servicioBaseDatosGetAsignaturas.obtenerAsignaturasPorUsuario();
}