import 'package:flutter/material.dart';
import 'package:studysphere/Componentes/app_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:studysphere/Controladores/controlador_horario.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Horario extends StatefulWidget {
  const Horario({Key? key}) : super(key: key);

  @override
  _HorarioState createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  List<Appointment> _appointments = [];
  String? _errorMessage;
  CalendarController _calendarController = CalendarController();
  CalendarView _calendarView = CalendarView.week;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      List<Map<String, dynamic>> data = await fetchData();

      setState(() {
        _appointments = _processData(data);
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los eventos: $e';
      });
    }
  }

  List<Appointment> _processData(List<Map<String, dynamic>> data) {
    List<Appointment> appointments = [];

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
            currentDate = currentDate.add(Duration(days: 7));
          }
        }
      }
    }

    return appointments;
  }

  void _onViewChanged(CalendarView view) {
    setState(() {
      _calendarView = view;
    });
  }

  void _onPreviousView() {
    _calendarController.backward!();
  }

  void _onNextView() {
    _calendarController.forward!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Horario"),
        actions: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: _onPreviousView,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _onNextView,
          ),
          PopupMenuButton<CalendarView>(
            icon: Icon(Icons.view_agenda),
            onSelected: _onViewChanged,
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CalendarView>>[
              const PopupMenuItem<CalendarView>(
                value: CalendarView.day,
                child: Text('Día'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.week,
                child: Text('Semana'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.workWeek,
                child: Text('Semana laboral'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.month,
                child: Text('Mes'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.timelineDay,
                child: Text('Cronología día'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.timelineWeek,
                child: Text('Cronología semana'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.timelineWorkWeek,
                child: Text('Cronología semana laboral'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.timelineMonth,
                child: Text('Cronología mes'),
              ),
              const PopupMenuItem<CalendarView>(
                value: CalendarView.schedule,
                child: Text('Agenda'),
              ),
            ],
          ),
        ],
      ),
      body: _appointments.isNotEmpty
          ? SfCalendar(
              view: _calendarView,
              controller: _calendarController,
              dataSource: EventDataSource(_appointments),
              allowedViews: [
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
              showDatePickerButton: true,
              monthViewSettings: MonthViewSettings(
                showAgenda: true,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              timeSlotViewSettings: TimeSlotViewSettings(
                timeInterval: Duration(minutes: 30),
                timeFormat: 'HH:mm',
                startHour: 6,
                endHour: 23,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
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
