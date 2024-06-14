import 'package:flutter/material.dart';
import 'package:studysphere/Servicios/servicio_horario.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:studysphere/Controladores/controlador_horario.dart';

class Horario extends StatefulWidget {
  const Horario({super.key});

  @override
  State<Horario> createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      List<Map<String, dynamic>> data = await fetchData();
      List<Map<String, dynamic>> data2 = await obtenerRecordatoriosPorUsuario();

      setState(() {
        _appointments = _processData(data, data2);
      });
    } catch (e) {
      setState(() {});
    }
  }

  List<Appointment> _processData(List<Map<String, dynamic>> data, data2) {
    List<Appointment> appointments = [];

    for (var event in data2) {
      String fecha = event['fecha'];
      String nombre = event['nombre'];
      String horaInicio = event['hora_inicio'];
      String horaFinal = event['hora_final'];
      DateTime startTime = DateTime.tryParse('$fecha $horaInicio')!;
      DateTime endTime = DateTime.tryParse('$fecha $horaFinal')!;
      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }

      appointments.add(Appointment(
        id: '${event['id']}',
        startTime: startTime,
        endTime: endTime,
        subject: nombre,
        color: Colors.green,
      ));
    }
    for (var event in data) {
      DateTime fechaInicio = DateTime.parse(event['fecha_inicio']);
      DateTime fechaFinal = DateTime.parse(event['fecha_final']);
      List<String> diasSemana = List<String>.from(event['dias_semana']);
      String nombre = event['nombre'];
      String horaInicio = event['hora_inicio'];
      String horaFinal = event['hora_final'];

      for (int i = 0; i < diasSemana.length; i++) {
        if (diasSemana[i] == 'true') {
          DateTime currentDate = fechaInicio.add(Duration(days: i));
          while (currentDate.isBefore(fechaFinal) ||
              currentDate.isAtSameMomentAs(fechaFinal)) {
            DateTime startTime = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              int.parse(horaInicio.split(':')[0]),
              int.parse(horaInicio.split(':')[1]),
            );
            DateTime endTime = DateTime(
              currentDate.year,
              currentDate.month,
              currentDate.day,
              int.parse(horaFinal.split(':')[0]),
              int.parse(horaFinal.split(':')[1]),
            );

            appointments.add(Appointment(
              startTime: startTime,
              endTime: endTime,
              subject: nombre,
              color: Colors.blue,
            ));
            currentDate = currentDate.add(const Duration(days: 7));
          }
        }
      }
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Horario"),
        ),
        body: SfCalendar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          view: CalendarView.week,
          dataSource: EventDataSource(_appointments),
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.workWeek,
            CalendarView.month,
            CalendarView.timelineDay,
            CalendarView.timelineWeek,
            CalendarView.timelineWorkWeek,
            CalendarView.timelineMonth,
            CalendarView.schedule,
          ],
          allowViewNavigation: true,
          showNavigationArrow: true,
          allowAppointmentResize: true,
          allowDragAndDrop: true,
          showDatePickerButton: true,
          onAppointmentResizeEnd: (AppointmentResizeEndDetails details) {
            if (details.appointment.color != Colors.green) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                      "No es posible modificar horarios de asignaturas desde aquí")));
              return;
            }
            actualizarHoraRecordatorio(
                details.appointment.id, details.startTime, details.endTime);
          },
          onDragEnd: (AppointmentDragEndDetails details) {
            var idk = details.appointment.toString().split(': ');
            if (idk[8].contains('0xff4caf50') == false) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                      "No es posible modificar horarios de asignaturas desde aquí")));
              return;
            }
            var fechaInicio = DateTime.tryParse(idk[12].split(',')[0].trim());
            var fechaFinal = DateTime.tryParse(idk[13].split(',')[0].trim());
            var id = idk[10].split(',')[0].trim();
            actualizarHoraRecordatorio(id, fechaInicio, fechaFinal);
          },
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
          timeSlotViewSettings: const TimeSlotViewSettings(
            timeInterval: Duration(minutes: 30),
            timeFormat: 'HH:mm',
            startHour: 6,
            endHour: 23,
          ),
        ));
  }

  Future<List<Map<String, dynamic>>> fetchDataej() async {
    // Simulación de datos que regresarían de la base de datos.
    return [
      {
        'nombre': 'Ingenieria de software 2',
        'dias_semana': [true, false, true, false, true, false, false],
        'hora_inicio': '13:59:00',
        'hora_final': '17:59:00',
        'fecha_inicio': '2024-05-20',
        'fecha_final': '2024-05-23',
      },
      {
        'nombre': 'Sis Info',
        'dias_semana': [false, true, false, true, false, false, false],
        'hora_inicio': '17:27:00',
        'hora_final': '19:27:00',
        'fecha_inicio': '2024-05-20',
        'fecha_final': '2024-05-31',
      },
    ];
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
