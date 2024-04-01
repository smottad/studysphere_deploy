import 'package:flutter/material.dart';

var nombre = TextEditingController();
int? asignatura;
int? tipo;
TimeOfDay? hour;
DateTime? date;
//estos son formato String y los que estan en ingles fecha y tiempo
var hora = TextEditingController();
var fecha = TextEditingController();
var prioridad = TextEditingController();
var temas = TextEditingController();

List<DropdownMenuEntry<int>> lista = [
  const DropdownMenuEntry(value: 0, label: 'ninguna'),
];
//esto deberia venir de la bd
Future<List<DropdownMenuEntry<int>>> getAsignaturasYProyectos() async {
  return lista;
}

escogerFecha(BuildContext context) async {
  FocusScope.of(context).requestFocus(FocusNode());
  date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 65)));
  fecha.text = '${date?.month}/${date?.day}/${date?.year}';
}

escogerHora(BuildContext context) async {
  FocusScope.of(context).requestFocus(FocusNode());
  hour = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (hour == null) {
    return;
  }
  hora.text =
      '${(hour?.hour)! < 10 ? '0${hour?.hour}' : hour?.hour}:${(hour?.minute)! < 10 ? '0${hour?.minute}' : hour?.minute}';
}

//recibe en forma de indice
setAsignatura(int? value) {
  asignatura = value;
}

setTipo(int? value) {
  tipo = value;
}

mandarALaBD() {}
