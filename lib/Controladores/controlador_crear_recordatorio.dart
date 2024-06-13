import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:studysphere/Servicios/servicio_recordatorios.dart';

class AsignaturaOProyecto {
  final String id;
  final String nombre;
  final String tipo;
  //Proyect es 0, Asignatura es 1

  AsignaturaOProyecto(this.id, this.nombre, this.tipo);

  @override
  String toString() {
    return nombre; // Esto es lo que se mostrará en el dropdown
  }
}

// Lista inicial con una entrada de proyecto vacía
List<DropdownMenuEntry<String>> listaProyectos = [
  const DropdownMenuEntry(value: 'Ninguna', label: ''),
];

Future<List<DropdownMenuEntry<AsignaturaOProyecto>>> getProyectos() async {
  final ServicioRegistroRecordatorios servicioRegistroRecordatorios =
      ServicioRegistroRecordatorios();

  List<Map<String, dynamic>> proyectos =
      await servicioRegistroRecordatorios.obtenerProyectosPorUsuario();
  List<Map<String, dynamic>> asignaturas =
      await servicioRegistroRecordatorios.obtenerAsignaturasPorUsuario();

  List<DropdownMenuEntry<AsignaturaOProyecto>> listaProyectos = [];

  listaProyectos.addAll(proyectos.map((proyecto) {
    return DropdownMenuEntry(
      value: AsignaturaOProyecto(proyecto['id'], proyecto['nombre'], "0"),
      label: proyecto['nombre'],
    );
  }));

  listaProyectos.addAll(asignaturas.map((asignatura) {
    return DropdownMenuEntry(
      value: AsignaturaOProyecto(asignatura['id'], asignatura['nombre'], "1"),
      label: asignatura['nombre'],
    );
  }));

  return listaProyectos;
}

// //por el momento solo uso una lista con una asignatura/proyecto vació
// List<DropdownMenuEntry<String>> lista = [
//   const DropdownMenuEntry(value: 'Ninguna', label: 'Ninguna'),
// ];
// //esto deberia venir de la bd
// Future<List<DropdownMenuEntry<String>>> getProyectos(
// ) async {
//   ob();
//   return lista;
// }

bool? alarma = false;
var nombre = TextEditingController();
String? asignatura;
String? tipo;
TimeOfDay? startHour;
TimeOfDay? endHour;
DateTime? date;
String? tipoDato;
//estos son formato String y las que estan en ingles fecha y tiempo
var horaInicio = TextEditingController();
var horaFin = TextEditingController();
var fecha = TextEditingController();
var prioridad = TextEditingController();
var temas = TextEditingController();

String? nombreValidator_;
String? prioridadValidator_;

Future<bool> sendToBD(BuildContext context) async {
  final ServicioRegistroRecordatorios servicioRegistroRecordatorios =
      ServicioRegistroRecordatorios();

  try {
    print(startHour);
    print(endHour);
    print(date);
    print("id: $asignatura");

    bool resultado = await servicioRegistroRecordatorios.registrarRecordatorio(
      nombre.text,
      asignatura!,
      tipoDato!,
      tipo!,
      date!,
      startHour!,
      endHour!,
      prioridad.text.isEmpty ? 0 : int.parse(prioridad.text),
      temas.text,
      alarma!,
      context, // Pasar context como un parámetro adicional
    );

    print("aca2");
    print(resultado);

    return resultado;
  } catch (error) {
    // Manejar cualquier error que pueda ocurrir durante el proceso de registro
    print('Error al registrar el recordatorio: $error');
    return false;
  }
}

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
  var id = Random(1).nextInt(1000);

  try {
    var resultado = sendToBD(context);

    if (await resultado) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recordatorio guardado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar el recordatorio'),
            backgroundColor: Colors.red,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  } catch (error) {
    print('Error al enviar a la base de datos: $error');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar el recordatorio'),
          backgroundColor: Colors.red,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  if (alarma!) {
    await crearAlarma(id);
  }
  await anadirAlCalendario();
  if (context.mounted) {
    Navigator.pop(context);
  }
}

crearAlarma(id) async {
  final horaAlarma =
      date!.copyWith(hour: startHour?.hour, minute: startHour?.minute);
  final alarmSettings = AlarmSettings(
      id: id,
      dateTime: horaAlarma,
      assetAudioPath: 'lib/Assets/alarma.wav',
      notificationTitle: '$tipo de $asignatura',
      notificationBody: 'Alarma',
      volume: 1,
      loopAudio: true);
  await Alarm.set(alarmSettings: alarmSettings);
}

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
// crearRecordatorio(BuildContext context) {
//   Navigator.pushNamed(context, '/inicio');
// }

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
setAsignaturaID(String? value, String? tipoValor) {
  asignatura = value;
  //tipo de asginatura o proyecto
  tipoDato = tipoValor;
}

setTipo(String? value) {
  tipo = value;
}
