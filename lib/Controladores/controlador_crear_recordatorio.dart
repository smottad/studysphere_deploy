import 'package:flutter/material.dart';

var nombre = TextEditingController();
String? asignatura;
int? tipo;
TimeOfDay? startHour;
TimeOfDay? endHour;
DateTime? date;
//estos son formato String y las que estan en ingles fecha y tiempo
var horaInicio = TextEditingController();
var horaFin = TextEditingController();
var fecha = TextEditingController();
var prioridad = TextEditingController();
var temas = TextEditingController();

List<DropdownMenuEntry<String>> lista = [
  const DropdownMenuEntry(value: 'Ninguna', label: 'Ninguna'),
];
//esto deberia venir de la bd
Future<List<DropdownMenuEntry<String>>> getAsignaturasYProyectos() async {
  return lista;
}

escogerFecha(BuildContext context) async {
  //que no salga el teclado
  FocusScope.of(context).requestFocus(FocusNode());
  date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 65)));
  fecha.text = '${date?.day}/${date?.month}/${date?.year}';
}

escogerHoraInicio(BuildContext context) async {
  //que no salga el teclado
  FocusScope.of(context).requestFocus(FocusNode());
  startHour =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (startHour == null) {
    return;
  }
  //formato para que no se vea 8:8 sino 08:08
  horaInicio.text =
      '${(startHour?.hour)! < 10 ? '0${startHour?.hour}' : startHour?.hour}:${(startHour?.minute)! < 10 ? '0${startHour?.minute}' : startHour?.minute}';
}

escogerHoraFinal(BuildContext context) async {
  //que no salga el teclado
  FocusScope.of(context).requestFocus(FocusNode());
  endHour =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (endHour == null) {
    return;
  }
  //formato para que no se vea 8:8 sino 08:08
  horaFin.text =
      '${(endHour?.hour)! < 10 ? '0${endHour?.hour}' : endHour?.hour}:${(endHour?.minute)! < 10 ? '0${endHour?.minute}' : endHour?.minute}';
}

//recibe en forma de indice
setAsignatura(String? value) {
  asignatura = value;
}

setTipo(int? value) {
  tipo = value;
}

mandarALaBD(BuildContext context) {
  Navigator.pushNamed(context, '/inicio');
}
