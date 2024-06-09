import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_horario.dart';

class Event {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Event(this.eventName, this.from, this.to, this.background,
      {this.isAllDay = false});

  @override
  String toString() {
    return 'Event{name: $eventName, from: $from, to: $to, background: $background, isAllDay: $isAllDay}';
  }
}

// Obtener asignaturas desde la base de datos
Future<List<Map<String, dynamic>>> fetchData() async {
  // Aquí deberías tener tu lógica para obtener las asignaturas desde la base de datos.
  // Este es un ejemplo simulado de respuesta.
  List<Map<String, dynamic>> asignaturas = await obtenerAsignaturasPorUsuario();

  return asignaturas;
}
// // Crear el origen de datos de eventos
// EventDataSource dataSource = EventDataSource(events);

// List<Event> createRepeatedEvents(
//   String name,
//   DateTime startDate,
//   DateTime endDate,
//   TimeOfDay startTime,
//   TimeOfDay endTime,
//   List<int> daysOfWeek,
// ) {
//   List<Event> events = [];
//   DateTime currentDate = startDate;

//   while (
//       currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
//     if (daysOfWeek.contains(currentDate.weekday)) {
//       DateTime eventStartTime = DateTime(
//         currentDate.year,
//         currentDate.month,
//         currentDate.day,
//         startTime.hour,
//         startTime.minute,
//       );
//       DateTime eventEndTime = DateTime(
//         currentDate.year,
//         currentDate.month,
//         currentDate.day,
//         endTime.hour,
//         endTime.minute,
//       );

//       events.add(
//         Event(
//           name,
//           eventStartTime,
//           eventEndTime,
//           Colors.blue, // Puedes ajustar el color si lo necesitas
//         ),
//       );
//     }
//     currentDate = currentDate.add(Duration(days: 1)); // Avanza al siguiente día
//   }

//   return events;
// }

