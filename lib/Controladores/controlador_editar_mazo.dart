import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_proyecto.dart';

TextEditingController nombreMazo = TextEditingController();

Future<Map<String, int>> getAsignaturas() async {
  final ServicioRegistroProyectoBaseDatos servicioBaseDatosGetAsignaturas =
      ServicioRegistroProyectoBaseDatos();
  return await servicioBaseDatosGetAsignaturas.obtenerAsignaturasPorUsuario();
}

goToEditMaze(BuildContext context, EditMazeArguments args) {
  Navigator.pushNamed(context, '/inicio/mazos/editar_mazo', arguments: args);
}

goToMazes(BuildContext context,) {
  Navigator.pushNamed(context, '/inicio/mazos',);
}

class EditMazeArguments {
  EditMazeArguments(
    this.idMaze, 
    this.subjectMaze, 
    this.nameMaze,
    this.cantidad,
  );

  int idMaze;
  int cantidad;
  String subjectMaze;
  String nameMaze;
}