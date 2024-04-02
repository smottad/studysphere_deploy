import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

//por el momento solo uso una lista con una asignatura/proyecto vació
List<DropdownMenuEntry<String>> lista = [
  const DropdownMenuEntry(value: 'Ninguna', label: 'Ninguna'),
];
//esto deberia venir de la bd
Future<List<DropdownMenuEntry<String>>> getAsignaturasYProyectos() async {
  return lista;
}

bool? alarma = false;
var nombre = TextEditingController();
String? asignatura;
String? tipo;
TimeOfDay? startHour;
TimeOfDay? endHour;
DateTime? date;
//estos son formato String y las que estan en ingles fecha y tiempo
var horaInicio = TextEditingController();
var horaFin = TextEditingController();
var fecha = TextEditingController();
var prioridad = TextEditingController();
var temas = TextEditingController();

String? nombreValidator_;
String? prioridadValidator_;

validarNombre() {
  //alfabetico + ñ + espacio
  RegExp regExp = RegExp(r"^[a-zA-ZñÑ ]+$");
  if (nombre.text.isEmpty) {
    nombreValidator_ = 'Ingrese su nombre';
  } else if (!regExp.hasMatch(nombre.text)) {
    nombreValidator_ = 'Ingrese un nombre válido';
  } else {
    nombreValidator_ = null;
  }
}

validarPrioridad() {
  if (prioridad.text.isEmpty) {
    prioridadValidator_ = 'Ingrese una prioridad';
  } else if (int.tryParse(prioridad.text) == null) {
    prioridadValidator_ = 'Ingrese un número válido';
  } else if (int.parse(prioridad.text) > 5 || int.parse(prioridad.text) < 1) {
    prioridadValidator_ = 'Ingrese un número entre 1-5';
  } else {
    prioridadValidator_ = null;
  }
}

funcionGuardar(BuildContext context) async {
  if (nombreValidator_ != null || nombre.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese un nombre válido')));
  }
  if (asignatura == null) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una asignatura')));
  }
  if (tipo == null) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor ingrese el tipo de recordatorio')));
  }
  if (startHour == null) {
    return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese la hora de inicio')));
  }
  if (endHour != null && endHour!.hour < startHour!.hour) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Por favor ingrese una hora de finalizado posterior a la de inicio')));
  }
  if (endHour?.hour == startHour?.hour && endHour!.minute < startHour!.minute) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Por favor ingrese una hora de finalizado posterior a la de inicio')));
  }
  if (prioridadValidator_ != null || prioridad.text.isEmpty) {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor ingrese una prioridad válida')));
  }
  if (alarma!) {
    crearAlarma();
  }
  await anadirAlCalendario();
  if (context.mounted) {
    Navigator.pop(context);
  }
}

crearAlarma() {}

anadirAlCalendario() async {
  DateTime fechaInicioEvento;
  DateTime fechaFinalEvento;
  if (endHour != null) {
    fechaInicioEvento =
        date!.copyWith(hour: startHour?.hour, minute: startHour?.minute);
    fechaFinalEvento =
        date!.copyWith(hour: endHour?.hour, minute: endHour?.minute);
  } else {
    fechaInicioEvento =
        date!.copyWith(hour: startHour?.hour, minute: startHour?.minute);
    fechaFinalEvento =
        date!.copyWith(hour: (startHour!.hour + 1), minute: startHour?.minute);
  }

  final Event event = Event(
    title: '$tipo de $asignatura',
    description: 'Creado automáticamente por Study Sphere',
    startDate: fechaInicioEvento,
    endDate: fechaFinalEvento,
  );
  await Add2Calendar.addEvent2Cal(event);
}

//mandar a la bd
crearRecordatorio(BuildContext context) {
  Navigator.pushNamed(context, '/inicio');
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
  endHour = await showTimePicker(
      context: context, initialTime: startHour ?? TimeOfDay.now());
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

setTipo(String? value) {
  tipo = value;
}
