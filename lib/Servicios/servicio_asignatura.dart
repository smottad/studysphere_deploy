import 'package:flutter/material.dart';
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
    String timeOfDayToString(TimeOfDay time) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes:00';
    }

    final horaInicio24 = timeOfDayToString(horaDeInicio);
    final horaFin24 = timeOfDayToString(horaDeFin);

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
        .select('id, nombre, dias_semana, fecha_final')
        .eq('id_usuario', userId);

// Filtra las asignaturas en el cliente para excluir las que ya pasaron
    final now = DateTime.now();
    List<Asignatura> asignaturas = [];
    for (var row in response) {
      final fechaFinal = DateTime.parse(row['fecha_final']);

      // Solo agregar las asignaturas cuya fecha final es mayor o igual a la fecha actual
      if (fechaFinal.isAfter(now) || fechaFinal.isAtSameMomentAs(now)) {
        List<bool> diasSeleccionados = (row['dias_semana'] as List<dynamic>)
            .map((e) => e == 'true')
            .toList();
        asignaturas.add(Asignatura(
          id: row['id'].toString(),
          nombre: row['nombre'],
          diasSeleccionados: diasSeleccionados,
        ));
      }
    }

    print(asignaturas);
    return asignaturas;
  }

// Función para obtener las asignaturas desde la base de datos
  Future<List<Asignatura>> obtenerAsignaturasPorUsuarioAntiguas() async {
    final supabase = Supabase.instance.client;
    final Session? session = supabase.auth.currentSession;
    final userId = session?.user.id;

    if (userId == null) {
      throw ArgumentError('El userId no puede ser nulo');
    }

    final response = await supabase
        .from('asignaturas')
        .select('id, nombre, dias_semana, fecha_final')
        .eq('id_usuario', userId);

    if (response.isEmpty) {
      print('Error al obtener asignaturas:');
      return [];
    }
    // Filtra las asignaturas en el cliente para incluir solo las que ya pasaron
    final now = DateTime.now();
    List<Asignatura> asignaturasPasadas = [];
    for (var row in response) {
      final fechaFinal = DateTime.parse(row['fecha_final']);

      // Solo agregar las asignaturas cuya fecha final es anterior a la fecha actual
      if (fechaFinal.isBefore(now)) {
        List<bool> diasSeleccionados = (row['dias_semana'] as List<dynamic>)
            .map((e) => e == 'true')
            .toList();
        asignaturasPasadas.add(Asignatura(
          id: row['id'].toString(),
          nombre: row['nombre'],
          diasSeleccionados: diasSeleccionados,
        ));
      }
    }
    return asignaturasPasadas;
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
  String timeOfDayToString(TimeOfDay time) {
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

    rethrow;
  }
}

Future<void> deleteAsignatura(String idAsignatura) async {
  final SupabaseClient supabase = Supabase.instance.client;

  try {
    await supabase.from('asignaturas').delete().eq('id',
        idAsignatura); // Filtra por el ID de la asignatura que deseas eliminar
  } catch (e) {
    // Maneja cualquier error que ocurra durante la eliminación
    print('Error al eliminar la asignatura: $e');
    rethrow;
  }
}
