// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AsignaturaHorario {
  final String nombre;
  final List<bool> diasSeleccionados;
  final List<String> horasInicio;
  final List<String> horasFin;
  final List<String> fechaInicio;
  final List<String> fechaFin;

  AsignaturaHorario({
    required this.nombre,
    required this.diasSeleccionados,
    required this.horasInicio,
    required this.horasFin,
    required this.fechaInicio,
    required this.fechaFin,
  });
}

actualizarHoraRecordatorio(id_recordatorio, hora_inicio, hora_final) async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;
  String fecha = DateFormat("yyyy-MM-dd").format(hora_inicio);
  String hora_ini = DateFormat.Hms().format(hora_inicio);
  String hora_fin = DateFormat.Hms().format(hora_final);
  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }
  final response = await supabase.from('recordatorios').update({
    'fecha': fecha,
    'hora_inicio': hora_ini,
    'hora_final': hora_fin
  }).eq('id', int.parse(id_recordatorio));
  print(response);
}

obtenerRecordatoriosPorUsuario() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;

  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }

  final response = await supabase
      .from('recordatorios')
      .select('nombre, fecha, hora_inicio, hora_final, id')
      .eq('usuario', userId);

  if (response.isEmpty) {
    print('Error al obtener recordatorios:');
    return [];
  }

  return response;
}

// Función para obtener las asignaturas desde la base de datos
Future<List<Map<String, dynamic>>> obtenerAsignaturasPorUsuario() async {
  final supabase = Supabase.instance.client;
  final Session? session = supabase.auth.currentSession;
  final userId = session?.user.id;

  if (userId == null) {
    throw ArgumentError('El userId no puede ser nulo');
  }

  final response = await supabase
      .from('asignaturas')
      .select(
          'nombre, dias_semana, hora_inicio, hora_final, fecha_inicio, fecha_final')
      .eq('id_usuario', userId);

  if (response.isEmpty) {
    print('Error al obtener asignaturas:');
    return [];
  }

  print(response);
  print("dentro antes servicio");

  return response;
}
