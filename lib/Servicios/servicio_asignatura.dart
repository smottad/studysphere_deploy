import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studysphere/Controladores/controlador_crear_recordatorio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define una clase para representar las asignaturas
class Asignatura {
  final String id;
  final String nombre;
  final List<bool> diasSeleccionados;

  Asignatura(
      {required this.id,
      required this.nombre,
      required this.diasSeleccionados});
}

class ServicioBaseDatosAsignatura {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveAsignatura({
    context,
    required String nombre,
    required DateTime fechaDeInicio,
    required DateTime fechaDeFin,
    required List<String> dias,
    required TimeOfDay horaDeInicio,
    required TimeOfDay horaDeFin,
  }) async {
    String _timeOfDayToString(TimeOfDay time) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes:00';
    }

    final horaInicio24 = _timeOfDayToString(horaDeInicio);
    final horaFin24 = _timeOfDayToString(horaDeFin);

    final Session? session = supabase.auth.currentSession;

    print(nombre);
    print(fechaDeInicio);
    print(fechaDeFin);
    print(dias);
    print(horaInicio24);
    print(horaFin24);

    final response = await supabase.from('asignaturas').insert({
      'nombre': nombre,
      'id_usuario': session?.user.id,
      'fecha_inicio': fechaDeInicio.toIso8601String(),
      'fecha_final': fechaDeFin.toIso8601String(),
      'dias_semana': dias,
      'hora_inicio': horaInicio24,
      'hora_final': horaFin24,
    });
  }

// Función para obtener las asignaturas desde la base de datos
  Future<List<Asignatura>> obtenerAsignaturasPorUsuario() async {
    final supabase = Supabase.instance.client;
    final Session? session = supabase.auth.currentSession;
    final userId = session?.user.id;

    if (userId == null) {
      throw ArgumentError('El userId no puede ser nulo');
    }

    final response = await supabase
        .from('asignaturas')
        .select('id, nombre, dias_semana')
        .eq('id_usuario', userId);

    if (response.isEmpty) {
      print('Error al obtener asignaturas:');
      return [];
    }

    print(response);
    List<Asignatura> asignaturas = [];
    for (var row in response as List<Map<String, dynamic>>) {
      // Convertir la lista de strings 'true'/'false' a List<bool>
      List<bool> diasSeleccionados = (row['dias_semana'] as List<dynamic>)
          .map((e) => e == 'true')
          .toList();
      asignaturas.add(Asignatura(
        id: row['id'].toString(),
        nombre: row['nombre'],
        diasSeleccionados: diasSeleccionados,
      ));
    }
    print(asignaturas);
    return asignaturas;
  }
}

Future<void> updateAsignatura({
  context,
  required int idAsignatura, // El ID de la asignatura que quieres actualizar
  required String nombre,
  required DateTime fechaDeInicio,
  required DateTime fechaDeFin,
}) async {
  final SupabaseClient supabase = Supabase.instance.client;
  String _timeOfDayToString(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
  }

  final Session? session = supabase.auth.currentSession;

  try {
    final response = await supabase.from('asignaturas').update({
      'nombre': nombre,
      'fecha_inicio': fechaDeInicio.toIso8601String(),
      'fecha_final': fechaDeFin.toIso8601String(),
    }).eq('id',
        idAsignatura); // Filtra por el ID de la asignatura que deseas actualizar
  } catch (e) {
    // Maneja cualquier error que ocurra durante la actualización
    print('Error al actualizar la asignatura: $e');
    // Puedes lanzar el error nuevamente o manejarlo de alguna otra manera según tus necesidades
    rethrow;
  }
}
