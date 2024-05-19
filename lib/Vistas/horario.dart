import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:studysphere/Controladores/controlador_horario.dart';

class Horario extends StatelessWidget {
  const Horario({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Crear algunos eventos de ejemplo
    List<Event> events = [
      Event(
        'Proyecto A',
        DateTime(2024, 5, 19, 10, 0),
        DateTime(2024, 5, 19, 12, 0),
        Colors.blue,
      ),
      Event(
        'Asignatura B',
        DateTime(2024, 5, 19, 11, 0),
        DateTime(2024, 5, 19, 13, 0),
        Colors.green,
      ),
      Event(
        'Reunión C',
        DateTime(2024, 5, 19, 11, 30),
        DateTime(2024, 5, 19, 12, 30),
        Colors.red,
      ),
      Event(
        'Asignatura D',
        DateTime(2024, 5, 20, 14, 0),
        DateTime(2024, 5, 20, 16, 0),
        Colors.purple,
      ),
      // Agrega más eventos aquí
    ];

    // Crear la fuente de datos personalizada
    EventDataSource dataSource = EventDataSource(events);

    return Scaffold(
      appBar: appBar(context, "Horario"),
      backgroundColor: colorScheme.background,
      body: SfCalendar(
        showNavigationArrow: true,
        allowedViews: const [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule,
          CalendarView.timelineMonth,
          CalendarView.timelineWeek
        ],
        allowViewNavigation: true,
        monthViewSettings: const MonthViewSettings(showAgenda: true),
        backgroundColor: colorScheme.surface,
        timeSlotViewSettings:
            const TimeSlotViewSettings(timeInterval: Duration(hours: 2)),
        dataSource: dataSource, // Aquí usamos nuestra propia fuente de datos
        view: CalendarView.week,
      ),
    );
  }
}
