import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_asignatura.dart';

var name = TextEditingController();
var initial_date = TextEditingController();
var final_date = TextEditingController();

class ControllerCalendar {
  DateTime dateTimeVar;
  String label = "";

  ControllerCalendar(this.dateTimeVar, this.label);

  DateTime compareDate(DateTime selectedDate, DateTime otherDate) {
    if (selectedDate.isBefore(otherDate)) {
      return selectedDate;
    }

    return otherDate;
  }

  void setDateTimeVar(DateTime date) {
    dateTimeVar = date;
  }

  DateTime getDateTimeVar() {
    return dateTimeVar;
  }

  void setLabel(String label) {
    this.label = label;
  }

  String getLabel() {
    return label;
  }
}

class ControllerTime {
  TimeOfDay? time;

  ControllerTime({this.time});
}

String _timeOfDayToString(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return dt.toIso8601String().split('T')[1];
}

void guardarAsignatura(
  BuildContext context,
  String nombre,
  DateTime fechaDeInicio,
  DateTime fechaDeFin,
  List<String> dias,
  horaDeInicio,
  horaDeFin,
) async {
  final ServicioBaseDatosAsignatura servicioBaseDatos =
      ServicioBaseDatosAsignatura();

  try {
    print('Guardando asignatura');
    await servicioBaseDatos.saveAsignatura(
      context: context,
      nombre: nombre,
      fechaDeInicio: fechaDeInicio,
      fechaDeFin: fechaDeFin,
      dias: dias,
      horaDeInicio: horaDeInicio,
      horaDeFin: horaDeFin,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asignatura guardada con éxito')),
    );
  } catch (e) {
    print('Error al guardar la asignatura: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar la asignatura: $e')),
    );
  }
}
