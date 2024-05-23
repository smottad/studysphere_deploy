import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studysphere/Controladores/controlador_horario.dart';

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
