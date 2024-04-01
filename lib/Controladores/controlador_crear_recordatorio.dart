import 'package:flutter/material.dart';

var nombre = TextEditingController();
int? asignatura;
int? tipo;
var fecha = TextEditingController();
var hora = TextEditingController();
var prioridad = TextEditingController();
var temas = TextEditingController();

List<DropdownMenuEntry<int>> lista = [
  const DropdownMenuEntry(value: 0, label: 'ninguna'),
];
//esto deberia venir de la bd
Future<List<DropdownMenuEntry<int>>> getAsignaturasYProyectos() async {
  return lista;
}

//recibe en forma de indice
setAsignatura(int? value) {
  asignatura = value;
}

setTipo(int? value) {
  tipo = value;
}

mandarALaBD() {}
