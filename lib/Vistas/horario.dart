import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Horario extends StatelessWidget {
  const Horario({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    //final textTheme = Theme.of(context).textTheme;
    //final size = MediaQuery.of(context).size;

    //var calendario = CalendarController();
    return Scaffold(
      appBar: appBar(context, "Horario"),
      backgroundColor: colorScheme.background,
      body: SfCalendar(
        showNavigationArrow: true,
        //controller: calendario,
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
        //dataSource: , AQUI USARIAMOS NUESTRO PROPIO CALENDARIO
        view: CalendarView.week,
      ),
    );
  }
}
